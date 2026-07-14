{{  config( 
            materialized='incremental',
            incremental_strategy='append',
            pre_hook="TRUNCATE TABLE {{ this }}"
         )
}}

select *,
        SHA2(COALESCE(N_NATIONKEY,''),512)   AS EDW_LOAD_KEY_HASH,
        SHA2(
                CONCAT_WS('|',
                COALESCE(N_NATIONKEY,''),
                COALESCE(N_NAME,''),
                COALESCE(N_REGIONKEY,''),
                COALESCE(N_COMMENT,'')
            ),
            512
        ) AS EDW_ROW_KEY_HASH,
        CURRENT_TIMESTAMP() AS EDW_CREATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_UPDATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_LOAD_TIMESTAMP
from {{ source('landing_table', 'LND_GEO_NAATION')}}