-- MySQL 8.0
-- Sales & Customer Performance Analytics

CREATE DATABASE IF NOT EXISTS sales_analytics;
USE sales_analytics;

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_customer;

CREATE TABLE dim_customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(150),
    region VARCHAR(30),
    signup_date DATE,
    customer_segment VARCHAR(30)
);

CREATE TABLE dim_product (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(12,2),
    unit_cost DECIMAL(12,2),
    product_status VARCHAR(30)
);

CREATE TABLE fact_sales (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    discount DECIMAL(6,4) NOT NULL,
    shipping_cost DECIMAL(12,2),
    region VARCHAR(30),
    sales_channel VARCHAR(30),
    payment_method VARCHAR(30),
    gross_sales DECIMAL(14,2),
    discount_amount DECIMAL(14,2),
    net_sales DECIMAL(14,2),
    estimated_cost DECIMAL(14,2),
    gross_profit DECIMAL(14,2),
    profit_margin DECIMAL(10,4),
    order_month CHAR(7),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);
