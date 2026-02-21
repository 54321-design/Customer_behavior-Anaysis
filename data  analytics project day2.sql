Select * from customer limit 5
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

--are customers who are repeat buyers(more than 5 purchases) also likely to subscribe?
select subscription_status,COUNT(customer_id) AS repeater_buyer
from customer
where previous_purchases > 5
group by subscription_status

--what is the revenue contribution of each age group?
select age_group , SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by  total_revenue desc



