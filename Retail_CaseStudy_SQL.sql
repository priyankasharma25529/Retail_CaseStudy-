show schemas;
use new_schema;
/*
Retail CaseStudy
1.Data Problem
2.Hypothesis
3.Data understanding the Date cLEANING
4.Analysis(EDA)
*/

/*
3.Data UNderstanding an Data cleaning*/
#Learn about the table

-- 3.1 Learning about the table and Data fields

select * from customer_profiles;
/*With customer_profiles ,
We have
customerID-unique or not?
Age,Gender,Location of customer
Joining Date of customer is this first purchase or first failed purchase?
col Name ï»¿CustomerID to--> CustomerID
How Many Rows?
*/

select * from product_inventory;
/*
col Name ï»¿ProductID--> ProductID
unique row?
ProductName -->how many product do we have?
Category -->how many category do we have and which category comes under which Product?
StockLevel means? inventory means?
Price --> individual Price
How Many Rows?
*/
select * from sales_transaction;
/*
col Name ï»¿TransactionID-->TransactionID
CustomerID
ProductID

PM and FK?
*/

-- 3.2 Learning more about Tables
DESC customer_profiles;
DESC product_inventory;
DESC sales_transaction;

# Rename column Name for customer_profiles
ALTER  Table customer_profiles
change ï»¿CustomerID CustomerID INT;

select * from customer_profiles;

# Rename column Name for product_inventory
ALTER  Table product_inventory
change ï»¿ProductID ProductID INT;

select * from product_inventory;

# Rename column Name for sales_transaction
ALTER  Table sales_transaction
change ï»¿TransactionID TransactionID INT;
select * from sales_transaction;

-- 3.3 What is primary key in  each tables?
select customerID ,count(*) from customer_profiles
group by customerID 
having count(*)>1;
-- for sales product_inventory
select ProductID,count(*) from product_inventory
group by productID
having count(*) >1;-- productID as a PK 
-- for sales transaction 
select * from sales_transaction;
select TransactionID,count(*) from sales_transaction
group by TransactionID
having count(*)>1;

/*
comm-sufi
two of  4999 and 5000 are repeated
*/

-- 	WE have to remove the duplicates
-- Create a dummy table
-- Insert data into dummy table
-- drop the actual table
-- rename the dummy table to the actual table

CREATE table sales_transaction_nodup as 
select distinct * from sales_transaction;

select * from sales_transaction_nodup;

DROP table  sales_transaction; 

alter table sales_transaction_nodup 
rename  to  sales_transaction;

select * from sales_transaction;
/*
3.4understand the connection
*/

select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;

select * from sales_transaction as st
left join product_inventory as pi 
on pi.ProductID=st.ProductID
where pi.ProductID IS Null; -- what i am missing?

/*
LEFT JOIN 
ROW 1 matches with Row1
ROW 2 matches with  other table
*/

-- Row1 --> Row2
-- Row2 --> NA
Select 
  st.TransactionID,
  pi.ProductID,
  st.Price  as st_price,
  pi.price as  pi_price
from sales_transaction st 
join Product_inventory pi on st.ProductID=pi.ProductID
where st.price <> pi.price;

select pi.productID,pi.price as pi_price 
from product_inventory pi where pi.productID = 51;
select st.TransactionID,st.ProductID ,st.price as st_price 
from sales_transaction as st where st.productID=51;

/* GOAL?
-- 1.lOOK INTO CORRECT PRICE FROM PRODUCT_INVENTORY TABLE  --93.12
-- 2.UPDATE ALL THE THE ROW WHICH IS PRESENT IN SALES_TRANSACTION TABLE 
-- WHERE PRICE IS WRONG OR 9312
*/

SELECT Pi.ProductID
from product_inventory as pi
join sales_transaction as st
on pi.productID=st.productID
WHERE pi.productID=st.productID;

SET SQL_SAFE_UPDATES = 0; -- SQL safe update start

UPDATE sales_transaction  st 
join product_inventory  pi  on pi.ProductID=st.ProductID
SET st.Price=pi.Price -- all the values 100 = 100
WHERE st.price <> pi.price
AND st.TransactionID is not null;

