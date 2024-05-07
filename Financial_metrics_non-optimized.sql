SELECT 
    products_with_costs.product_id,
    products_with_costs.product_name,
    SUM(products_with_costs.sale_price * orders.num_of_item) AS total_sales,
    SUM(products_with_costs.cost * orders.num_of_item) AS total_cost,
    SUM((products_with_costs.sale_price - products_with_costs.cost) * orders.num_of_item) AS profit,
    (SUM((products_with_costs.sale_price - products_with_costs.cost) * orders.num_of_item) / SUM(products_with_costs.sale_price * orders.num_of_item) * 100) AS profit_margin_percentage
FROM (
    SELECT 
        p.id AS product_id,
        p.name AS product_name,
        p.cost,
        oi.sale_price,
        oi.order_id
    FROM `bigquery-public-data.thelook_ecommerce.products` p
    JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi ON p.id = oi.product_id
) products_with_costs
RIGHT JOIN (
    SELECT 
        o.order_id,
        o.num_of_item
    FROM `bigquery-public-data.thelook_ecommerce.orders` o
    WHERE o.status NOT IN ('Cancelled', 'Returned')
) orders ON products_with_costs.order_id = orders.order_id
GROUP BY 
    products_with_costs.product_id, 
    products_with_costs.product_name
ORDER BY 
    profit DESC
LIMIT 20;
