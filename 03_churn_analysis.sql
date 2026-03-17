
-- ============================================================

USE customer_analysis;

-- ────────────────────────────────────────────────────────────
-- QUERY 1: Label every customer as Active or Churned
-- Save this as a VIEW — other queries will use it
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW customer_status AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.segment,
    c.join_date,
    c.age,
    MAX(o.order_date)                          AS last_order_date,
    COUNT(o.order_id)                          AS total_orders,
    ROUND(SUM(o.net_revenue), 2)               AS total_revenue,
    ROUND(AVG(o.net_revenue), 2)               AS avg_order_value,
    DATEDIFF('2024-12-31', MAX(o.order_date))  AS days_since_last_order,
    CASE
        WHEN MAX(o.order_date) < '2024-06-30' THEN 'Churned'
        ELSE 'Active'
    END AS churn_status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name,
    c.city, c.segment, c.join_date, c.age;

-- Preview the view
SELECT * FROM customer_status LIMIT 10;


-- ────────────────────────────────────────────────────────────
-- QUERY 2: Overall churn summary
-- How many customers churned vs stayed active?
-- ────────────────────────────────────────────────────────────
SELECT
    churn_status,
    COUNT(*)                                                AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1)    AS percentage
FROM customer_status
GROUP BY churn_status
ORDER BY customer_count DESC;

-- Expected insight: ~40% churned, ~60% active


-- ────────────────────────────────────────────────────────────
-- QUERY 3: Churn rate by customer segment
-- Which segment churns the most — Premium, Standard or Basic?
-- ────────────────────────────────────────────────────────────
SELECT
    segment,
    COUNT(*)                                                    AS total_customers,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)  AS churned,
    SUM(CASE WHEN churn_status = 'Active'  THEN 1 ELSE 0 END)  AS active,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1
    )                                                           AS churn_rate_pct
FROM customer_status
GROUP BY segment
ORDER BY churn_rate_pct DESC;

-- Insight: Compare churn rate across Premium / Standard / Basic


-- ────────────────────────────────────────────────────────────
-- QUERY 4: Churn rate by city
-- Which locations have the highest churn?
-- ────────────────────────────────────────────────────────────
SELECT
    city,
    COUNT(*)                                                    AS total_customers,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)  AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1
    )                                                           AS churn_rate_pct
FROM customer_status
GROUP BY city
ORDER BY churn_rate_pct DESC;


-- ────────────────────────────────────────────────────────────
-- QUERY 5: Revenue lost to churn
-- How much money did churned customers spend BEFORE leaving?
-- This shows the business impact of churn in dollars
-- ────────────────────────────────────────────────────────────
SELECT
    churn_status,
    COUNT(*)                            AS customers,
    ROUND(SUM(total_revenue), 2)        AS total_revenue,
    ROUND(AVG(total_revenue), 2)        AS avg_revenue_per_customer,
    ROUND(AVG(avg_order_value), 2)      AS avg_order_value,
    ROUND(AVG(total_orders), 1)         AS avg_orders_per_customer
FROM customer_status
GROUP BY churn_status;

-- Insight: How does churned customer value compare to active customers?


-- ────────────────────────────────────────────────────────────
-- QUERY 6: Monthly churn trend
-- In which months did the most customers place their LAST order?
-- This shows WHEN customers were lost
-- ────────────────────────────────────────────────────────────
SELECT
    DATE_FORMAT(last_order_date, '%Y-%m')   AS last_order_month,
    COUNT(*)                                AS customers_last_seen,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_count
FROM customer_status
WHERE last_order_date IS NOT NULL
GROUP BY DATE_FORMAT(last_order_date, '%Y-%m')
ORDER BY last_order_month;

-- Insight: Which months show a spike in last orders (churn events)?


-- ────────────────────────────────────────────────────────────
-- QUERY 7: Days to churn analysis
-- How long after joining do customers typically churn?
-- ────────────────────────────────────────────────────────────
SELECT
    churn_status,
    ROUND(AVG(DATEDIFF(last_order_date, join_date)), 0)  AS avg_days_active,
    MIN(DATEDIFF(last_order_date, join_date))            AS min_days_active,
    MAX(DATEDIFF(last_order_date, join_date))            AS max_days_active
FROM customer_status
WHERE last_order_date IS NOT NULL
GROUP BY churn_status;

-- Insight: Churned customers were active for how many days on average?


-- ────────────────────────────────────────────────────────────
-- QUERY 8: At-risk customers (likely to churn soon)
-- Active customers who haven't ordered in 90-179 days
-- These are your WARNING ZONE customers — act before they churn!
-- ────────────────────────────────────────────────────────────
SELECT
    customer_id,
    first_name,
    last_name,
    segment,
    city,
    last_order_date,
    days_since_last_order,
    total_revenue,
    CASE
        WHEN days_since_last_order BETWEEN 90  AND 119 THEN 'Low Risk'
        WHEN days_since_last_order BETWEEN 120 AND 149 THEN 'Medium Risk'
        WHEN days_since_last_order BETWEEN 150 AND 179 THEN 'High Risk'
    END AS risk_level
FROM customer_status
WHERE churn_status = 'Active'
  AND days_since_last_order BETWEEN 90 AND 179
ORDER BY days_since_last_order DESC, total_revenue DESC;

-- Business action: Send targeted emails or discount offers to these customers!
