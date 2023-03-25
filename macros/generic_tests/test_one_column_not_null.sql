{% macro test_one_column_not_null(model, columns) %}

{% set column_list = [] %}
{% for column in columns %}
    {% set column_list = column_list.append('case when "' + column + '" is not NULL then 1 else 0 end') %}
{% endfor %}

{% set calculation = column_list | join('\n    + ') %}

select *
from {{ model }}
where {{ calculation }} <> 1

{% endmacro %}
