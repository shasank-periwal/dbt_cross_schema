

WITH v_cstmr_aml_ifrmtn AS (
    SELECT 
        customer_id,
        name,
        gender,
        dob,
        city,
        balance 
    FROM "postgres"."public"."cstmr_aml_ifrmtn"
)

SELECT * FROM v_cstmr_aml_ifrmtn