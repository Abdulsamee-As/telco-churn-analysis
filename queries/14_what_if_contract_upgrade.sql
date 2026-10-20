WITH rates AS (
    SELECT
        SUM(CASE WHEN contract = 'Month-to-month' THEN 1 ELSE 0 END)                AS mtm_customers,
        AVG(CASE WHEN contract = 'Month-to-month' THEN 1.0 * churned END)           AS mtm_churn_rate,
        AVG(CASE WHEN contract = 'One year' THEN 1.0 * churned END)                 AS one_year_churn_rate,
        AVG(CASE WHEN contract = 'Month-to-month' THEN monthly_charges END)         AS mtm_avg_monthly_charges
    FROM accounts
),
scenarios AS (
    SELECT 10 AS pct_moved
    UNION ALL SELECT 20
    UNION ALL SELECT 30
    UNION ALL SELECT 50
)
SELECT
    CONCAT(sc.pct_moved, '%')                                                  AS month_to_month_moved_to_yearly,
    ROUND(r.mtm_customers * sc.pct_moved / 100.0, 0)                           AS customers_moved,
    ROUND(r.mtm_customers * sc.pct_moved / 100.0
          * (r.mtm_churn_rate - r.one_year_churn_rate), 0)                     AS customers_saved,
    ROUND(r.mtm_customers * sc.pct_moved / 100.0
          * (r.mtm_churn_rate - r.one_year_churn_rate)
          * r.mtm_avg_monthly_charges * 12, 0)                                 AS yearly_revenue_saved
FROM scenarios AS sc
CROSS JOIN rates AS r
ORDER BY sc.pct_moved;
