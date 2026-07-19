{% macro generate_table_columns(table_name) %}

{% set sql_query %}
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = CONCAT('LND_',SUBSTR('{{ table_name }}',5))
ORDER BY ORDINAL_POSITION ASC
{% endset %}

{% set results = run_query(sql_query) %}
{% if execute %}
{%for row in results.rows %}
{{row[0]}} {%if not loop.last %} , {% endif %}
{% endfor %}
{% endif %}
{% endmacro %}