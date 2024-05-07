'''Total sales revenue over a specific period:'''

SELECT SUM(sale_price) AS total_revenue
FROM order_items
WHERE shipped_at BETWEEN 'start_date' AND 'end_date';



'''Sales revenue by product category:'''

SELECT product_category, SUM(sale_price) AS category_revenue
FROM order_items oi
JOIN inventory_items ii ON oi.inventory_item_id = ii.id
GROUP BY product_category;



'''Top-selling products by revenue:'''

SELECT product_name, SUM(sale_price) AS total_revenue
FROM order_items oi
JOIN inventory_items ii ON oi.inventory_item_id = ii.id
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;



'''Sales trend analysis over time:'''

SELECT DATE_TRUNC('month', shipped_at) AS month,
       SUM(sale_price) AS monthly_revenue
FROM order_items
GROUP BY month
ORDER BY month;



'''Number of new customers acquired over time:'''

SELECT DATE_TRUNC('month', created_at) AS month,
       COUNT(DISTINCT user_id) AS new_customers
FROM orders
GROUP BY month
ORDER BY month;



'''Customer retention rate:'''

SELECT COUNT(DISTINCT user_id) AS returning_customers
FROM orders
WHERE created_at <= 'end_date' AND user_id IN (
    SELECT DISTINCT user_id
    FROM orders
    WHERE created_at < 'start_date'
);



'''Customer demographics:'''

SELECT gender, COUNT(*) AS count
FROM users
GROUP BY gender;



'''Customer lifetime value (CLV):'''

SELECT user_id, SUM(sale_price) AS total_spent
FROM order_items
GROUP BY user_id
ORDER BY total_spent DESC;



'''Inventory levels by product:'''

SELECT product_name, COUNT(*) AS inventory_count
FROM inventory_items
GROUP BY product_name;



'''Inventory turnover rate:'''

SELECT product_name, 
       COUNT(*) / DATEDIFF(MAX(sold_at), MIN(created_at)) AS turnover_rate
FROM inventory_items
JOIN order_items ON inventory_items.id = order_items.inventory_item_id
GROUP BY product_name;



'''Stockout analysis:'''

SELECT product_name, COUNT(*) AS stockout_count
FROM inventory_items
WHERE sold_at IS NULL
GROUP BY product_name;



'''Slow-moving or obsolete inventory identification:'''

SELECT product_name, COUNT(*) AS inventory_count
FROM inventory_items
WHERE sold_at IS NULL AND created_at <= 'obsolete_date'
GROUP BY product_name;
