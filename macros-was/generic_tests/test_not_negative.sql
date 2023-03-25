{% macro test_not_negative(model, column_name) %}

select {{ column_name }}
from {{ model }}
where {{ column_name }} < 0 

{% endmacro %}
