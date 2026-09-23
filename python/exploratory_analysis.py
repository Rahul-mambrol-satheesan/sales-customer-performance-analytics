import pandas as pd
import matplotlib.pyplot as plt

orders = pd.read_csv("../reports/order_metrics.csv", parse_dates=["order_date"])

monthly = orders.groupby("order_month").agg(
    revenue=("net_sales", "sum"),
    profit=("gross_profit", "sum"),
    orders=("order_id", "nunique")
).reset_index()

print(monthly)

monthly.plot(x="order_month", y=["revenue", "profit"], figsize=(12, 6))
plt.title("Monthly Revenue and Profit")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
