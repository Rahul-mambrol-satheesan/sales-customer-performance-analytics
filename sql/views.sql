USE sales_analytics;

DROP VIEW IF EXISTS vw_monthly_performance;
CREATE VIEW vw_monthly_performance AS
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(net_sales) AS revenue,
    SUM(gross_profit) AS profit,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(net_sales) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM fact_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m');

DROP VIEW IF EXISTS vw_product_performance;
CREATE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(f.net_sales) AS revenue,
    SUM(f.gross_profit) AS profit,
    SUM(f.quantity) AS units_sold
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category;

DROP VIEW IF EXISTS vw_customer_performance;
CREATE VIEW vw_customer_performance AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.region,
    c.customer_segment,
    COUNT(DISTINCT f.order_id) AS orders,
    SUM(f.net_sales) AS revenue,
    SUM(f.gross_profit) AS profit,
    AVG(f.net_sales) AS average_order_value
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name, c.region, c.customer_segment;