/*update sales_transaction st -- updating sales table  -- 90 = 90 what price  100
SET Price = ( select  pi.price 
              from product_inventory pi
              where st.productID=pi.productID)
 WHERE st.ProductID in (
 select productID from product_inventory
 where pi.price <> st.price
 );*/  #ALTERenate approach 
 
 -- 	why do we need to use subquery
 --     we are multiple table --join and Sub query
 
 --     What are we trying to do?
 
 #sSUB QUERY NOTES
 -- What we are tryind to do?

/*
| Subquery Type           | Used In                  | Returns                    | Why Use It (One-Line Purpose)                               | Example                                                                       | Relationship Type           |
| ----------------------- | ------------------------ | -------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------------------------- | --------------------------- |
| **Scalar Subquery**     | `SELECT`, `SET`, `WHERE` | Single value               | To fetch **1 value** (cell) per row or per query            | `SELECT name, (SELECT MAX(salary) FROM employees)`                            | **1-to-1**                  |
| **Column Subquery**     | `IN`, `= ANY`, etc.      | One column, many rows      | To compare a value against a **list** of values             | `WHERE dept_id IN (SELECT dept_id FROM departments)`                          | **1-to-Many**               |
| **Table Subquery**      | In `FROM` clause         | A virtual table            | To build a **temporary table** for filtering or joining     | `SELECT * FROM (SELECT * FROM sales WHERE price > 100)`                       | **Many-to-Many** or **N/A** |
| **Correlated Subquery** | `WHERE`, `EXISTS`, `SET` | Re-evaluated per outer row | To fetch related data **row-by-row** from outer query       | `WHERE EXISTS (SELECT 1 FROM orders WHERE orders.customer_id = customers.id)` | **1-to-Many**               |
 
 /*
 3.3 check for the primary key
 3.4 check validation - join
 3.5 compare value and check  for the discrepancy-- join and --update -- subquery
 */
 
 /*3.6 -- Missing value and workin on NULL
 */
 
 select count(*) from customer_profiles 
 where location='';
 update customer_profiles 
 set location='unknown';

update customer_profiles 
 set location='unknown'
 where location is null;
 
 select count(*) from customer_profiles 
 where location='';
 /*3.7
 
 */
 -- 1. SALES_TRANSACTION
 select * from sales_transaction;
 desc sales_transaction;
 
 Create table sales_transaction_updated as
 select * ,cast(TransactionDate as date) as TransactionDate_updated
 from sales_transaction;
 
select * from sales_transaction_updated;
DROP table sales_transaction; 
ALTER TABLE sales_transaction_updated
RENAME  to sales_transaction;

-- 2. Customer_profiles
 select * from customer_profiles;
 Create table Customer_profiles_updated as
 select * ,cast(JoinDate as date) as JoinDate_updated
 from Customer_profiles;
 
select * from Customer_profiles_updated;
DROP table Customer_profiles; 
ALTER TABLE Customer_profiles_updated
RENAME  to Customer_profiles;

-- setting a prmary key
ALTER TABLE customer_profiles 
add primary key (CustomerID);

ALTER TABLE product_inventory
add primary key (ProductID);

ALTER TABLE sales_transaction 
add primary key (TransactionID);
/*
1.what is the table and how to know the table and col
2.try finding out the primary key and how to check (Group by and Having)
3.Relationship between table-- join
4.Discrepency in the table and price (UPDATE ,JOIN and Sub Query)
5.null missing values
6. Date format and update with Diff table
*/
-- EDA

select JoinDate,str_to_date(JoinDate,'%d/%m/%y') as updated_date,
joindate_updated from customer_profiles;

SET SQL_SAFE_UPDATES=0;

UPDATE customer_profiles
set joindate_updated= str_to_date(JoinDate,'%d/%m/%y');

select * from customer_profiles;

select * from sales_transaction;
update sales_transaction
set TransactionDate_updated=str_to_date(TransactionDate,'%d/%m/%y');

