use maven_market 

select * from transaction;
select * from stores
select * from regions
select * from product
select * from returns

-- Data cleaning
SET SQL_SAFE_UPDATES = 0;
-- 1. remove invalid transaction
DELETE FROM transaction
WHERE product_id NOT In (SELECT product_id FROM product);


-- 1. Total Sales
SELECT
    ROUND(SUM(t.quantity * p.product_retail_price), 2) AS total_sales
FROM transaction t 
JOIN product p ON t.product_id = p.product_id;


-- 2. Total Profit 
SELECT 
    ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 2) AS total_profit
FROM transaction t 
JOIN product p ON t.product_id = p.product_id;

-- 3. Return Rate (%)
SELECT 
    (SUM(r.quantity) * 100.0 / SUM(t.quantity)) AS return_rate
FROM returns r 
JOIN transaction t 
ON r.product_id = t.product_id
ANd r.store_id = t.store_id;

-- 4. Return Analysis by Product
SELECT
    p.product_name,
    SUM(r.quantity) AS total_returns
FROM returns r 
JOIN product p ON r.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_returns DESC LIMIT 5;

-- 5. Low-fat vs Regulat product performance
SELECT 
    p.low_fat,
    SUM(t.quantity) AS total_units_sold,
    SUm(t.quantity * p.product_retail_price) AS total_revenue
FROM transaction t 
JOIN product p ON t.product_id = p.product_id
GROUP BY p.low_fat;

-- 6. Recyclable Product Sales
SELECT 
    r.sales_region,
    SUm(t.quantity) AS units_sold,
    SUM(t.quantity * p.product_retail_price) AS total_sales 
FROM transaction t 
JOIN product p ON t.product_id = p.product_id 
JOIN region r ON t.store_id = r.region_id 
WHERE p.recyclable = 1
GROUP BY r.sales_region;

-- 7. Heavy vs light products
SELECT 
    CASE
      WHEN product_weight > 5 THEN 'Heavy'
	  ELSE 'Light'
	END AS weight_category,
    SUM(t.quantity) AS total_units_sold
FROM transaction t 
JOIN product p ON t.product_id = p.product_id
GROUP BY weight_category;


