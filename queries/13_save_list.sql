SELECT
    customer_id,
    risk_score,
    risk_level,
    contract,
    tenure_months,
    internet_service,
    payment_method,
    monthly_charges
FROM customer_risk
WHERE churned = 0
  AND risk_level IN ('4 Very high', '3 High')
ORDER BY risk_score DESC, monthly_charges DESC;
