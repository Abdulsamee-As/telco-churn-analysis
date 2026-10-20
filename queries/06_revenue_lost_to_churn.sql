SELECT
    ROUND(SUM(monthly_charges), 0)                                        AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN churned = 1 THEN monthly_charges ELSE 0 END), 0)  AS monthly_revenue_lost,
    ROUND(100.0 * SUM(CASE WHEN churned = 1 THEN monthly_charges ELSE 0 END)
                / SUM(monthly_charges), 1)                                AS pct_revenue_lost,
    ROUND(12 * SUM(CASE WHEN churned = 1 THEN monthly_charges ELSE 0 END), 0) AS yearly_revenue_lost
FROM accounts;
