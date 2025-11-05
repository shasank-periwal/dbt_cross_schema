WITH v_s_accnt_trm_dpst AS (
    SELECT 
        interest_payment_frequency,
        rate_of_interest,
        margin_opertion,
        margin,
        principal_amount,
        customer_code
    FROM "postgres"."public"."accnt_trm_dpst"
),
v_dim_customer AS (
    SELECT 
        customer_id,
        name,
        gender,
        dob,
        city,
        balance 
    FROM "postgres"."reporting_db"."dim_customer"
),
v_final AS (
    SELECT 
        interest_payment_frequency,
        rate_of_interest,
        margin_opertion,
        margin,
        principal_amount,
        name,
        gender,
        dob,
        city
    FROM v_s_accnt_trm_dpst a 
    LEFT JOIN v_dim_customer b ON a.customer_code = b.customer_id
)

SELECT * FROM v_final