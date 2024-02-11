
-- Number of items on the menu

SELECT
COUNT(DISTINCT menu_item_id) as number_of_items
FROM menu_items;

-- Most expensive and the least expensive item

SELECT *
FROM menu_items
ORDER BY price DESC;

-- How many italian dishes are on the menu? 

SELECT COUNT(DISTINCT menu_item_id) as italian
FROM menu_items
WHERE category = 'Italian';

-- Most and least expensive italian dish

SELECT *
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC;

-- How many dishes are in each category? 

SELECT category, 
COUNT(DISTINCT item_name) as number_of_dishes
FROM menu_items
GROUP BY category;

-- Average price in each category

SELECT category,
ROUND(AVG(price),2) as avg_price
FROM menu_items
GROUP BY 1;

-- ORDER DETAILS
-- Date range

SELECT MIN(order_date) as start_date,
MAX(order_date) as max_date
FROM order_details;

-- Orders made / items ordered

SELECT COUNT(DISTINCT order_details_id) as items_count,
COUNT( DISTINCT order_id) as orders_count
FROM order_details;

-- Orders with the most items ordered
SELECT
order_id,
COUNT(item_id) as items_count
FROM order_details
GROUP BY order_id
ORDER BY items_count DESC;

-- How many orders with more then 12 items ordered?

SELECT COUNT(*)
FROM (
SELECT
COUNT(order_id)
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12
) as num_ordered;


-- CUSTOMER BEHAVIOR

-- Combine menu_items and order_details tables
SELECT *
FROM order_details
INNER JOIN menu_items
	ON menu_items.menu_item_id = order_details.item_id;
    
-- The most and least ordered items

SELECT 
menu_items.item_name,
menu_items.category,
COUNT(order_details.order_id) as orders
FROM order_details
INNER JOIN menu_items
	ON menu_items.menu_item_id = order_details.item_id
GROUP BY 1
ORDER BY 3 DESC;

-- Top 5 orders with most money spent on 

SELECT
order_details.order_id,
SUM(menu_items.price) as price
FROM order_details
INNER JOIN menu_items
	ON menu_items.menu_item_id = order_details.item_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Highest paying order details

SELECT *
FROM order_details
INNER JOIN menu_items
	ON menu_items.menu_item_id = order_details.item_id
HAVING order_id = 440;

-- Details of top 5 paying orders
SELECT *
FROM order_details
INNER JOIN menu_items
	ON menu_items.menu_item_id = order_details.item_id
HAVING order_id IN (440, 2075, 1957, 330, 2675)


