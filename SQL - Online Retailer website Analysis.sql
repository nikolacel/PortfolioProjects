
-- I was put in a fictional role as analyst in Maven Fuzzy Factory , an online
-- retailer which has just launched their first product.

-- Some of the task were to : 

-- Identify top traffic sources, measure their conversion rates, analyze trends, and use segmentation for bidding optimization
-- Find the most visited pages and top entry pages, calculate bounce rates, build conversion funnels, and analyze tests
-- Compare marketing channels, understand relative performance, optimize a channel portfolio, and analyze trends
-- Analyze sales, build product level conversion funnels, learn about cross selling, and measure the impact of launching new products

-- 1) 
/* 
Gsearch seems to be the biggest driver of our business. Could you pull
monthly trends for gsearch sessions
and orders so that we can showcase the growth there?
*/

SELECT
YEAR(website_sessions.created_at) as yr,
MONTH(website_sessions.created_at) as mo,
COUNT(website_sessions.website_session_id) as sessions,
COUNT(orders.order_id) as orders,
COUNT(orders.order_id) / COUNT(website_sessions.website_session_id) as conversion_rate
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
WHERE
website_sessions.utm_source = 'gsearch'
AND website_sessions.created_at < '2012-11-27'
GROUP BY
1,2;

-- 2)
/* 
Next, it would be great to see a similar monthly trend for Gsearch, but this time
splitting out nonbrand and brand campaigns separately . I am wondering if brand is picking up at all. 
If so, this is a good story to tell.
*/

SELECT
YEAR(website_sessions.created_at) as yr,
MONTH(website_sessions.created_at) as mo,
COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS nonbrand_sessions,
COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) AS nonbrand_orders,
COUNT(CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) as brand_sessions,
COUNT(CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) AS brand_orders
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
WHERE
website_sessions.utm_source = 'gsearch'
AND website_sessions.created_at < '2012-11-27'
GROUP BY
1,2;


SELECT
YEAR(website_sessions.created_at) as yr,
MONTH(website_sessions.created_at) as mo,
COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand_sessions,
COUNT(CASE WHEN   utm_campaign = 'brand' THEN website_session_id ELSE NULL END) as brand_sessions,
utm_source
FROM website_sessions
WHERE
utm_source = 'gsearch'
AND created_at < '2012-11-27'
GROUP BY
1,2;

-- 3)

/*
While we’re on Gsearch, could you dive into nonbrand, and pull
monthly sessions and orders split by device
type? I want to flex our analytical muscles a little and show the board we really know our traffic sources.
*/

SELECT
YEAR(website_sessions.created_at) as yr,
MONTH(website_sessions.created_at) as mo,
COUNT(CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
COUNT(CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders,
COUNT(CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sessions,
COUNT(CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE
website_sessions.utm_source = 'gsearch'
AND website_sessions.utm_campaign = 'nonbrand'
AND website_sessions.created_at < '2012-11-27'
GROUP BY
1,2;

-- 4)
/*
I’m worried that one of our more pessimistic board members may be concerned about the large % of traffic from
Gsearch. Can you pull monthly trends for Gsearch, alongside monthly trends for each of our other channels?
*/

SELECT distinct
utm_source
FROM 
website_sessions
WHERE
created_at < '2012-11-27';

-- gsearch
-- bsearch
-- NULL

SELECT
YEAR(website_sessions.created_at) as yr,
MONTH(website_sessions.created_at) as mo,
COUNT(CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_paid_sessions,
COUNT(CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_paid_sessions,
COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_session_id ELSE NULL END) AS organic_sessions,
COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END) as direct_type_in_sessions
FROM website_sessions
WHERE
created_at < '2012-11-27'
GROUP BY
1,2;


-- 5)
/*
I’d like to tell the story of our website performance improvements over the course of the first 8 months.
Could you pull session to order conversion rates, by month ?
*/

SELECT
YEAR(website_sessions.created_at) as yr,
MONTH(website_sessions.created_at) as mo,
COUNT(DISTINCT website_sessions.website_session_id) as sessions,
COUNT(DISTINCT orders.order_id) as orders,
COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) as order_to_sessions_rt
FROM website_sessions
LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
WHERE
website_sessions.created_at < '2012-11-27'
GROUP BY
1,2;



-- 6)

