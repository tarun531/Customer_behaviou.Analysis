-- Q1: Revenue by gender
SELECT gender, SUM(purchase_amount) AS revenue
FROM customer
GROUP BY gender;

-- This revenue helps for better targeting and improving products

-- Q2: Customers with discount and above average purchase
SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes'
AND purchase_amount >= (
    SELECT AVG(purchase_amount) FROM customer
);

-- Q3 which are the top 5 products with highest avg rating
select item_purchased, round(avg(review_rating),2) as "Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- Q4 compare the avg purchase b/w standard and express shipping
select shipping_type,
round(avg(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type;


-- Q5 do subscribed customers spend more? compare avg spend and total revenue b/w subscribers and non sub

select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;

-- q6 which products have the highest % of purchase after discount applied
select item_purchased,
round(100 * sum(case when discount_applied = 'Yes' then 1 else 0 end) / count(*), 2) as discount_rate
from customer 
group by item_purchased 
order by discount_rate desc
limit 10;

-- q7 segment customers into new,returning, and loyal based on their total no of pervious order,and show the count of each segment


with customer_type as (
select customer_id, previous_purchases,
CASE
when previous_purchases = 1 then 'New'
when previous_purchases between 2 and 10 then 'Returning' 
else 'Loyal'
end as customer_segment
from customer
)

select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment;


-- Q8 What are the top 3 most pruchased products within each category?

with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)

select item_rank , category, item_purchased, total_orders
from item_counts
where item_rank <= 3;


-- Q9 are customers who repear buyers(more than 5 previous purchases) also like to subscribe

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;

-- Q10 What is the revenue contribution on each age group?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;


