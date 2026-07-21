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

# 📊 SQL Concepts Used
- SELECT
- WHERE
- GROUP BY
- ORDER BY
- CASE WHEN
- Aggregate Functions
- CTEs
- Window Functions
- Common Table Expressions
- Subqueries
- Date Functions
- Joins
- Ranking Functions

---

# 💻 SQL Analysis - solving business questions
1. Which gender spends more?
```sql
select 
      Gender, sum(Total_Amount) as Total_spend 
	from customer_analysis
group by Gender
order by Total_spend desc
```
2.Which payment method generates the highest revenue?
```sql
select 
      Payment_Method, round(sum(Total_Amount),2) as Revenue 
	from customer_analysis
 group by Payment_Method
 order by Revenue desc
```
3.How many orders were placed from each device type?
```sql
select 
      Device_Type, count(*) as Total_orders 
	from customer_analysis
  group by Device_Type
```
4.Which cities have the highest returning customer percentage?
```sql
select 
      City, 
      round(
      sum(case when Is_Returning_Customer=True then 1 else 0 end)*100
      /count(*),
      2
      ) as Returning_Customer_percentage 
	from customer_analysis
  group by City
  order by Returning_Customer_percentage desc
```
5.Does longer delivery time reduce customer ratings?
```sql
select 
case
    when Delivery_Time_Days <= 3 then "0-3 days"
	when Delivery_Time_Days <=7 then "4-7 days"
	else "More than 7 days" 
 end as delivery_time,
count(*) as Total_orders,
round(avg(Customer_Rating),2) as avg_rating
from customer_analysis
group by delivery_time
order by delivery_time
```
6.Which cities consistently deliver late?
```sql
select 
     City,
     count(*) as Total_orders, 
	sum(
     case 
         when Delivery_Time_Days>7 then 1 else 0 end) as late_delivered_orders 
	 from customer_analysis
group by City
order by late_delivered_orders desc,Total_orders desc
```
7.Which product categories have both high revenue and high customer satisfaction?
```sql
select 
      Product_Category, 
      round(sum(Total_Amount),0) as Revenue, 
       max(Customer_Rating) as Rating 
	from customer_analysis
group by Product_Category
order by Revenue desc , Rating desc
limit 1
```
8.What percentage of revenue comes from each product category?
```sql
select 
      Product_Category,
      round(sum(Total_Amount),2) as category_Revenue, 
      round(sum(Total_Amount)*100/(select sum(Total_Amount) from customer_analysis),2) as Revenue_percentage 
	from customer_analysis
group by Product_Category
order by category_Revenue desc, Revenue_percentage desc
```
9.Find the top 5 customers contributing the highest percentage of total revenue.
```sql
select  
      distinct customer_ID, 
       round(sum(Total_Amount),2) as Revenue,
       round(sum(Total_Amount)*100/(select sum(Total_Amount) from customer_analysis),2) as Revenue_percentage
	from customer_analysis
    group by customer_ID
    order by Revenue desc, Revenue_percentage desc
    limit 5
```
10.Rank all cities based on total revenue.
```sql
select 
     City,
     round(sum(Total_Amount),2) as Total_Revenue, 
     dense_rank() over(order by sum(Total_Amount) desc) as Rnk 
	from customer_analysis
group by City
```
11.Find customers whose spending is above the overall average customer spending.
```sql
select 
      customer_ID,sum(Total_Amount) as Revenue 
  from customer_analysis
  group by customer_ID
  having Revenue>(select avg(Total_Amount) as avg_spending 
		   from customer_analysis)
```
12.Identify customers who made more than one purchase.
```sql
select 
      customer_ID, count(*) as Total_orders 
	from customer_analysis
    group by customer_ID
    having Total_orders>1
    order by Total_orders desc
```
13.Find customers who gave ratings below average despite receiving deliveries faster than average.
```sql
select 
     customer_ID,
     Order_ID, 
     Product_Category, 
     Delivery_Time_Days, 
     Customer_Rating
 from customer_analysis
 where Customer_Rating<(select avg(Customer_Rating) from customer_analysis)
 and 
       Delivery_Time_Days<(select avg(Delivery_Time_Days) from customer_analysis)
```
14.Find the revenue growth percentage month over month.
```sql
with cte as (
            select date_format(str_to_date(`Date`,"%d/%m/%Y"),"%Y-%m") as month, 
            round(sum(Total_Amount),2) as Revenue 
		from customer_analysis group by month)
select 
     month,
	 Revenue,
     lag(Revenue) over(order by month) as Previous_Revenue, 
     round( (Revenue - lag(Revenue) over(order by month))*100/lag(Revenue) over(order by month),2) as month_over_month_growth
from cte
```
15.Find the Top 3 highest-selling product categories in each city.
```sql
with cte as (
             select City,product_category,sum(Quantity
) as Total_Quantity 
		from customer_analysis group by City, product_category
),
ate as (
        select City, product_category, Total_Quantity , dense_rank() over(partition by City order by Total_Quantity desc) as rnk 
	from cte
)
select * from ate
where rnk<=3
order by City, rnk
```
16.Which 20% of customers generate approximately 80% of the company's revenue?
```sql
with CustomerRevenue as
(
    select
        Customer_ID,
        sum(Total_Amount) as Revenue
    from customer_analysis
    group by Customer_ID
),

RevenueCTE as
(
    select
        Customer_ID,
        Revenue,

        round(
            sum(Revenue) over(order by Revenue desc)
            *100.0/
            sum(Revenue) over(),
            2
        ) as Cum_Revenue_Percentage

    from CustomerRevenue
)

select *
from RevenueCTE
where Cum_Revenue_Percentage <= 80
order by  Revenue desc;
```
17.Which combination of product category and city has the lowest customer rating?
```sql
select 
     City, 
	 product_category, 
     avg(Customer_Rating) as lowest_avg_rating 
   from customer_analysis
   group by City, Product_Category
   order by lowest_avg_rating
   limit 1
```
18.Which cities have delivery times significantly higher than the company average?
```sql
select 
      City,
      avg(Delivery_Time_Days)as Avg_delivery_days, 
      count(*) as Total_Orders 
   from customer_analysis
   group by City
   having avg(Delivery_Time_Days)>
                                 (select avg(Delivery_Time_Days) as Avg_delivery_days 
								from customer_analysis)
   order by Avg_delivery_days desc
```
19.Estimate revenue lost because of discounts by category.
```sql
select 
      product_category,
      round(sum(Unit_Price*Quantity),1) as Total_Revenue,
      round(sum(Discount_Amount),1) as Revenue_Lost,
      round(sum(Total_Amount),1) as Actual_Revenue
	from customer_analysis
    group by product_category
    order by Total_Revenue desc
```
20.Which customer age group generates the highest profit opportunity (high revenue + repeat purchases)
```sql
select 
 case
    when Age between 17 and 28 then "17-28"
    when Age between 28 and 40 then "39-40"
    when Age between 40 and 60 then "41-60"
    when Age >60 then "60+"
    end as Age_group,
    round(sum(total_Amount),2) as Revenue, 
    count(*) as Total_Orders, 
    sum(case when Is_Returning_Customer=true then 1 else 0 end) as Repeat_customer 
  from customer_analysis
  group by Age_group
  order by Revenue desc
```
21.Which device type has the highest returning customer rate?
```sql
select 
     Device_Type, 
	 sum(case when Is_Returning_Customer=true then 1 else 0 end) as Repeat_customer_orders,
     round(sum(case when Is_Returning_Customer=true then 1 else 0 end)*100/count(*),2) Repeat_customer_rate 
  from customer_analysis
  group by Device_Type
  order by Repeat_customer_rate desc
```
22.Find customers who spend above average but consistently give poor ratings.
```sql
with cte as (
            select * from customer_analysis where Total_Amount>(
			select avg(Total_Amount) as Avg_Spend 
	from customer_analysis))
select 
      Customer_ID, 
	  round(avg(Total_Amount), 2) as avg_spending, 
	  round(avg(Customer_Rating), 2) as avg_rating, count(*)  
	from cte
    group by  Customer_ID
    having avg_rating<3
    order by avg_spending desc
```
23.Which product categories perform well on Mobile but poorly on Desktop?
```sql
select 
      Product_Category,
      round(sum(case when Device_Type="Mobile" then Total_Amount else 0 end),2) as Mobile_Revenue, 
      round(sum(case when Device_Type="Desktop" then Total_Amount else 0 end),2) as Desktop_Revenue
	from customer_analysis
    group by Product_Category
    having round(sum(case when Device_Type="Mobile" then Total_Amount else 0 end),2)>
    round(sum(case when Device_Type="Desktop" then Total_Amount else 0 end),2)
   order by Mobile_Revenue desc
```
24.Identify customers likely to churn (single purchase + low rating + long delivery time).
```sql
select 
     customer_ID, 
     Delivery_Time_Days, 
     Customer_Rating 
  from customer_analysis
  where Is_Returning_Customer=false
  and Delivery_Time_Days>=10
  and Customer_Rating<=3
```
25.Compare revenue generated by new vs. returning customers over time.
```sql
select 
     date_format(str_to_date(`Date`,"%d/%m/%Y"),"%Y") as year,
     round(sum(case when Is_Returning_Customer=false then Total_Amount else 0 end),2) as New_customer_Revenue,
     round(sum(case when Is_Returning_Customer=true then Total_Amount else 0 end),2) as Repeat_customer_Revenue 
 from customer_analysis
 group by year
```
26.Detect seasonal trends in product category sales.
```sql
with cte as (
            select 
                 concat(year(str_to_date(`Date`,"%d/%m/%Y")),"-Q",quarter(str_to_date(`Date`,"%d/%m/%Y"))) as year_quarter, 
                 product_category, round(sum(Total_Amount),2) as Revenue,
                 dense_rank() over(partition by concat(year(str_to_date(`Date`,"%d/%m/%Y")),"-Q",quarter(str_to_date(`Date`,"%d/%m/%Y"))) order by round(sum(Total_Amount),2)  desc) as rnk 
 from customer_analysis
 group by 1,2
 order by 1,3 desc)
 select year_quarter, product_category, Revenue, rnk from cte
 where rnk=1
```
27.Identify categories where higher discounts do not increase sales volume.
```sql
select Product_Category, avg(Discount_Amount) as Avg_discount , sum(Quantity) as volume from customer_analysis
group by Product_Category
order by Avg_discount desc, volume asc
```
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

---
# 📬 Contact

**Prashant Myakal**

📧 Email: prashantmyakal145@gmail.com

💼 LinkedIn: www.linkedin.com/in/prashant-myakal-10233626a

💻 GitHub: https://github.com/prashantm250

----
