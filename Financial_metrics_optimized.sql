SELECT 
    p.name AS product_name,
    SUM(oi.sale_price * o.num_of_item) AS total_sales,
    SUM(p.cost * o.num_of_item) AS total_cost,
    SUM((oi.sale_price - p.cost) * o.num_of_item) AS profit,
    SUM((oi.sale_price - p.cost) * o.num_of_item) / SUM(oi.sale_price * o.num_of_item) * 100 AS profit_margin_percentage
FROM `bigquery-public-data.thelook_ecommerce.products` p 
JOIN 
    `bigquery-public-data.thelook_ecommerce.order_items` oi ON p.id = oi.product_id
JOIN 
    `bigquery-public-data.thelook_ecommerce.orders` o ON oi.order_id = o.order_id
WHERE 
    o.status NOT IN ('Cancelled','Returned')
GROUP BY 
    p.id, p.name
ORDER BY 
    profit DESC
LIMIT 20;
