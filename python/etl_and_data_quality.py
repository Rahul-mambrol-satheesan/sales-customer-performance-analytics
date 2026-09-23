"""
Sales & Customer Performance Analytics
ETL + Data Quality Pipeline

Input:
    data/raw/customers.csv
    data/raw/products.csv
    data/raw/orders.csv

Output:
    data/processed/customers_clean.csv
    data/processed/products_clean.csv
    data/processed/orders_clean.csv
    reports/data_quality_report.csv
    reports/customer_metrics.csv
    reports/order_metrics.csv
"""

from pathlib import Path
import pandas as pd
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
PROCESSED = ROOT / "data" / "processed"
REPORTS = ROOT / "reports"

PROCESSED.mkdir(parents=True, exist_ok=True)
REPORTS.mkdir(parents=True, exist_ok=True)

customers = pd.read_csv(RAW / "customers.csv", parse_dates=["signup_date"])
products = pd.read_csv(RAW / "products.csv")
orders = pd.read_csv(RAW / "orders.csv", parse_dates=["order_date"])

quality = []

def add_check(name, total, failed, rule):
    quality.append({
        "check_name": name,
        "total_records": int(total),
        "failed_records": int(failed),
        "pass_rate": round((1 - failed/total) * 100, 2) if total else 100,
        "rule": rule
    })

add_check(
    "Duplicate orders", len(orders),
    int(orders.duplicated(subset=["order_id"]).sum()),
    "order_id must be unique"
)
add_check(
    "Missing customer IDs", len(orders),
    int(orders["customer_id"].isna().sum()),
    "customer_id is required"
)
add_check(
    "Invalid quantities", len(orders),
    int((orders["quantity"] <= 0).sum()),
    "quantity must be greater than zero"
)
add_check(
    "Invalid discounts", len(orders),
    int(((orders["discount"] < 0) | (orders["discount"] > 0.50)).sum()),
    "discount must be between 0% and 50%"
)
add_check(
    "Unknown customers", len(orders),
    int((~orders["customer_id"].isin(customers["customer_id"].dropna())).sum()),
    "customer_id must exist in customer master"
)
add_check(
    "Unknown products", len(orders),
    int((~orders["product_id"].isin(products["product_id"])).sum()),
    "product_id must exist in product master"
)

# Clean order data
orders_clean = orders.drop_duplicates(subset=["order_id"]).copy()
orders_clean = orders_clean[
    orders_clean["customer_id"].notna()
    & orders_clean["quantity"].gt(0)
    & orders_clean["discount"].between(0, 0.50)
    & orders_clean["customer_id"].isin(customers["customer_id"])
    & orders_clean["product_id"].isin(products["product_id"])
].copy()

orders_clean["gross_sales"] = orders_clean["quantity"] * orders_clean["unit_price"]
orders_clean["discount_amount"] = orders_clean["gross_sales"] * orders_clean["discount"]
orders_clean["net_sales"] = orders_clean["gross_sales"] - orders_clean["discount_amount"]
orders_clean["estimated_cost"] = (
    orders_clean["quantity"] *
    orders_clean["product_id"].map(products.set_index("product_id")["unit_cost"])
)
orders_clean["gross_profit"] = (
    orders_clean["net_sales"] - orders_clean["estimated_cost"] - orders_clean["shipping_cost"]
)
orders_clean["profit_margin"] = np.where(
    orders_clean["net_sales"] != 0,
    orders_clean["gross_profit"] / orders_clean["net_sales"],
    0
)
orders_clean["order_month"] = orders_clean["order_date"].dt.to_period("M").astype(str)

customers.to_csv(PROCESSED / "customers_clean.csv", index=False)
products.to_csv(PROCESSED / "products_clean.csv", index=False)
orders_clean.to_csv(PROCESSED / "orders_clean.csv", index=False)

# Customer-level metrics
cust = orders_clean.groupby("customer_id").agg(
    total_orders=("order_id", "nunique"),
    total_revenue=("net_sales", "sum"),
    total_profit=("gross_profit", "sum"),
    total_units=("quantity", "sum"),
    avg_order_value=("net_sales", "mean"),
    last_order_date=("order_date", "max")
).reset_index()

cust["customer_lifetime_days"] = (
    cust["last_order_date"] - pd.to_datetime("2024-01-01")
).dt.days
cust["customer_value_segment"] = pd.qcut(
    cust["total_revenue"], q=4,
    labels=["Low Value", "Mid-Low", "Mid-High", "High Value"],
    duplicates="drop"
)

cust.to_csv(REPORTS / "customer_metrics.csv", index=False)

# Order-level metrics for Power BI
orders_clean.to_csv(REPORTS / "order_metrics.csv", index=False)

pd.DataFrame(quality).to_csv(REPORTS / "data_quality_report.csv", index=False)

print("ETL completed.")
print(f"Raw orders: {len(orders):,}")
print(f"Clean orders: {len(orders_clean):,}")
print(f"Removed/invalid rows: {len(orders) - len(orders_clean):,}")
print(f"Reports written to: {REPORTS}")
