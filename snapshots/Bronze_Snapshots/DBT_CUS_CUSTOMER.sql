{% snapshot DBT_CUS_CUSTOMER %}

{{
    config(
        unique_key='EDW_LOAD_KEY_HASH',
        strategy='check',
        check_cols=['EDW_ROW_KEY_HASH'],
        hard_deletes='invalidate'
    )
}}

SELECT *
FROM {{ ref('STG_CUS_CUSTOMER') }}
WHERE 1 = 1
QUALIFY ROW_NUMBER() OVER(PARTITION BY EDW_LOAD_KEY_HASH ORDER BY EDW_LOAD_KEY_HASH) = 1

{% endsnapshot %}