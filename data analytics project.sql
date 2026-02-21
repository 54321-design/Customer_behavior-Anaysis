select * from customer limit 20
select gender,SUM(purchase_amount) as revenue
from customer
group by gender

select customer_id,purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount>=(select AVG(purchase_amount) from customer)

--WHICH ARE THE TOP 5 PRODUCT WITH THE HIGHEST AVG RATING?
SELECT item_purchased,ROUND(AVG(review_rating::numeric),2) AS "Average product rating"
FROM customer
group by item_purchased
order by avg(review_rating) desc
LIMIT 5
--compare the average purchase amount between standard and express shipping
select shipping_type,ROUND(AVG(purchase_amount),2)
from customer 
WHERE shipping_type in ('Standard','Express')
group by shipping_type

--DO subscribed customers spend more? Compare average spend and total revenue between subscriber and non subscribers
select subscription_status,COUNT(customer_id),ROUND(AVG(purchase_amount),2) AS avg_spend,
ROUND(SUM(purchase_amount),2) AS total_revenue
from customer
group by subscription_status
order by total_revenue,avg_spend

--which 5 product have the highest percentage of purchases with discounts applied
select item_purchased,
ROUND(100*SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
LIMIT 5

--Segment customers into new , returning , and loyal based on the total
--number of previous purchases and show the count of each 
with customer_type as(
select customer_id,previous_purchases,
CASE
    WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	Else 'loyal'
	END AS customer_segment
from customer
)
select customer_segment,count(*) as  "number of customers"
from customer_type
group by customer_segment

--what are the top 3 most purchased products within each category?
with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number()over(partition by category order by count(customer_id)DESC ) AS item_rank
from  customer
group by category, item_purchased
)
select item_rank, category,item_purchased,total_orders
from item_counts
where  item_rank <=3