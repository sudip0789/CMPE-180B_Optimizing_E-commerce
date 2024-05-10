
-- Marketing channels

SELECT
  u.traffic_source, 
  COUNT(DISTINCT oi.user_id) AS total_customer
FROM 
  `bigquery-public-data.thelook_ecommerce.order_items` AS oi
LEFT JOIN 
  `bigquery-public-data.thelook_ecommerce.users` AS u
ON 
  oi.user_id = u.id
WHERE 
  oi.order_id IN (
    SELECT 
      DISTINCT order_id 
    FROM 
      `bigquery-public-data.thelook_ecommerce.orders`
    WHERE 
      status NOT IN ('Cancelled','Returned')
  )
GROUP BY 
  u.traffic_source
ORDER BY 
  total_customer DESC;


  -- New Users

WITH
cust AS (
  SELECT 
    DISTINCT oi.user_id,
    SUM(CASE WHEN u.gender = 'M' THEN 1 ELSE null END) AS male,
    SUM(CASE WHEN u.gender = 'F' THEN 1 ELSE null END) AS female,
    u.country AS country
  FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.users` AS u  
  ON oi.user_id = u.id
  WHERE oi.status NOT IN ('Cancelled','Returned')
  GROUP BY 1, 4
)

SELECT
  c1.country,
  COUNT(DISTINCT c1.user_id) AS customers_count,
  COUNT(c1.female) AS female,
  COUNT(c1.male) AS male
FROM 
  cust AS c1
INNER JOIN
  cust AS c2
ON 
  c1.user_id = c2.user_id
GROUP BY 1
ORDER BY 2 DESC
