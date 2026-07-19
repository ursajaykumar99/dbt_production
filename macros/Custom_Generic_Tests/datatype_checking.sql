{% test datatype_checking(model, column_name, data_type1) %}

select * 
from {{model}}
where TYPEOF({{ column_name }}) <> '{{data_type1}}'

{% endtest %}