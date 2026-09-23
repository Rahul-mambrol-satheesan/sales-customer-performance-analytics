# Data Dictionary

## customers.csv

| Column | Description |
|---|---|
| customer_id | Unique customer identifier |
| first_name | Customer first name |
| last_name | Customer last name |
| email | Synthetic customer email |
| region | Customer region |
| signup_date | Customer registration date |
| customer_segment | Consumer, Small Business, or Enterprise |

## products.csv

| Column | Description |
|---|---|
| product_id | Unique product identifier |
| product_name | Product name |
| category | Product category |
| unit_price | Standard selling price |
| unit_cost | Estimated product cost |
| product_status | Product status |

## orders.csv

| Column | Description |
|---|---|
| order_id | Unique order identifier |
| customer_id | Customer identifier |
| product_id | Product identifier |
| order_date | Order date |
| quantity | Units purchased |
| unit_price | Price charged per unit |
| discount | Discount as decimal |
| shipping_cost | Shipping cost |
| region | Region associated with order |
| sales_channel | Online, Retail Store, or Partner |
| payment_method | Payment method |

## Calculated fields

| Field | Formula |
|---|---|
| gross_sales | quantity × unit_price |
| discount_amount | gross_sales × discount |
| net_sales | gross_sales − discount_amount |
| estimated_cost | quantity × unit_cost |
| gross_profit | net_sales − estimated_cost − shipping_cost |
| profit_margin | gross_profit ÷ net_sales |
