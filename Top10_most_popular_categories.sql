SELECT
    p.category,
    SUM(o.num_of_item) AS total_quantity_ordered
FROM `bigquery-public-data.thelook_ecommerce.products` p 
JOIN 
    `bigquery-public-data.thelook_ecommerce.order_items` oi ON p.id = oi.product_id
JOIN 
    `bigquery-public-data.thelook_ecommerce.orders` o ON oi.order_id = o.order_id
WHERE 
    o.status NOT IN ('Cancelled','Returned')
GROUP BY 
    p.category
ORDER BY 
    total_quantity_ordered DESC
LIMIT 10;
