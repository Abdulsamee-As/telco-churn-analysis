SELECT
    c.senior_citizen,
    c.has_dependents,
    COUNT(*)                           AS customers,
    ROUND(100.0 * AVG(1.0 * a.churned), 1)   AS churn_rate_pct
FROM accounts AS a
JOIN customers AS c ON a.customer_id = c.customer_id
GROUP BY c.senior_citizen, c.has_dependents
ORDER BY churn_rate_pct DESC;
