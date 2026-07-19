{{  config( 
            materialized='incremental',
            incremental_strategy='append',
            pre_hook="TRUNCATE TABLE {{ this }}"
         )
}}

select *,
       SHA2(COALESCE(S_SUPPKEY,''),512)   AS EDW_LOAD_KEY_HASH,
        SHA2(
                CONCAT_WS('|',
                    COALESCE(S_SUPPKEY,' '),
                    COALESCE(S_NAME,' '),
                    COALESCE(S_ADDRESS,' '),
                    COALESCE(S_NATIONKEY,' '),
                    COALESCE(S_PHONE,' '),
                    COALESCE(S_ACCTBAL,' '),
                    COALESCE(S_COMMENT,' ')
            ),
            512
        ) AS EDW_ROW_KEY_HASH,
        CURRENT_TIMESTAMP() AS EDW_CREATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_UPDATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_LOAD_TIMESTAMP
from {{ source('landing_table', 'LND_SLS_SUPPLIER')}}