{% macro test_unique_combination_of_columns(model, combination_of_columns, name) %}

{%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}

{%- set column_names = [] -%}
{%- for column in columns_in_relation -%}
    {%- set column_names = column_names.append('"' + column.name + '"') -%}
{%- endfor -%}

{%- set execute_test = true -%}

{% for column in columns %}
    {% if column not in column_names %}
        {%- set execute_test = false -%}
    {%- endif -%}
{%- endfor -%}

{# Only execute test when all fields exist. Otherwise execute a dummy test that always succeeds. #}
{% if execute_test == true %}
    {% set column_list = [] %}
    {% for column in combination_of_columns %}
        {% set column_list = column_list.append('"'+column+'"') %}
    {% endfor %}

    {% set columns_csv = column_list | join(', ') %}

    select {{ columns_csv }}
    from {{ model }}
    group by {{ columns_csv }}
    having count(*) > 1
{% else %}
    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0
{% endif %}

{% endmacro %}
