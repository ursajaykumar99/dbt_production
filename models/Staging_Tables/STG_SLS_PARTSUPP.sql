{{  config( 
            materialized='incremental',
            incremental_strategy='append',
            pre_hook="TRUNCATE TABLE {{ this }}"
         )
}}
select *,
        SHA2(   CONCAT_WS('|',
                    COALESCE(PS_PARTKEY,' '),
                    COALESCE(PS_SUPPKEY,' ')),512)   AS EDW_LOAD_KEY_HASH,
        SHA2(
                CONCAT_WS('|',
                    COALESCE(PS_PARTKEY,' '),
                    COALESCE(PS_SUPPKEY,' '),
                    COALESCE(PS_AVAILQTY,' '),
                    COALESCE(PS_SUPPLYCOST,' '),
                    COALESCE(PS_COMMENT,' ')
            ),
            512
        ) AS EDW_ROW_KEY_HASH,
        CURRENT_TIMESTAMP() AS EDW_CREATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_UPDATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_LOAD_TIMESTAMP
from {{ source('landing_table', 'LND_SLS_PARTSUPP')}}