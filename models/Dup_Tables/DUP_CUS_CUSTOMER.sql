{{ config( materialized='table') }}

select * 
from {{ ref('STG_CUS_CUSTOMER')}}