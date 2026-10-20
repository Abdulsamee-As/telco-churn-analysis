SELECT
    s.tech_support,
    s.online_security,
    COUNT(*)                           AS customers,
    ROUND(100.0 * AVG(1.0 * a.churned), 1)   AS churn_rate_pct
FROM accounts AS a
JOIN services AS s ON a.customer_id = s.customer_id
WHERE s.internet_service <> 'No'
GROUP BY s.tech_support, s.online_security
ORDER BY churn_rate_pct DESC;
