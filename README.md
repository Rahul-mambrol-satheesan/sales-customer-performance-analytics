# Sales & Customer Performance Analytics

An end-to-end Data Analyst portfolio project demonstrating **SQL, Python, ETL, data quality, exploratory analysis and Power BI**.

## Business Scenario

You are a Data Analyst supporting an e-commerce/retail business. Leadership wants a reliable view of sales, customer and product performance.

The objective is to transform raw operational data into validated analytical datasets and an executive-ready Power BI dashboard.

## Tech Stack

- Python
- Pandas / NumPy
- MySQL 8
- SQL
- Power BI
- Git / GitHub

## Project Workflow

```text
Raw CSV files
     ↓
Python ETL
     ↓
Data-quality validation
     ↓
Cleaned datasets
     ↓
MySQL analytical model
     ↓
SQL analysis / views
     ↓
Power BI dashboard
     ↓
Business insights
```

## Repository Structure

```text
sales-customer-performance-analytics/
│
├── data/
│   ├── raw/
│   │   ├── customers.csv
│   │   ├── products.csv
│   │   └── orders.csv
│   └── processed/
│
├── python/
│   └── etl_and_data_quality.py
│
├── sql/
│   ├── schema.sql
│   ├── business_analysis_questions.sql
│   ├── views.sql
│   └── data_quality_validation.sql
│
├── powerbi/
│   └── dashboard_specification.md
│
├── documentation/
│   ├── business_questions.md
│   ├── data_dictionary.md
│   ├── data_source.md
│   └── interview_questions.md
│
├── reports/
│
├── screenshots/
├── requirements.txt
└── README.md
```

## How to Run

### 1. Clone the repository

```bash
git clone <https://github.com/Rahul-mambrol-satheesan/sales-customer-performance-analytics.git>
cd sales-customer-performance-analytics
```

### 2. Install Python dependencies

pip install -r requirements.txt

### 3. Run the ETL and data-quality pipeline

python python/etl_and_data_quality.py

This creates:

- `data/processed/customers_clean.csv`
- `data/processed/products_clean.csv`
- `data/processed/orders_clean.csv`
- `reports/data_quality_report.csv`
- `reports/customer_metrics.csv`
- `reports/order_metrics.csv`

### 4. Load the processed data into MySQL

Create the database and tables using:

sql/schema.sql

Then load:

```text
customers_clean.csv → dim_customer
products_clean.csv  → dim_product
orders_clean.csv    → fact_sales
```

### 5. Run SQL analysis

Open:

```text
sql/business_analysis_questions.sql
```

The file contains questions and SQL solutions covering:
- monthly performance
- regional performance
- top products
- product profitability
- new vs returning customers
- customer ranking
- month-over-month growth
- channel performance
- discount analysis
- high-value customers

### 6. Build Power BI dashboard

Follow:

```text
powerbi/dashboard_specification.md
```

Recommended pages:

1. Executive Overview
2. Product Performance
3. Customer Analytics
4. Data Quality

## Key Data Quality Issues Included

The raw dataset intentionally contains:
- duplicate order IDs
- missing customer IDs
- invalid quantities
- invalid discount values

The Python pipeline identifies and removes invalid records before analytical reporting.

## Key Analytical KPIs

- Revenue
- Gross Profit
- Profit Margin
- Orders
- Customers
- Average Order Value
- Units Sold
- Customer Revenue
- Month-over-Month Growth
- Regional Performance
- Product Performance

## Business Questions

See:

`documentation/business_questions.md`

## Data Dictionary

See:

`documentation/data_dictionary.md`

## Data Source

The data is synthetic and generated specifically for this portfolio project.


`documentation/data_source.md`

## Portfolio Outcome

This project demonstrates the ability to:

- translate business questions into analytical requirements
- work with relational business data
- build ETL processes
- perform data-quality validation
- write analytical SQL
- use CTEs and window functions
- perform customer and product analysis
- calculate business KPIs
- prepare data for Power BI
- communicate analytical results to stakeholders




