-- ======================================================
-- Exploratory Data Analysis (EDA)
-- Purpose: Explore data distribution, dataset coverage,
--          key measures, ranking, and magnitude.
-- ======================================================



-- ======================================================
-- 1. Data Distribution (Categorical Exploration)
-- ======================================================
SELECT DISTINCT customer_city FROM customers;
SELECT DISTINCT business_segment FROM leads_closed;
SELECT DISTINCT business_type FROM leads_closed;
SELECT DISTINCT lead_type FROM leads_closed;
SELECT DISTINCT origin FROM leads_qualified;
SELECT DISTINCT payment_type FROM order_payments;
SELECT DISTINCT payment_installments FROM order_payments ORDER BY payment_installments;
SELECT DISTINCT order_status FROM orders;
SELECT DISTINCT product_category_name FROM products;


-- ======================================================
-- 2. Dataset Coverage (Time Period)
-- ======================================================
SELECT 
    MIN(order_purchase_timestamp) AS first_order, 
    MAX(order_purchase_timestamp) AS last_order,
    (julianday(MAX(order_purchase_timestamp)) - julianday(MIN(order_purchase_timestamp))) / 365.25 AS delivery_years
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- ======================================================
-- 3. Key Measures
-- ======================================================
-- Total sales
SELECT SUM(price) AS total_sales FROM order_items;

-- Total revenue
SELECT SUM(price + freight_value) AS total_revenue FROM order_items;

-- Total items sold
SELECT COUNT(product_id) AS total_quantity FROM order_items;

-- Average sale price
SELECT AVG(price) AS avg_price FROM order_items;

-- Total orders
SELECT COUNT(order_id) AS total_orders FROM order_items;

-- Total unique products
SELECT COUNT(DISTINCT product_id) AS total_products FROM order_items;

-- Total customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM orders;


-- ======================================================
-- 4. Magnitude Analysis
-- ======================================================
-- Customers by state
SELECT customer_state, COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;


-- ======================================================
-- 5. Combined Report (Single Table of KPIs)
-- ======================================================
SELECT 'total_sales' AS measure_name, SUM(price) AS measure_value 
FROM order_items
UNION ALL 
SELECT 'avg_price', AVG(price) 
FROM order_items
UNION ALL 
SELECT 'total_orders', COUNT(order_id)  
FROM order_items
UNION ALL 
SELECT 'total_products', COUNT(DISTINCT product_id) 
FROM order_items
UNION ALL 
SELECT 'total_customers', COUNT(DISTINCT customer_id) 
FROM orders;


