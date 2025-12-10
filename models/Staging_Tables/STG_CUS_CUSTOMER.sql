{{ config( materialized='table' )}}

select *,
from {{ source('landing_table', 'LND_CUS_CUSTOMER')}}
