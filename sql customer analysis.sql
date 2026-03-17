
USE customer_analysis;

-- ────────────────────────────────────────────────────────────
-- EXPORT 1: export_customer_status.csv
-- Main table for Power BI — one row per customer
-- ────────────────────────────────────────────────────────────
SELECT
    customer_id,
    first_name,
    last_name,
    city,
    segment,
    join_date,
    age,
    last_order_date,
    total_orders,
    total_revenue,
    avg_order_value,
    days_since_last_order,
    churn_status
FROM customer_status
ORDER BY customer_id;


-- ────────────────────────────────────────────────────────────
-- EXPORT 2: export_churn_by_segment.csv
-- For Pie/Donut chart: churn rate per segment
-- ────────────────────────────────────────────────────────────
SELECT
    segment,
    COUNT(*)                                                    AS total_customers,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)  AS churned,
    SUM(CASE WHEN churn_status = 'Active'  THEN 1 ELSE 0 END)  AS active,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1
    ) AS churn_rate_pct
FROM customer_status
GROUP BY segment
ORDER BY churn_rate_pct DESC;


-- ────────────────────────────────────────────────────────────
-- EXPORT 3: export_churn_by_city.csv
-- For Bar chart: churn rate per city
-- ────────────────────────────────────────────────────────────
SELECT
    city,
    COUNT(*)                                                    AS total_customers,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)  AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1
    ) AS churn_rate_pct
FROM customer_status
GROUP BY city
ORDER BY churn_rate_pct DESC;


-- ────────────────────────────────────────────────────────────
-- EXPORT 4: export_monthly_churn.csv
-- For Line chart: how churn evolved month by month
-- ────────────────────────────────────────────────────────────
SELECT
    DATE_FORMAT(last_order_date, '%Y-%m')   AS month,
    COUNT(*)                                AS customers_last_seen,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_count,
    ROUND(SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1)              AS churn_rate_pct
FROM customer_status
WHERE last_order_date IS NOT NULL
GROUP BY DATE_FORMAT(last_order_date, '%Y-%m')
ORDER BY month;


-- ────────────────────────────────────────────────────────────
-- EXPORT 5: export_at_risk_customers.csv
-- For Table visual: list of at-risk customers to take action on
-- ────────────────────────────────────────────────────────────
SELECT
    customer_id,
    first_name,
    last_name,
    segment,
    city,
    last_order_date,
    days_since_last_order,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE
        WHEN days_since_last_order BETWEEN 90  AND 119 THEN 'Low Risk'
        WHEN days_since_last_order BETWEEN 120 AND 149 THEN 'Medium Risk'
        WHEN days_since_last_order BETWEEN 150 AND 179 THEN 'High Risk'
    END AS risk_level
FROM customer_status
WHERE churn_status = 'Active'
  AND days_since_last_order BETWEEN 90 AND 179
ORDER BY days_since_last_order DESC;
