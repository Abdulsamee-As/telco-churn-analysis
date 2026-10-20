SELECT
    s.internet_service,
    COUNT(*)                           AS customers,
    SUM(a.churned)                     AS churned,
    ROUND(100.0 * AVG(1.0 * a.churned), 1)   AS churn_rate_pct,
    ROUND(AVG(a.monthly_charges), 2)   AS avg_monthly_charges
FROM accounts AS a
JOIN services AS s ON a.customer_id = s.customer_id
GROUP BY s.internet_service
ORDER BY churn_rate_pct DESC;