#EDA
/*
Distribution of customer_profiles Table
*/
select count(*) from customer_profiles;

select Location,count(*) as count
from customer_profiles
group by Location
order by count DESC;

select month(JoinDate_updated) as month,
count(*) as count_month
from customer_profiles
group by month;

select DAY(JoinDate_updated) as Day,
count(*) as count_Day
from customer_profiles
group by Day;

select 
    Gender,
    round(avg(Age),2) as Avg_age,
    count(*) as Total_customer
from customer_profiles
group by Gender;

/*Product_inventory Distribution*/

select count(*) from product_inventory;

select Category,count(*) as count
from product_inventory
group by Category
order by count DESC;

select ProductName,count(*) as count
from product_inventory
group by ProductName
having count>1;

select 
    Category,
    count(productName) as count_Product,
    sum(StockLevel) as sum_stocklevel,
    round(avg(Stocklevel),2) as avg_stocklevel
from product_inventory
group by Category
order by sum_stocklevel;

-- STEP 3:

/*
Distribution of sales_transaction Table
*/
select count(*) from sales_transaction;

select TransactionID,count(*) as count
from sales_transaction
group by TransactionID
order by count DESC;

select month(TransactionDate_updated) as month,
count(*) as count_month
from sales_transaction
group by month;

select Day(TransactionDate_updated) as  YEAR,
count(*) as count_day
from sales_transaction
group by Day;


select 
    TransactionID,QuantityPurchased,
    round(avg(QuantityPurchased),2) as Avg_purchased
from sales_transaction
group by TransactionID,QuantityPurchased;

/*
 EDA 1- Summary of Total Sales and quantity sold per product
*/

select
pi.ProductName,
PI.ProductID,
sum(st.QuantityPurchased*st.Price) as total_sales,
sum(st.QuantityPurchased)
from sales_transaction st 
join product_inventory as pi 
on st.ProductID=pi.ProductID
Group by pi.ProductID,pi.ProductName;

select
pi.ProductName,
PI.ProductID,
sum(st.QuantityPurchased*st.Price) as total_sales,
sum(st.QuantityPurchased)
from sales_transaction st 
join product_inventory as pi 
on st.ProductID=pi.ProductID
Group by pi.ProductID,pi.ProductName;

select
pi.Category,
round(sum(st.QuantityPurchased*st.Price),2) as total_sales,
sum(st.QuantityPurchased),
round(avg(st.price),2) as avg_price
from sales_transaction st 
join product_inventory as pi 
on st.ProductID=pi.ProductID
Group by pi.Category 
order by total_sales desc;

/*
  Customer Purchase Frequency
*/

select * from sales_transacion;
select 
CustomerID,
count(*) as total_transaction
from sales_transaction
group by CustomerID
order by total_transaction desc;

/*Step:7 -- Product Cateogy Performance*/
select
pi.Category,
round(sum(st.QuantityPurchased*st.Price),2) as total_sales,
sum(st.QuantityPurchased) as total_quantity
from sales_transaction st 
join product_inventory as pi 
on st.ProductID=pi.ProductID
Group by pi.Category
order by total_Sales desc;

/*Step:8 Highest Product Sales top 10 or top 5*/
select 
ProductID,
round(sum(QuantityPurchased*Price),2) as total_sales
from sales_transaction
group by ProductID
order by total_sales desc
limit 5;

/*Step:9 Lowest Product Sales top 10 or top 5*/
select 
ProductID,
round(sum(QuantityPurchased*Price),2) as total_sales
from sales_transaction
group by ProductID
order by total_sales 
limit 5;
/* 
Step 10 : Sales Trends
Write a SQL query to find the sales Trend TO UNDERSTAND THE REVENUE Pattern of the company
*/

select 
year(TransactionDate_updated) as year,
month(TransactionDate_updated) as month,
round(sum(QuantityPurchased),2) as total_Sales,
count(*) as Total_trans
from sales_transaction
group by year,month;

