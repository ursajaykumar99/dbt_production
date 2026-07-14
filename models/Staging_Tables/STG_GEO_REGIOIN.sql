{{ config( materialized='table' )}}

select *,
from {{ source('landing_table', 'LND_GEO_REGIOIN')}}