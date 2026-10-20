SELECT
    risk_level,
    COUNT(*)                             AS active_customers,
    ROUND(SUM(monthly_charges), 0)       AS monthly_revenue,
    ROUND(12 * SUM(monthly_charges), 0)  AS yearly_revenue
FROM customer_risk
WHERE churned = 0
GROUP BY risk_level
ORDER BY risk_level DESC;
