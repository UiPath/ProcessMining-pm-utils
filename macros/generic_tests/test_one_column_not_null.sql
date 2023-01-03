{% macro test_one_column_not_null(model, columns, name) %}

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
    {% for column in columns %}
        {% set column_list = column_list.append('case when "' + column + '" is not NULL then 1 else 0 end') %}
    {% endfor %}
    {% set calculation = column_list | join('\n    + ') %}

    select *
    from {{ model }}
    where {{ calculation }} <> 1
{% else %}
    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0
{% endif %}

{% endmacro %}
