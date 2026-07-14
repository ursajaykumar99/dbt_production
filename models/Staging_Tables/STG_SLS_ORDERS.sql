{{ config( materialized='table' )}}

select *,
from {{ source('landing_table', 'LND_SLS_ORDERS')}}