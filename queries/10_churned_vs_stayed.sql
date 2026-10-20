SELECT
    CASE WHEN churned = 1 THEN 'Churned' ELSE 'Stayed' END  AS customer_status,
    COUNT(*)                                                AS customers,
    ROUND(AVG(tenure_months), 1)                            AS avg_tenure_months,
    ROUND(AVG(monthly_charges), 2)                          AS avg_monthly_charges,
    ROUND(AVG(total_charges), 2)                            AS avg_total_charges
FROM accounts
GROUP BY churned
ORDER BY churned DESC;
