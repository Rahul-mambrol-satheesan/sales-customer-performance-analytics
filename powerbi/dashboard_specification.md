# Power BI Dashboard Specification

Use `reports/order_metrics.csv` and `reports/customer_metrics.csv` after running the Python ETL script.

## Page 1 — Executive Overview

### KPI cards
- Total Revenue
- Gross Profit
- Profit Margin
- Total Orders
- Total Customers
- Average Order Value

### Visuals
1. Monthly Revenue and Profit trend
2. Revenue by Region
3. Revenue by Sales Channel
4. Revenue vs Profit by Month

### Slicers
- Date
- Region
- Sales Channel
- Customer Segment
- Product Category

## Page 2 — Product Performance

### KPI cards
- Units Sold
- Revenue
- Profit
- Margin %

### Visuals
1. Top 10 Products by Revenue
2. Product Category Revenue
3. Product Category Profit
4. Revenue vs Margin scatter plot
5. Discount Band vs Profit Margin

## Page 3 — Customer Analytics

### KPI cards
- Active Customers
- Repeat Customers
- High-Value Customers
- Average Customer Revenue

### Visuals
1. Customer Revenue Distribution
2. Revenue by Customer Segment
3. Top 20 Customers
4. Revenue by Region and Customer Segment
5. Orders vs Revenue scatter plot

## Page 4 — Data Quality

Use `reports/data_quality_report.csv`.

Show:
- Total checks
- Failed records
- Pass rate
- Quality check table

## Suggested DAX measures

```DAX
Total Revenue = SUM(order_metrics[net_sales])

Total Profit = SUM(order_metrics[gross_profit])

Total Orders = DISTINCTCOUNT(order_metrics[order_id])

Total Customers = DISTINCTCOUNT(order_metrics[customer_id])

Average Order Value =
DIVIDE([Total Revenue], [Total Orders])

Profit Margin =
DIVIDE([Total Profit], [Total Revenue])
```

## Dashboard design rule

Do not fill the dashboard with charts. Every visual should answer a business question.
