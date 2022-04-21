SELECT * FROM orders
ORDER BY purchase_date;

-- test
-- SELECT DATE_TRUNC('month', purchase_date)::date as purchase_by_month,
-- 	COUNT(DISTINCT client_id) as number_of_purchases 
-- FROM orders
-- GROUP BY DATE_TRUNC('month', purchase_date)::date
-- ORDER BY purchase_by_month;

-- test
-- SELECT COUNT(CASE WHEN purchase_date BETWEEN '2015-05-01' AND '2015-05-30' THEN 1 END) 
-- 	AS new_sells_may,
-- 	COUNT(CASE WHEN purchase_date BETWEEN '2015-06-01' AND '2015-06-30' THEN 1 END) 
-- 	AS new_sells_june,
-- 	COUNT(CASE WHEN purchase_date BETWEEN '2015-07-01' AND '2015-07-31' THEN 1 END) 
-- 	AS new_sells_july,
-- 	COUNT(CASE WHEN purchase_date BETWEEN '2015-08-01' AND '2015-08-31' THEN 1 END) 
-- 	AS new_sells_august 
-- FROM orders;



-- Total sales by month
SELECT EXTRACT(month from purchase_date) as month,
	COUNT(DISTINCT client_id) as number_of_orders
FROM orders
GROUP BY 1
ORDER BY 1;

-- Новые торговые точки для каждого месяца
-- MAY
SELECT  
	COUNT(DISTINCT client_id) AS new_sales_may
FROM orders 
WHERE 
	EXTRACT(month FROM purchase_date) = 5;

-- JUNE
SELECT  
	COUNT(DISTINCT client_id) AS new_sales_june
FROM orders 
WHERE 
	EXTRACT(month FROM purchase_date) = 6
	AND client_id NOT IN (SELECT client_id FROM orders WHERE EXTRACT(month FROM purchase_date) < 6);

-- JULY
SELECT  
	COUNT(DISTINCT client_id) AS new_sales_july
FROM orders 
WHERE 
	EXTRACT(month FROM  purchase_date) = 7
	AND client_id NOT IN (SELECT client_id FROM orders WHERE EXTRACT(month FROM purchase_date) < 7);

-- AUGUST
SELECT  
	COUNT(DISTINCT client_id) AS new_sales_august
FROM orders 
WHERE 
	EXTRACT(month FROM purchase_date) = 8
	AND client_id NOT IN (SELECT client_id FROM orders WHERE EXTRACT(month FROM purchase_date) < 8);
	
	
-- Торговые точки, сделавшие заказ в прошлом месяце и в этом
-- MAY
SELECT
	COUNT(DISTINCT client_id)
FROM orders
WHERE
	EXTRACT(month FROM purchase_date) = 5;
	
-- MAY & JUNE
SELECT
	COUNT(DISTINCT client_id)
FROM orders
WHERE
	EXTRACT(month FROM purchase_date) IN (5,6);
	
-- JUNE & JULY
SELECT
	COUNT(DISTINCT client_id)
FROM orders
WHERE
	EXTRACT(month FROM purchase_date) IN (6,7);

-- JULY & AUGUST
SELECT
	COUNT(DISTINCT client_id)
FROM orders
WHERE
	EXTRACT(month FROM purchase_date) IN (7,8);
	
-- Торговые точки, которые когда-то что-то заказали(только не в прошлом месяце) и вернувшиеся
-- так как данные начинаются с мая, то, учитывая задание, под условие подходят только июль и август

-- JULY
SELECT
	COUNT(client_id)
FROM orders
WHERE
	EXTRACT(month FROM purchase_date) = 7
	AND client_id IN
		(SELECT client_id FROM orders WHERE EXTRACT(month FROM purchase_date) < 6);
		
-- AUGUST
SELECT
	COUNT(client_id)
FROM orders
WHERE
	EXTRACT(month FROM purchase_date) = 8
	AND client_id IN
		(SELECT client_id FROM orders WHERE EXTRACT(month FROM purchase_date) < 7);

-- Торговые точки, отвалившиеся в этом месяце.
-- под условие подходят только данные начиная с июня

-- JUNE DECREASE
SELECT COUNT(DISTINCT client_id) - 
	(SELECT COUNT(DISTINCT client_id) 
	FROM orders
	WHERE EXTRACT(month FROM purchase_date) = 6) as difference
FROM orders
WHERE 
	EXTRACT(month FROM purchase_date) = 5;

-- JULY DECREASE
SELECT COUNT(DISTINCT client_id) - 
	(SELECT COUNT(DISTINCT client_id) 
	FROM orders
	WHERE EXTRACT(month FROM purchase_date) = 7) as difference
FROM orders
WHERE 
	EXTRACT(month FROM purchase_date) = 6;
	
-- AUGUST DECREASE
SELECT COUNT(DISTINCT client_id) - 
	(SELECT COUNT(DISTINCT client_id) 
	FROM orders
	WHERE EXTRACT(month FROM purchase_date) = 8) as difference
FROM orders
WHERE 
	EXTRACT(month FROM purchase_date) = 7;