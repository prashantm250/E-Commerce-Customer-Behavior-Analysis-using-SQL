select * from customer_analysis;

-- total number of records
select count(*) from customer_analysis

-- sample of the dataset
select * from customer_analysis
limit 10

-- product categories 
select distinct product_category from customer_analysis

-- Checking for null values
select * from customer_analysis
where Order_ID is null or Customer_ID is null or Date is null or Age is null or Gender is null or City is null or Product_Category is null
or Unit_Price is null or Quantity is null or Discount_Amount is null or Total_Amount is null or Payment_Method is null or Device_Type is null  or Session_Duration_Minutes is null
or Pages_Viewed is null or Is_Returning_Customer is null or Delivery_Time_Days is null or Customer_Rating is null

-- Business KPI's
-- Total revenue
select sum(Total_Amount) from customer_analysis

-- Total orders
select count(distinct order_ID) from customer_analysis

-- Unique Customers 
select count(distinct customer_ID) from customer_analysis

-- Average Order Value
select round(sum(total_amount)/count(Order_ID),2) as avg_order_value from customer_analysis

-- Returning Customer % 
select 
       round(
             sum(case when Is_Returning_Customer=True then 1 else 0 end)*100.0
             /count(*),2
			)as returning_customer_percentage
	from customer_analysis

-- Average Rating 
select 
      avg(Customer_Rating) as customer_avg_rating 
	from customer_analysis

-- Average Delivery Time 
select 
      avg(Delivery_Time_Days) as avg_delivery_time 
    from customer_analysis

-- Total Discount Given
select 
     sum(Discount_Amount) as Discount_given 
	from customer_analysis



-- BUSINESS QUESTIONS

-- 1.Which gender spends more?
select 
      Gender, sum(Total_Amount) as Total_spend 
	from customer_analysis
group by Gender
order by Total_spend desc

-- 2.Which payment method generates the highest revenue?
select 
      Payment_Method, round(sum(Total_Amount),2) as Revenue 
	from customer_analysis
 group by Payment_Method
 order by Revenue desc
 
--  3.How many orders were placed from each device type?























