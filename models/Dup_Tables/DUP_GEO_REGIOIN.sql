{{ config( 
            materialized='incremental',
            incremental_strategy='append'
         ) 
}}

SELECT * 
FROM {{ ref('STG_GEO_REGIOIN')}}
WHERE 1 = 1
QUALIFY ROW_NUMBER() OVER(PARTITION BY EDW_LOAD_KEY_HASH ORDER BY EDW_LOAD_KEY_HASH) > 1