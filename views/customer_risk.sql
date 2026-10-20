CREATE VIEW customer_risk AS
WITH points AS (
    SELECT
        a.customer_id,
        a.contract,
        a.tenure_months,
        a.payment_method,
        s.internet_service,
        a.monthly_charges,
        a.churned,
        CASE a.contract WHEN 'Month-to-month' THEN 3 WHEN 'One year' THEN 1 ELSE 0 END
      + CASE WHEN a.tenure_months <= 12 THEN 2 WHEN a.tenure_months <= 24 THEN 1 ELSE 0 END
      + CASE WHEN a.payment_method = 'Electronic check' THEN 2 ELSE 0 END
      + CASE WHEN s.internet_service = 'Fiber optic' THEN 2 ELSE 0 END
      + CASE WHEN s.internet_service <> 'No' AND s.tech_support = 'No' THEN 1 ELSE 0 END
      + CASE WHEN s.internet_service <> 'No' AND s.online_security = 'No' THEN 1 ELSE 0 END
      + CASE WHEN c.senior_citizen = 'Yes' THEN 1 ELSE 0 END AS risk_score
    FROM accounts AS a
    JOIN services AS s ON a.customer_id = s.customer_id
    JOIN customers AS c ON a.customer_id = c.customer_id
)
SELECT
    *,
    CASE
        WHEN risk_score >= 9 THEN '4 Very high'
        WHEN risk_score >= 6 THEN '3 High'
        WHEN risk_score >= 3 THEN '2 Medium'
        ELSE '1 Low'
    END AS risk_level
FROM points;
