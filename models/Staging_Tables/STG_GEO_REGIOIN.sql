{{  config( 
            materialized='incremental',
            incremental_strategy='append',
            pre_hook="TRUNCATE TABLE {{ this }}"
         )
}}

select *,
        SHA2(COALESCE(R_REGIONKEY,''),512)   AS EDW_LOAD_KEY_HASH,
        SHA2(
                CONCAT_WS('|',
                COALESCE(R_REGIONKEY,''),
                COALESCE(R_NAME,''),
                COALESCE(R_COMMENT,'')
            ),
            512
        ) AS EDW_ROW_KEY_HASH,
        CURRENT_TIMESTAMP() AS EDW_CREATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_UPDATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_LOAD_TIMESTAMP
from {{ source('landing_table', 'LND_GEO_REGIOIN')}}