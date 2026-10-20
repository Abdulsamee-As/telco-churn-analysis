SELECT
    payment_method,
    COUNT(*)                         AS customers,
    SUM(churned)                     AS churned,
    ROUND(100.0 * AVG(1.0 * churned), 1)   AS churn_rate_pct
FROM accounts
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;
