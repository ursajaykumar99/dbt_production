{{
    config(
            materialized = 'ephemeral'
    )
}}

Select *
from {{ref('STG_CUS_CUSTOMER')}}
where C_NATIONKEY = 8
AND C_ACCTBAL > 1000