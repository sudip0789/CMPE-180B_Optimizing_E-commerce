select center_id, round(avg(delivery_time),2) as avg_delivery_time from
(SELECT
inven_it.product_distribution_center_id as center_id ,ord_it.order_id as order_id,TIMESTAMP_DIFF(ord_it.delivered_at, ord_it.shipped_at, MINUTE) as delivery_time
FROM `bigquery-public-data.thelook_ecommerce.order_items` as ord_it
left join `bigquery-public-data.thelook_ecommerce.inventory_items` as inven_it
on ord_it.inventory_item_id = inven_it.id
where status = 'Complete')
group by center_id;