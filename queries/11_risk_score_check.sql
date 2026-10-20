SELECT
    risk_level,
    COUNT(*)                         AS customers,
    SUM(churned)                     AS churned,
    ROUND(100.0 * AVG(1.0 * churned), 1)   AS churn_rate_pct
FROM customer_risk
GROUP BY risk_level
ORDER BY risk_level;
