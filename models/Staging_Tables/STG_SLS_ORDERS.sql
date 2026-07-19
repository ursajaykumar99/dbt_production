{{  config( 
            materialized='incremental',
            incremental_strategy='append',
            pre_hook="TRUNCATE TABLE {{ this }}"
         )
}}

select *,
       SHA2(COALESCE(O_ORDERKEY,''),512)   AS EDW_LOAD_KEY_HASH,
        SHA2(
                CONCAT_WS('|',
                    COALESCE(O_ORDERKEY,' '),
                    COALESCE(O_CUSTKEY,' '),
                    COALESCE(O_ORDERSTATUS,' '),
                    COALESCE(O_TOTALPRICE,' '),
                    COALESCE(O_ORDERDATE,' '),
                    COALESCE(O_ORDERPRIORITY,' '),
                    COALESCE(O_CLERK,' '),
                    COALESCE(O_SHIPPRIORITY,' '),
                    COALESCE(O_COMMENT,' ')
            ),
            512
        ) AS EDW_ROW_KEY_HASH,
        CURRENT_TIMESTAMP() AS EDW_CREATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_UPDATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_LOAD_TIMESTAMP
from {{ source('landing_table', 'LND_SLS_ORDERS')}}