{% macro test_exists(model, column_name) %}

select {{ column_name }}
from {{ model }}
where 1 = 0

{% endmacro %}
