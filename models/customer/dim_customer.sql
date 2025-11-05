{{ 
    config(
        schema="reporting_db",
    )
}}

WITH v_cstmr_aml_ifrmtn AS (
    SELECT 
        customer_id,
        name,
        gender,
        dob,
        city,
        balance 
    FROM {{ source("landing_layer","cstmr_aml_ifrmtn") }}
)

SELECT * FROM v_cstmr_aml_ifrmtn