/*
Now, I’d like to show our volume growth. Can you pull overall session and order volume, trended by quarter
for the life of the business? Since the most recent quarter is incomplete, you can decide how to handle it.
*/

SELECT
YEAR(website_sessions.created_at) as yr,
QUARTER(website_sessions.created_at) as qt,
COUNT(DISTINCT website_sessions.website_session_id) as sessions,
COUNT(DISTINCT orders.order_id) as orders
FROM website_sessions
JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
WHERE
website_sessions.created_at < '2015-03-20'
GROUP BY
1,2;

-- 7)
/*
Next, let’s showcase all of our efficiency improvements. I would love to show quarterly figures since we
launched, for session to order conversion rate, revenue per order, and revenue per session.
*/

SELECT
YEAR(website_sessions.created_at) as yr,
QUARTER(website_sessions.created_at) as qt,
COUNT(DISTINCT website_sessions.website_session_id) as sessions,
COUNT(DISTINCT orders.order_id) as orders,
SUM(order_items.price_usd) as revenue,
COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) as sesions_to_orders,
ROUND(SUM(order_items.price_usd) / COUNT(DISTINCT orders.order_id),2) as revenue_per_order,
ROUND(SUM(order_items.price_usd) / COUNT(DISTINCT website_sessions.website_session_id),2) as revenue_per_session
FROM website_sessions
LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
LEFT JOIN order_items
	ON orders.order_id = order_items.order_id
GROUP BY
1,2;

-- 8)

/*
I’d like to show how we’ve grown specific channels. Could you pull a quarterly view of orders from Gsearch
nonbrand, Bsearch nonbrand, brand search overall, organic search, and direct type in?
*/

SELECT
YEAR(website_sessions.created_at) as yr,
QUARTER(website_sessions.created_at) as qt,
COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) as gsearch_nonbrand,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) as bsearch_nonbrand,
COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) as brand,
COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN orders.order_id ELSE NULL END) as direct_type_in,
COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN orders.order_id ELSE NULL END) as organic_search
FROM website_sessions
LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
WHERE
website_sessions.created_at < '2015-03-20'
GROUP BY 1,2;

-- 9)

/*
Next, let’s show the overall session
to order conversion rate trends for those same channels, by quarter.
Please also make a note of any periods where we made major improvements or optimizations.
*/

SELECT
YEAR(website_sessions.created_at) as yr,
QUARTER(website_sessions.created_at) as qt,
-- COUNT(DISTINCT orders.order_id) as orders,
 COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) /
 COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN website_sessions.website_session_id  ELSE NULL END) as cvr_gsearch_nonbrand,

 COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) / 
 COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) as cvt_bsearch_nonbrand,

COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) /
COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) as cvt_brand,

COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN orders.order_id ELSE NULL END) /
COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) as cvt_direct_type_in,

 COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN orders.order_id ELSE NULL END) /
 COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN website_sessions.website_session_id ELSE NULL END) as cvt_organic_search
FROM website_sessions
LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
WHERE
website_sessions.created_at < '2015-03-20'
GROUP BY 1,2;

-- 10)

/*
We’ve come a long way since the days of selling a single product. Let’s pull monthly trending for revenue
and margin by product, along with total sales and revenue. Note anything you notice about seasonality.
*/

SELECT
year(created_at) as yr,
month(created_at) as mo,
SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END) as p_1_revenue,
SUM(CASE WHEN product_id = 2 THEN price_usd ELSE NULL END) as p_2_revenue,
SUM(CASE WHEN product_id = 3 THEN price_usd ELSE NULL END) as p_3_revenue,
SUM(CASE WHEN product_id = 4 THEN price_usd ELSE NULL END) as p_4_revenue,
SUM(price_usd) as Total_revenue,
COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_items.order_item_id ELSE NULL END) as p_1_sales,
COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_items.order_item_id ELSE NULL END) as p_2_sales,
COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_items.order_item_id ELSE NULL END) as p_3_sales,
COUNT(DISTINCT CASE WHEN product_id = 4 THEN order_items.order_item_id ELSE NULL END) as p_4_sales,
COUNT(DISTINCT order_items.order_item_id) as Total_sales,
SUM(CASE WHEN product_id = 1 THEN price_usd - cogs_usd ELSE NULL END) as p_1_margin,
SUM(CASE WHEN product_id = 2 THEN price_usd - cogs_usd ELSE NULL END) as p_2_margin,
SUM(CASE WHEN product_id = 3 THEN price_usd - cogs_usd ELSE NULL END) as p_3_margin,
SUM(CASE WHEN product_id = 4 THEN price_usd - cogs_usd ELSE NULL END) as p_4_margin
FROM order_items
GROUP BY 1,2;

