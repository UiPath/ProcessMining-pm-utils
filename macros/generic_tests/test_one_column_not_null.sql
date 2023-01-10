{% macro test_one_column_not_null(model, columns, name) %}

{%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}

{%- set column_names = [] -%}
{%- for column in columns_in_relation -%}
    {%- set column_names = column_names.append(column.name) -%}
{%- endfor -%}

{%- set ns = namespace(execute_test = true) -%}

{% for column in columns %}
    {% if column not in column_names %}
        {%- set ns.execute_test = false -%}
    {%- endif -%}
{%- endfor -%}

{# Only execute test when all fields exist. Otherwise execute a dummy test that always succeeds. #}
{% if ns.execute_test %}
    {% set column_list = [] %}
    {% for column in columns %}
        {% set column_list = column_list.append('case when "' + column + '" is not NULL then 1 else 0 end') %}
    {% endfor %}
    {% set calculation = column_list | join('\n    + ') %}

    select *
    from {{ model }}
    where {{ calculation }} <> 1

    {% set query %}
        select count(*) as "test_record_count"
        from {{ model }}
        where {{ calculation }} <> 1
    {% endset %}

    {% set result = run_query(query) %}

    {% if execute %}
        {% set test_record_count = result.columns['test_record_count'].values()[0] %}
    {% else %}
        {% set test_record_count = 0 %}
    {% endif %}

    {# User-friendly log message when the test fails. #}
    {% if test_record_count > 0 %}
        {{ log("Message", True) }}
    {% endif %}
{% else %}
    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0
{% endif %}

{% endmacro %}
