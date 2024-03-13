-- Pizzeria data cleaning 
SELECT *
FROM dbo.ingredients_data
ALTER TABLE ingredients_data
ALTER COLUMN ing_price FLOAT

SELECT *
FROM dbo.customers_data
DELETE FROM dbo.customers_data
WHERE cust_id IS NULL

SELECT *
FROM shift_data
UPDATE dbo.shift_data
SET shift_id = UPPER(shift_id)

ALTER TABLE dbo.orders_data
DROP COLUMN column9

ALTER TABLE dbo.orders_data
DROP COLUMN column8

ALTER TABLE dbo.orders_data
DROP COLUMN column7

-- Pizzeria data exploration
-- Customer info and order details 

SELECT DISTINCT cd.cust_firstname, cd.cust_lastname, od.created_at, 
COUNT(od.quantity) OVER(PARTITION BY quantity) Total_order
FROM dbo.customers_data cd
JOIN dbo.orders_data od
    ON cd.cust_id = od.cust_id
ORDER BY Total_order

-- Order details and items ordered 

SELECT od.created_at, od.quantity, id.item_name, id.item_cat, id.item_price
FROM orders_data od
JOIN item_data id
    ON od.item_id = id.item_id
ORDER BY item_price


-- Using subquery
-- Average number of orders per customer

SELECT 
    AVG(order_count) AS avg_orders_per_customer
FROM (
    SELECT orders_data.cust_id, COUNT(*) AS order_count 
    FROM orders_data
    GROUP BY orders_data.cust_id) AS customer_orders


-- Average order value 

SELECT ROUND(AVG(item_price),2) AS avg_order_value
FROM orders_data o
JOIN item_data id
    ON o.item_id = id.item_id

-- Inventory levels for ingridients
-- Includes ingreidient details such as weight and cost 

SELECT ing_id, ing_name, ing_weight, ing_price
FROM dbo.ingredients_data

-- Top sellers at Pizzeria 

SELECT i.item_name, COUNT(*) as total_orders
FROM orders_data od
JOIN item_data i
    ON od.item_id = i.item_id
GROUP BY i.item_name
ORDER BY total_orders DESC

--Total sales on each item

SELECT i.item_name, round(sum(item_price),2) AS Total_sales
FROM item_data i
JOIN orders_data od
    ON i.item_id = od.item_id
GROUP BY i.item_name
ORDER BY Total_sales DESC


