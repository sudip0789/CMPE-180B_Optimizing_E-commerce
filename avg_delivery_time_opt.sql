WITH filtered_orderd_item_data as (
 SELECT inventory_item_id,order_id,delivered_at,shipped_at FROM `bigquery-public-data.thelook_ecommerce.order_items`
 WHERE status = 'Complete'
),

joined_filtered_data as (
 select inven_it.id as item_id ,inven_it.product_distribution_center_id as center_id ,ord_it.order_id as order_id,TIMESTAMP_DIFF(ord_it.delivered_at, ord_it.shipped_at, MINUTE) as delivery_time from filtered_orderd_item_data as ord_it
 left join `bigquery-public-data.thelook_ecommerce.inventory_items` as inven_it
 on ord_it.inventory_item_id = inven_it.id
)
