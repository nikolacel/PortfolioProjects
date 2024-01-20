-- FINAL PROJECT
use mavenmovies;
-- 1)

-- List all managers names at each store, with the full address of each property (street address, district, city, and country).

SELECT
staff.first_name as First_name,
staff.last_name as Last_name,
address.address as Address,
address.district as District,
city.city as City,
country.country as Country
FROM staff
INNER JOIN store
	ON store.store_id = staff.store_id
INNER JOIN address
	ON store.address_id = address.address_id
INNER JOIN city
	ON address.city_id = city.city_id
INNER JOIN country
	ON city.country_id = country.country_id;
    
-- 2)

-- A list of each inventory item we have stocked, including the store_id number, 
-- the inventory_id , the name of the film, the film’s rating, its rental rate and replacement cost.

SELECT
inventory.store_id,
inventory.inventory_id,
film.title as Name,
film.rating,
film.rental_rate,
film.replacement_cost
FROM inventory
LEFT JOIN film
	ON inventory.film_id = film.film_id;
    
-- 3)

-- From the same list of films, rolled up data to summary level overview of the inventory. 
-- Shows how many inventory items we have with each rating at each store.

SELECT
inventory.store_id,
COUNT(inventory.inventory_id) as Count_off_inventory,
film.rating
FROM inventory
LEFT JOIN film
	ON inventory.film_id = film.film_id
 GROUP BY
	store_id,
	film.rating
ORDER BY
	store_id;
    
-- 4)

-- The number of films, as well as the average replacement cost, and total replacement cost, sliced by store and film category.

SELECT
store.store_id as Store,
category.name as Category,
COUNT(film.film_id) as Count_of_movies,
AVG(film.replacement_cost) as Average_cost,
SUM(film.replacement_cost) as Sum_of_cost
FROM film
LEFT JOIN film_category
	ON film_category.film_id = film.film_id
LEFT JOIN category
	ON film_category.category_id = category.category_id
LEFT JOIN inventory
	ON inventory.film_id = film.film_id
LEFT JOIN store
	ON inventory.store_id = store.store_id
GROUP BY
	store.store_id,
    category.name;
    
-- 5)

-- A list of all customer names, which store they go to, whether or not they are currently active, 
-- and their full addresses street address, city, and country.

SELECT
customer.first_name as First_Name,
customer.last_name as Last_Name,
customer.store_id as Store,
customer.active as Status,
address.address as Address,
city.city as City,
country.country as Country
FROM customer
LEFT JOIN address
	ON customer.address_id = address.address_id
LEFT JOIN city
	ON address.city_id = city.city_id
LEFT JOIN country
	ON city.country_id = country.country_id;
    
-- 6)

-- A list of customer names, their total lifetime rentals, and the sum of all payments you have collected from them.
-- Ordered on total lifetime value with the most valuable customers at the top of the list.

SELECT
customer.first_name as First_Name,
customer.last_name as Last_Name,
COUNT(rental.rental_id) as Total_Rentals,
SUM(payment.amount) as Total_Payments
FROM customer
INNER JOIN payment
	ON customer.customer_id = payment.customer_id
INNER JOIN rental
	ON customer.customer_id = rental.customer_id
GROUP BY
customer.first_name,
customer.last_name
ORDER BY
Total_Payments DESC;

-- 7)

-- A list of advisor and investor names in one table. If investor, company they work for pulled too. 
SELECT
'Advisor' as Type,
first_name as First_Name,
last_name as Last_Name,
'' as Company
FROM advisor
UNION
SELECT
'Investor' as Type,
investor.first_name as First_Name,
investor.last_name as Last_Name,
company_name as Company
FROM investor;
