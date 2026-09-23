USE sales_analytics;

-- Data quality validation checks

-- 1. Duplicate order IDs
SELECT order_id, COUNT(*) AS record_count
FROM fact_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 2. Missing customer IDs
SELECT COUNT(*) AS missing_customer_ids
FROM fact_sales
WHERE customer_id IS NULL;

-- 3. Invalid quantities
SELECT COUNT(*) AS invalid_quantities
FROM fact_sales
WHERE quantity <= 0;

-- 4. Invalid discounts
SELECT COUNT(*) AS invalid_discounts
FROM fact_sales
WHERE discount < 0 OR discount > 0.50;

-- 5. Orphan customers
SELECT COUNT(*) AS orphan_customers
FROM fact_sales f
LEFT JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 6. Orphan products
SELECT COUNT(*) AS orphan_products
FROM fact_sales f
LEFT JOIN dim_product p ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 7. Recalculate revenue and compare to stored net_sales
SELECT COUNT(*) AS calculation_mismatches
FROM fact_sales
WHERE ABS(
    net_sales - ((quantity * unit_price) - (quantity * unit_price * discount))
) > 0.01;
