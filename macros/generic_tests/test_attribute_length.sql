{% macro test_attribute_length(model, column_name, length) %}

select {{ column_name }}
from {{ model }}
where len({{ column_name }}) <> {{ length }}

{% endmacro %}
