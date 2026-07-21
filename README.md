# E-Commerce-Customer-Behavior-Analysis-using-SQL
# 📌 Project Overview

This project analyzes E-Commerce Customer Behavior using MySQL to uncover business insights related to customer retention, revenue trends, sales performance, delivery efficiency, discounts, and customer satisfaction.

The objective is to transform raw transactional data into actionable business insights that help improve profitability, customer experience, and decision-making.

---
# 📊 Dataset Overview
The dataset contains customer purchase transactions with information including:

Customer Details,
Product Category,
Product Price,
Quantity Purchased,
Order Date,
City,
Device Type,
Payment Method,
Customer Rating,
Delivery Time,
Discount,
Customer Type (New/Returning)

---
 # 🔍 Data Exploration
 - Counted the total number of records in the dataset
 - Viewed a sample of the dataset to understand structure and content
 - Checked for null values across all columns
 - Identified distinct product categories available in the dataset

```sql
Total number of records

select count(*) from customer_analysis

Sample of the dataset

select * from customer_analysis
limit 10

Checking for null values

select * from customer_analysis
where Order_ID is null
or Customer_ID is null
or Date is null
or Age is null
or Gender is null
or City is null
or Product_Category is null
or Unit_Price is null
or Quantity is null
or Discount_Amount is null
or Total_Amount is null
or Payment_Method is null
or Device_Type is null
or Session_Duration_Minutes is null
or Pages_Viewed is null
or Is_Returning_Customer is null
or Delivery_Time_Days is null
or Customer_Rating is null

Product categories

select distinct product_category from customer_analysis
```
---
# 🔄 Project Workflow
```text
E-Commerce Dataset
        │
        ▼
Loaded into MySQL using Sqlalchemy
        │
        ▼
SQL Business Analysis
        │
        ▼
Business Insights
        │
        ▼
Business Recommendations
```

---

# 📈 Key Performance Indicators (KPIs)
-  Total revenue -> 21.78 M
-  Total orders  -> 17049
-  Unique Customers  -> 5000
-  Average Order Value -> 1277.44
-  Returning Customer % -> 88.21%
-  Average customer Rating -> 3.89
-  Average Delivery Time -> 6.5 days
-  Total Discount Given -> 1.19 M

---

#  📊 Business Insights
 - Repeat customers generated approximately 86% of total revenue in 2023, which increased to nearly 98% in 2024. Meanwhile, the contribution from new customers dropped from 14.1% to just 2.3%, indicating that revenue has become highly dependent on existing customers and highlighting the need to strengthen new customer acquisition strategies.
 - Electronics is the highest revenue-generating category, contributing nearly 50% of total revenue across all seasons, making it the company's most profitable product category.
 - Although Electronics generates the highest revenue, it does not rank among the top five categories by sales quantity. Sports records the highest units sold, indicating Electronics has a significantly higher average selling price.
 - Home & Garden and Sports are the next strongest contributors, while categories like Books and Beauty generate comparatively lower revenue.
 - Istanbul generates the highest sales revenue, followed by Ankara and Izmir.
 - These cities should receive more marketing focus, inventory allocation, and promotional campaigns.
 - Discounts account for approximately 5% of potential revenue loss. Furthermore, product categories receiving the highest discounts are not showing proportional increases in sales volume, suggesting current discount strategies are not maximizing profitability.
 - Customer churn analysis identified 118 high-risk customers who placed only one order, rated their experience below 3 stars, and experienced delivery times exceeding 10 days, indicating service quality and delivery delays as major churn drivers.

---

# 💡 Business Recommendations
- Increase inventory and marketing investment for Electronics, the highest revenue category.
- Launch loyalty programs to convert first-time buyers into returning customers.
- Improve delivery speed to increase customer satisfaction and reduce negative review.
- Lower-performing cities may require localized offers to increase customer engagement.
