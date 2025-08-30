-- ======================================================
-- Business Analysis
-- Purpose: Generate insights on performance, revenue,
--          customer behavior, reviews, and rankings.
-- ======================================================


-- ======================================================
-- 1. Sales & Customer Analysis
-- ======================================================
WITH monthly_sales AS (
    SELECT 
        strftime('%Y-%m', o.order_purchase_timestamp) AS order_date,
		c.customer_state AS state,
        COUNT(o.order_id) AS sales_volume,
        COUNT(DISTINCT c.customer_unique_id) AS total_customers,
        SUM(oi.price + oi.freight_value) AS total_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY order_date, state
),
first_purchase AS (
    SELECT
        c.customer_unique_id,
        MIN(strftime('%Y-%m', o.order_purchase_timestamp)) AS first_order_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
monthly_new_customers AS (
    SELECT 
        first_order_month AS order_date,
        COUNT(customer_unique_id) AS new_customers
    FROM first_purchase
    GROUP BY first_order_month
)
SELECT 
    ms.order_date,
	state,
    ms.sales_volume,
    ms.total_sales,
    ROUND(ms.total_sales * 1.0 / ms.sales_volume, 2) AS AOV,
    ms.total_customers,
    IFNULL(mnc.new_customers, 0) AS new_customers,
    (ms.total_customers - IFNULL(mnc.new_customers, 0)) AS returning_customers,
    ROUND(
        ((ms.total_sales - LAG(ms.total_sales) OVER (ORDER BY ms.order_date)) * 1.0 /
         LAG(ms.total_sales) OVER (ORDER BY ms.order_date)) * 100, 2
    ) AS revenue_growth_rate
FROM monthly_sales ms
LEFT JOIN monthly_new_customers mnc 
    ON ms.order_date = mnc.order_date
ORDER BY ms.order_date;

-- customers segment

WITH customer_spending AS ( 
SELECT
strftime('%Y-%m', o.order_purchase_timestamp) AS order_date,
customer_unique_id, sum(price + freight_value) total_spent, min(order_purchase_timestamp) first_order, max(order_purchase_timestamp) last_order,
 ROUND(julianday(MAX(o.order_purchase_timestamp)) - julianday(MIN(o.order_purchase_timestamp)), 0) AS days_between
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY order_date, customer_unique_id
)
SELECT order_date,
customer_segment, COUNT(*) AS customer_count
FROM(
	SELECT order_date,
	CASE WHEN days_between >= 100 AND total_spent >= 2000 THEN 'VIP'
		WHEN days_between >= 100 AND total_spent < 2000 THEN 'Regular'
		WHEN days_between = 0 THEN 'One Time'
		ELSE 'Normal'
	END AS customer_segment
	FROM customer_spending)
GROUP BY order_date, customer_segment
ORDER BY order_date ASC


-- ======================================================
-- 2. Product Performance Analysis
-- ======================================================
WITH category_revenue AS (
    SELECT 
		strftime('%Y-%m', o.order_purchase_timestamp) AS order_date,
        pc.product_category_name_english,
        COUNT(*) AS total_order,
        SUM(oi.price) AS total_revenue
    FROM order_items oi
    JOIN products p 
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pc 
        ON p.product_category_name = pc.product_category_name
	JOIN orders o 
        ON oi.order_id = o.order_id
    GROUP BY order_date, pc.product_category_name_english
),
with_percentage AS (
    SELECT 
		order_date,
        product_category_name_english,
        total_order,
        total_revenue,
        ROUND((total_revenue * 100.0) / (SELECT SUM(total_revenue) FROM category_revenue), 2) AS revenue_percentage
    FROM category_revenue
),
category_reviews AS (
    SELECT 
        pc.product_category_name_english,
        ROUND(AVG(orr.review_score), 2) AS avg_review_score
    FROM order_items oi
    JOIN order_reviews orr 
        ON oi.order_id = orr.order_id
    JOIN products p 
        ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation pc 
        ON p.product_category_name = pc.product_category_name
    GROUP BY pc.product_category_name_english
)
SELECT 
	w.order_date,
    w.product_category_name_english,
    w.total_order,
    w.total_revenue,
    w.revenue_percentage,
    ROUND(SUM(w.revenue_percentage) OVER (ORDER BY w.total_revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cumulative_percentage,
    r.avg_review_score
FROM with_percentage w
LEFT JOIN category_reviews r 
    ON w.product_category_name_english = r.product_category_name_english
ORDER BY w.order_date ASC;



-- ======================================================
-- 3. Payment Analysis
-- ======================================================
SELECT 
	strftime('%Y-%m', o.order_purchase_timestamp) AS order_date,
    op.payment_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(100.0 * COUNT(DISTINCT o.order_id) / 
        (SELECT COUNT(DISTINCT order_id) FROM order_payments), 2) AS pct_of_orders,
    ROUND(SUM(op.payment_value), 2) AS total_revenue,
    ROUND(AVG(julianday(o.order_approved_at) - julianday(o.order_purchase_timestamp)), 2) 
        AS avg_days_to_approval
FROM orders o
JOIN order_payments op 
    ON o.order_id = op.order_id
WHERE o.order_approved_at IS NOT NULL
GROUP BY order_date, op.payment_type
ORDER BY order_date ASC;




-- ======================================================
-- 4. Review Analysis
-- ======================================================
WITH delivery_metrics AS (
    SELECT 
		strftime('%Y-%m', o.order_purchase_timestamp) AS order_date,
        o.order_id,
        julianday(o.order_delivered_customer_date) - julianday(o.order_purchase_timestamp) AS delivery_daytime,
        julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
)
SELECT 
	order_date,
    r.review_score,
    COUNT(r.review_id) AS count_reviews,
    ROUND(100.0 * COUNT(r.review_id) / (SELECT COUNT(*) FROM order_reviews), 2) AS pct_of_total_reviews,
    ROUND(AVG(d.delay_days), 2) AS avg_delay_days,
    ROUND(AVG(d.delivery_daytime), 2) AS avg_delivery_days
FROM order_reviews r
JOIN delivery_metrics d ON r.order_id = d.order_id
GROUP BY order_date, r.review_score
ORDER BY order_date;




-- ======================================================
-- 5. lead source and Business type Analysis
-- ======================================================
SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS order_date,
origin as lead_source, lead_type, count(o.order_id) orders_generated, sum(price + freight_value) revenue_generated
FROM leads_qualified lq
LEFT JOIN leads_closed lc ON lc.mql_id = lq.mql_id
JOIN order_items oi ON lc.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
WHERE origin IS NOT NULL AND o.order_id IS NOT NULL AND lead_type IS NOT NULL
GROUP BY order_date, lead_source, lead_type
ORDER BY  order_date ASC;



