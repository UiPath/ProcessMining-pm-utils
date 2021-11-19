{% macro test_type_boolean(model, column_name) %}

-- Boolean values are represented by the numeric values 1 and 0.
select {{ column_name }}
from {{ model }}
where not {{ column_name }} in (1, 0)

{% endmacro %}
