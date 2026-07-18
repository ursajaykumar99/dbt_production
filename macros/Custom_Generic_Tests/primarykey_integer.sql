{% test primarykey_integer(model, column_name) %}

select * 
from {{model}}
where TYPEOF({{ column_name }}) <> 'INTEGER'

{% endtest %}