/*Growth rate of sales M-o-M
Write a SQL query understand month to month growth rate of sales of  the company
which will help to  understand the growth trend of company
*/
with monthly_sales as 
(
select 
extract(month from TransactionDate_updated) as  month,
round(sum(QuantityPurchased*Price),2) as total_Sales
from sales_transaction
group by extract(month from TransactionDate_updated)
)
    select 
          month,
          total_Sales ,
          lag(total_Sales)over(order by month) as Previous_month_Sales,
          ((total_sales-lag(total_Sales)over(order by month)))  / 
          lag(total_Sales)over(order by month)*100 as monthly_Growth
   from monthly_sales;



select   
          month,
          total_sales,
          lag(total_Sales)over(order by month) as Previous_month_Sales,
          ((total_sales-lag(total_Sales)over(order by month)) / 
          lag(total_Sales)over(order by month)*100) as monthly_sales 
from (
select 
     extract(month from TransactionDate_updated) as  month,
     round(sum(QuantityPurchased*Price),2) as total_Sales
from 
     sales_transaction
group by 
      extract(month from TransactionDate_updated)
)as monthly_sales
order by 
   month;
/*Step:- Customers- High purchase Frequency and Revenue*/
select 
      CustomerID,
      count(*) as Frequency,
      round(sum(QuantityPurchased*Price),2) as total_Sales
from 
     sales_transaction
group by 
     CustomerID
having Frequency>10 and total_Sales>1000 
order by 
    Frequency DESC;
   
/*Step:-13 Occasoinal Customers - Low Purchase Customers
*/
select 
      CustomerID,
      count(*) as Frequency,
      round(sum(QuantityPurchased*Price),2) as total_Sales
from 
     sales_transaction
group by 
     CustomerID
having Frequency<=2
order by 
    Frequency DESC;
/*step 14: Repeat Purchase Pattern*/
select CustomerID,ProductID,count(*) as transaction
from sales_transaction
group by CustomerID,ProductID
having transaction > 1
order by CustomerID ;

select CustomerID,count(ProductID) as count_of_products
from sales_transaction
group by CustomerID
having count_of_products > 1
order by count_of_products DESC ;
/*Step 15: - Lyality Indecator*/

select * from sales_transaction;
WITH Trans_Date as(
  select CustomerID,
      str_to_date(TransactionDate_updated,'%Y-%m-%d') as transactionDate
      from sales_transaction
)
select CustomerID,
min(transactionDate) as FirstPurchase,
max(transactionDate) as LastPurchase,
(max(transactionDate) - min(transactionDate)) as DayBetween
from Trans_Date
group by CustomerID
having DayBetween>365
order by DayBetween DESC;
-- comeback
-- Calculate Customer with  windows function  + add transaction table
/*step:16 Customer Segmentation based on Quantitity Purchased*/

sELECT * FROM SALES_TRANSACTION; 
create table Cust_Segment as
select CustomerID,
       CASE 
        WHEN TotalQuantity> 30 Then 'High'
        WHEN TotalQuantity Between 10 and 30 THEN 'Medium'
        WHEN TotalQuantity Between 1 and 10 THEN 'Low'
       ELSE 'Nono' 
       END as Customer_Segment
       From (
	  select a.CustomerID,
       sum(QuantityPurchased) as TotalQuantity 
       from 
       customer_profiles as a
       join sales_transaction as b on a.CustomerID=b.CustomerID
       GROUP  BY a.CustomerID) as t;
     select * from cust_segment;  
     
     create VIEW vw_Cust_Segment as
       select CustomerID,
       CASE 
        WHEN TotalQuantity> 30 Then 'High'
        WHEN TotalQuantity Between 10 and 30 THEN 'Medium'
        WHEN TotalQuantity Between 1 and 10 THEN 'Low'
       ELSE 'Nono' 
       END as Customer_Segment
       From (
	  select a.CustomerID,
       sum(QuantityPurchased) as TotalQuantity 
       from 
       customer_profiles as a
       join sales_transaction as b on a.CustomerID=b.CustomerID
       GROUP  BY a.CustomerID) as t;
     
     /*Step:17 -- */
     
       




