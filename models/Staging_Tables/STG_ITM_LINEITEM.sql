{{  config( 
            materialized='incremental',
            incremental_strategy='append',
            pre_hook="TRUNCATE TABLE {{ this }}"
         )
}}

select *,
       SHA2(   CONCAT_WS('|',
                    COALESCE(L_ORDERKEY,' '),
                    COALESCE(L_PARTKEY,' '),
                    COALESCE(L_SUPPKEY,' '),
                    COALESCE(L_LINENUMBER,' ')),512)   AS EDW_LOAD_KEY_HASH,
        SHA2(
                CONCAT_WS('|',
                    COALESCE(L_ORDERKEY,' '),
                    COALESCE(L_PARTKEY,' '),
                    COALESCE(L_SUPPKEY,' '),
                    COALESCE(L_LINENUMBER,' '),
                    COALESCE(L_QUANTITY,' '),
                    COALESCE(L_EXTENDEDPRICE,' '),
                    COALESCE(L_DISCOUNT,' '),
                    COALESCE(L_TAX,' '),
                    COALESCE(L_RETURNFLAG,' '),
                    COALESCE(L_LINESTATUS,' '),
                    COALESCE(L_SHIPDATE,' '),
                    COALESCE(L_COMMITDATE,' '),
                    COALESCE(L_RECEIPTDATE,' '),
                    COALESCE(L_SHIPINSTRUCT,' '),
                    COALESCE(L_SHIPMODE,' '),
                    COALESCE(L_COMMENT,' ')
            ),
            512
        ) AS EDW_ROW_KEY_HASH,
        CURRENT_TIMESTAMP() AS EDW_CREATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_UPDATED_TIMESTAMP,
        CURRENT_TIMESTAMP() AS EDW_LOAD_TIMESTAMP

from {{ source('landing_table', 'LND_ITM_LINEITEM')}}