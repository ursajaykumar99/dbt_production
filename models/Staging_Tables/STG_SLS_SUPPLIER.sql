{{ config( materialized='table' )}}

select *,
from {{ source('landing_table', 'LND_SLS_SUPPLIER')}}