-- 11)

/*
Let’s dive deeper into the impact of introducing new products. Please pull monthly sessions to the /products
page, and show how the % of those sessions clicking through another page has changed over time, along with
a view of how conversion from /products to placing an order has improved.
*/

CREATE TEMPORARY TABLE flags
SELECT
website_session_id,
created_at,
MAX(products) as products_made_it,
MAX(mr_fuzzy) as fuzzy_made_it,
MAX(love_bear) as love_bear_made_it,
MAX(panda) as panda_made_it,
MAX(hudson_bear) as hudson_made_it
FROM(
SELECT
website_session_id,
created_at,
CASE WHEN pageview_url = '/products' THEN 1 ELSE NULL END as products,
CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE NULL END as mr_fuzzy,
CASE WHEN pageview_url = '/the-forever-love-bear' THEN 1 ELSE NULL END as love_bear,
CASE WHEN pageview_url = '/the-birthday-sugar-panda' THEN 1 ELSE NULL END as panda,
CASE WHEN pageview_url = '/the-hudson-river-mini-bear' THEN 1 ELSE NULL END as hudson_bear
FROM website_pageviews
) as flageri
GROUP BY 1
ORDER BY 1;


SELECT
YEAR(flags.created_at) as yr,
MONTH(flags.created_at) as mo,
COUNT(products_made_it) as count_products_sessions,
COUNT(fuzzy_made_it) + COUNT(love_bear_made_it) + COUNT(panda_made_it) + COUNT(hudson_made_it) as clicked_through,
(COUNT(fuzzy_made_it) + COUNT(love_bear_made_it) + COUNT(panda_made_it) + COUNT(hudson_made_it)) / COUNT(products_made_it) as clicked_through_pct,
COUNT(order_id) / COUNT(products_made_it) as orders_to_products_sessions
FROM flags
LEFT JOIN orders
	ON orders.website_session_id = flags.website_session_id
GROUP BY 1,2;

-- 12)

/*
We made our 4
th product available as a primary product on December 05, 2014 (it was previously only a cross sell
item). Could you please pull sales data since then, and show how well each product cross sells from one another?
*/

CREATE TEMPORARY TABLE primary_products
SELECT
order_id,
primary_product_id,
created_at as ordered_at
FROM orders
WHERE created_at > '2014-12-05'; -- when 4th product was added


SELECT
primary_product_id,
COUNT(DISTINCT order_id) as total_orders,
COUNT(DISTINCT CASE WHEN cross_sell_product_id = 1 THEN order_id ELSE NULL END ) x_sold_p1,
COUNT(DISTINCT CASE WHEN cross_sell_product_id = 2 THEN order_id ELSE NULL END ) x_sold_p2,
COUNT(DISTINCT CASE WHEN cross_sell_product_id = 3 THEN order_id ELSE NULL END ) x_sold_p3,
COUNT(DISTINCT CASE WHEN cross_sell_product_id = 4 THEN order_id ELSE NULL END ) x_sold_p4,
COUNT(DISTINCT CASE WHEN cross_sell_product_id = 1 THEN order_id ELSE NULL END ) / COUNT(DISTINCT order_id) as xsell_rt_p1,
COUNT(DISTINCT CASE WHEN cross_sell_product_id = 2 THEN order_id ELSE NULL END ) / COUNT(DISTINCT order_id) as xsell_rt_p2,
COUNT(DISTINCT CASE WHEN cross_sell_product_id = 3 THEN order_id ELSE NULL END ) / COUNT(DISTINCT order_id) as xsell_rt_p3,
COUNT(DISTINCT CASE WHEN cross_sell_product_id = 4 THEN order_id ELSE NULL END ) / COUNT(DISTINCT order_id) as xsell_rt_p4
FROM (
SELECT
primary_products.*,
order_items.product_id as cross_sell_product_id
FROM primary_products
	LEFT JOIN order_items
    ON order_items.order_id = primary_products.order_id
    AND order_items.is_primary_item = 0 -- only cross-sell products
) AS primary_w_cross_sell
GROUP BY 1

