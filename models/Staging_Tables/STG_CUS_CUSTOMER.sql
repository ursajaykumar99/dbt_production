{{  config( 
            materialized='incremental',
            incremental_strategy='append',
            pre_hook="TRUNCATE TABLE {{ this }}"
         )
}}
select  *,
        SHA2(COALESCE(C_CUSTKEY,''),512)   AS EDW_LOAD_KEY_HASH,
        SHA2(
                CONCAT_WS('|',
                COALESCE(C_CUSTKEY,''),
                COALESCE(C_NAME,''),
                COALESCE(C_ADDRESS,''),
                COALESCE(C_NATIONKEY,''),
                COALESCE(C_PHONE,''),
                COALESCE(C_ACCTBAL,''),
                COALESCE(C_MKTSEGMENT,''),
                COALESCE(C_COMMENT,'')
            ),
            512
        ) AS EDW_ROW_KEY_HASH,
        CURRENT_TIMESTAMP() AS EDW_CREATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_UPDATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_LOAD_TIMESTAMP
from {{ source('landing_table', 'LND_CUS_CUSTOMER')}}
