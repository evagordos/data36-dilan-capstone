-- Final task for project Dilan's travel guide
-- Author: Eva Gordos
-- 2023

-- Creating tables from raw CSV data

CREATE TABLE first_readers (
date_time TIMESTAMP,
event_type TEXT,
country TEXT,
user_id TEXT,
source TEXT,
topic TEXT);

COPY first_readers
FROM '/home/firstbornunicorn/first_read.csv'
DELIMITER ';';

CREATE TABLE returning_readers (
date_time TIMESTAMP,
event_type TEXT,
country TEXT,
user_id TEXT,
topic TEXT);

COPY returning_readers
FROM '/home/firstbornunicorn/returning_read.csv'
DELIMITER ';';

CREATE TABLE subscribers (
date_time TIMESTAMP,
event_type TEXT,
user_id TEXT);

COPY subscribers
FROM '/home/firstbornunicorn/subscribe.csv'
DELIMITER ';';

CREATE TABLE customers (
date_time TIMESTAMP,
event_type TEXT,
user_id TEXT,
price INTEGER);

COPY customers
FROM '/home/firstbornunicorn/buy.csv'
DELIMITER ';';

-- Defining purchase per country

SELECT
	first_readers.country,
	COUNT(*) as purchases
FROM customers
LEFT JOIN first_readers ON customers.user_id = first_readers.user_id
GROUP BY first_readers.country
ORDER BY purchases desc;

-- Defining revenue per country

SELECT
	first_readers.country,
	SUM(price) as sum_Price
FROM customers
LEFT JOIN first_readers ON customers.user_id = first_readers.user_id
GROUP BY first_readers.country
ORDER BY sum_price desc;

-- Defining the daily revenue from e-book sales

SELECT DATE(date_time) as my_date,
SUM(price) as ebook_revenue
FROM customers
WHERE price = 8
GROUP BY my_date
ORDER BY my_date;

-- Defining the daily revenue from video course sales

SELECT DATE(date_time) as my_date,
SUM(price) as course_revenue
FROM customers
WHERE price = 80
GROUP BY my_date
ORDER BY my_date;

-- Overview

SELECT count(*)
FROM first_readers;

SELECT count(*)
FROM returning_readers;

SELECT count(distinct(user_id))
FROM returning_readers;

SELECT count(*)
FROM subscribers;

SELECT count(*)
FROM customers;

SELECT count(distinct(user_id))
FROM customers;

SELECT sum(price)
FROM customers;

-- KPIs

-- Daily visitors

SELECT
    my_date,
    COUNT(DISTINCT(user_id)) 
FROM (
  SELECT DATE(date_time) as my_date, user_id
  FROM first_readers
  UNION ALL
  SELECT DATE(date_time) as my_date, user_id
  FROM returning_readers
  UNION ALL
  SELECT DATE(date_time) as my_date, user_id
  FROM subscribers
  UNION ALL
  SELECT DATE(date_time) as my_date, user_id
  FROM customers) as daily_visitors
GROUP BY my_date;

-- Daily revenue

SELECT DATE(date_time) as my_date,
    SUM(price)
FROM customers
GROUP BY my_date
ORDER BY my_date;

-- Funnel Analysis

SELECT first_readers.source, first_readers.country,
    COUNT(DISTINCT(first_readers.user_id)) AS first_readers,
    COUNT(DISTINCT(returning_readers.user_id)) AS returning_readers,
    COUNT(DISTINCT(subscribers.user_id)) AS subscribers,
    COUNT(DISTINCT(customers.user_id)) AS customers
FROM first_readers
LEFT JOIN returning_readers ON returning_readers.user_id = first_readers.user_id
LEFT JOIN subscribers ON subscribers.user_id = first_readers.user_id
LEFT JOIN customers ON customers.user_id = first_readers.user_id
GROUP BY first_readers.source, first_readers.country;

-- Return on marketing cost

SELECT DATE_TRUNC('month',customers.date_time) AS my_date,
       first_readers.source,
       SUM(customers.price) as revenue,
       (SUM(customers.price)::float / (CASE WHEN first_readers.source = 'AdWords' THEN 500 ELSE 	250 END))*100.0 AS romc
FROM first_readers
JOIN customers ON first_readers.user_id = customers.user_id
GROUP BY my_date,
         first_readers.source
ORDER BY my_date; 

