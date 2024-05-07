with filterd_order_inv as
(SELECT inven_it.product_distribution_center_id, ord_it.status as status, order_id FROM `bigquery-public-data.thelook_ecommerce.order_items` as ord_it
left join `bigquery-public-data.thelook_ecommerce.inventory_items` as inven_it
on ord_it.inventory_item_id = inven_it.id
Where status in ('Returned', 'Complete' )),

grouped_order_inv as (
select product_distribution_center_id, status,count(distinct order_id) as total_count from filterd_order_inv  group by product_distribution_center_id, status),

TC as
(select product_distribution_center_id, sum(total_count) as total_count from grouped_order_inv group by product_distribution_center_id),

RC as
(select product_distribution_center_id, total_count as returned_count  from grouped_order_inv where status = 'Returned')

select TC.product_distribution_center_id as center_id,round((RC.returned_count*100/ TC.total_count),2) as return_rate   from TC inner join RC on TC.product_distribution_center_id = RC.product_distribution_center_id