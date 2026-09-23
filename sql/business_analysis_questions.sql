USE sales_analytics;

-- Q1. Monthly revenue and profit
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(net_sales) AS revenue,
    SUM(gross_profit) AS profit,
    COUNT(DISTINCT order_id) AS orders
FROM fact_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Q2. Revenue by region
SELECT
    region,
    SUM(net_sales) AS revenue,
    SUM(gross_profit) AS profit,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(gross_profit) / NULLIF(SUM(net_sales),0) * 100, 2) AS profit_margin_pct
FROM fact_sales
GROUP BY region
ORDER BY revenue DESC;

-- Q3. Top 10 products by revenue
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(f.net_sales) AS revenue,
    SUM(f.gross_profit) AS profit
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- Q4. Product profitability
SELECT
    p.category,
    SUM(f.net_sales) AS revenue,
    SUM(f.gross_profit) AS profit,
    ROUND(SUM(f.gross_profit) / NULLIF(SUM(f.net_sales),0) * 100, 2) AS margin_pct
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY profit DESC;

-- Q5. New vs returning customers by month
WITH customer_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS order_number
    FROM fact_sales
)
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(CASE WHEN order_number = 1 THEN 1 ELSE 0 END) AS new_customer_orders,
    SUM(CASE WHEN order_number > 1 THEN 1 ELSE 0 END) AS returning_customer_orders
FROM customer_orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Q6. Customer ranking by revenue
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(net_sales) AS revenue
    FROM fact_sales
    GROUP BY customer_id
)
SELECT
    customer_id,
    revenue,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank
LIMIT 20;

-- Q7. Month-over-month revenue growth
WITH monthly AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(net_sales) AS revenue
    FROM fact_sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month),0) * 100, 2
    ) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Q8. Average order value by sales channel
SELECT
    sales_channel,
    COUNT(DISTINCT order_id) AS orders,
    SUM(net_sales) AS revenue,
    ROUND(SUM(net_sales) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM fact_sales
GROUP BY sales_channel
ORDER BY average_order_value DESC;

-- Q9. Discount impact
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        ELSE '21%+'
    END AS discount_band,
    COUNT(DISTINCT order_id) AS orders,
    SUM(net_sales) AS revenue,
    SUM(gross_profit) AS profit,
    ROUND(SUM(gross_profit) / NULLIF(SUM(net_sales),0) * 100, 2) AS margin_pct
FROM fact_sales
GROUP BY discount_band
ORDER BY discount_band;

-- Q10. High-value customers
WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS orders,
        SUM(net_sales) AS revenue,
        SUM(gross_profit) AS profit
    FROM fact_sales
    GROUP BY customer_id
)
SELECT *
FROM customer_metrics
WHERE revenue >= (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue)
    FROM customer_metrics
)
ORDER BY revenue DESC;
