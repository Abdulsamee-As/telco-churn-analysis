SELECT
    COUNT(*)                                   AS total_customers,
    SUM(churned)                               AS churned_customers,
    ROUND(100.0 * SUM(churned) / COUNT(*), 1)  AS churn_rate_pct
FROM accounts;
