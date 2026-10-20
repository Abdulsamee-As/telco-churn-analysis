WITH segments AS (
    SELECT
        a.contract,
        s.internet_service,
        a.payment_method,
        COUNT(*)                           AS customers,
        SUM(a.churned)                     AS churned,
        ROUND(100.0 * AVG(1.0 * a.churned), 1)   AS churn_rate_pct
    FROM accounts AS a
    JOIN services AS s ON a.customer_id = s.customer_id
    GROUP BY a.contract, s.internet_service, a.payment_method
    HAVING COUNT(*) >= 100
),
ranked AS (
    SELECT
        RANK() OVER (ORDER BY churn_rate_pct DESC) AS risk_rank,
        contract,
        internet_service,
        payment_method,
        customers,
        churned,
        churn_rate_pct
    FROM segments
)
SELECT *
FROM ranked
WHERE risk_rank <= 10
ORDER BY risk_rank;
