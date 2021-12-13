{% macro test_unique_combination_of_columns(model, combination_of_columns) %}

{% set column_list = [] %}
{% for column in combination_of_columns %}
    {% set column_list = column_list.append('"'+column+'"') %}
{% endfor %}

{% set columns_csv = column_list | join(', ') %}

select {{ columns_csv }}
from {{ model }}
group by {{ columns_csv }}
having count(*) > 1

{% endmacro %}
