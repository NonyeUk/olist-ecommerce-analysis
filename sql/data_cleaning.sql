-- ======================================================
-- Data Cleaning

-- 1. Check Duplicates
-- 2. Standardize geolocation city names
-- 3. handle nulls/blanks
-- ======================================================



-- 1. No Duplicates

-- 2. Standardize geolocation city names
select distinct(customer_city)
from customers
order by customer_city;

-- There appeared to be some wrongly spelt city names @
-- alexandrita
-- dias d avila
-- arraial d ajuda
-- santa barbara d oeste

select *
from customers
where customer_city like 'alexand%'
group by customer_city
order by customer_city;
-- (not so sure about alexandrita not being a city, will leave for now, and maybe come back to it later)

select *
from customers
where customer_city like 'dias%'
group by customer_city
order by customer_city;
-- dias d avila to dias d'avila


select *
from customers
where customer_city like 'arraial%'
group by customer_city
order by customer_city;
-- arraial d ajuda to arraial d'ajuda


select *
from customers
where customer_city like 'santa%'
group by customer_city
order by customer_city;
-- santa barbara d oeste to santa barbara d'oeste

UPDATE customers
SET customer_city = CASE 
    WHEN customer_city = 'santa barbara d oeste' THEN "santa barbara d'oeste"
    WHEN customer_city = 'arraial d ajuda' THEN "arraial d'ajuda"
	WHEN customer_city = "dias d avila" THEN "dias d'avila"
	
END
WHERE customer_city IN ('santa barbara d oeste', 'arraial d ajuda', 'dias d avila');


-- Standardize (for geolocation)
select *
from geolocation
where geolocation_city like 'santa%'
group by geolocation_city
order by geolocation_city;

UPDATE geolocation
SET geolocation_city = CASE 
    WHEN geolocation_city = 'santa barbara d oeste' THEN "santa barbara d'oeste"
    WHEN geolocation_city = 'arraial d ajuda' THEN "arraial d'ajuda"
	WHEN geolocation_city = "dias d avila" THEN "dias d'avila"
	
END
WHERE geolocation_city IN ('santa barbara d oeste', 'arraial d ajuda', 'dias d avila');


-- 3. handle nulls/blanks
-- nulls identified in business_segment, business_type, lead_type and product_category_name.
-- didnt remove any of these as some were not relivant and others might obscure my analysis


