{{  config( 
            materialized='incremental',
            incremental_strategy='append',
            pre_hook="TRUNCATE TABLE {{ this }}"
         )
}}

select *,
       SHA2(COALESCE(P_PARTKEY,''),512)   AS EDW_LOAD_KEY_HASH,
        SHA2(
                CONCAT_WS('|',
                    COALESCE(P_PARTKEY,' '),
                    COALESCE(P_NAME,' '),
                    COALESCE(P_MFGR,' '),
                    COALESCE(P_BRAND,' '),
                    COALESCE(P_TYPE,' '),
                    COALESCE(P_SIZE,' '),
                    COALESCE(P_CONTAINER,' '),
                    COALESCE(P_RETAILPRICE,' '),
                    COALESCE(P_COMMENT,' ')
            ),
            512
        ) AS EDW_ROW_KEY_HASH,
        CURRENT_TIMESTAMP() AS EDW_CREATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_UPDATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_LOAD_TIMESTAMP
from {{ source('landing_table', 'LND_SLS_PART')}}