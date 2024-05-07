with return_dist_count as
(SELECT inven_it.product_distribution_center_id as center_id, count(distinct(order_id)) as returned_order_count  FROM `bigquery-public-data.thelook_ecommerce.order_items` as ord_it
left join `bigquery-public-data.thelook_ecommerce.inventory_items` as inven_it
on ord_it.inventory_item_id = inven_it.id
Where status = 'Returned'
group by inven_it.product_distribution_center_id),


order_dist_count as
(SELECT inven_it.product_distribution_center_id as center_id, count(distinct(order_id)) as order_count  FROM `bigquery-public-data.thelook_ecommerce.order_items` as ord_it
left join `bigquery-public-data.thelook_ecommerce.inventory_items` as inven_it
on ord_it.inventory_item_id = inven_it.id
Where status in ('Returned','Complete')
group by inven_it.product_distribution_center_id)

select a.center_id,round((returned_order_count*100/ order_count),2) as return_rate from order_dist_count as a
left join return_dist_count as b
on a.center_id = b.center_id;