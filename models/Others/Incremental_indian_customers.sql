{{
    config(
        materialized = 'incremental',
        unique_key = 'C_MKTSEGMENT',
        incremental_strategy = 'merge'
    )
}}

select  C_MKTSEGMENT, SUM(C_ACCTBAL) as Total_balance
from {{ref('Indian_Customers_1000')}}
GROUP BY C_MKTSEGMENT
{% if is_incremental() %}
Having Total_balance > 10000
{% endif %}