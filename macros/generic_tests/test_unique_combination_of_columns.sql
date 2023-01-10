{% macro test_unique_combination_of_columns(model, combination_of_columns) %}

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
    {% for column in combination_of_columns %}
        {% set column_list = column_list.append('"'+column+'"') %}
    {% endfor %}

    {% set columns_csv = column_list | join(', ') %}

    select {{ columns_csv }}
    from {{ model }}
    group by {{ columns_csv }}
    having count(*) > 1

    {% set query %}
        select count(*) as "test_record_count"
        from (
            select {{ columns_csv }}
            from {{ model }}
            group by {{ columns_csv }}
            having count(*) > 1) as "table_grouped"
    {% endset %}

    {% set result = run_query(query) %}

    {% if execute %}
        {% set test_record_count = result.columns['test_record_count'].values()[0] %}
    {% else %}
        {% set test_record_count = 0 %}
    {% endif %}

    {# User-friendly log message when the test fails. #}
    {% if test_record_count > 0 %}
        {% set log_text = [] %}
        {% for column in columns %}
            {% set log_text = log_text.append("'" ~ model.column ~ "'") %}
            {% if loop.index0 < (columns|length - 1) %}
                {% set log_text = log_text.append(", ") %}
            {% elif loop.index0 == columns|length - 1 %}
                {% set log_text = log_text.append(" and ") %}
            {% endif %}
        {% endfor %}
        {{ log("There are duplicate values in the combination of the fields " ~ log_text ~ ". Make sure all records have a unique combination of values for these fields.", True) }}
    {% endif %}
{% else %}
    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0
{% endif %}

{% endmacro %}
