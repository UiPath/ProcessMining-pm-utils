{% macro test_values_nonnegative(model, column_name) %}

select {{ column_name }}
from {{ model }}
where {{ column_name }} < 0 

{% endmacro %}
