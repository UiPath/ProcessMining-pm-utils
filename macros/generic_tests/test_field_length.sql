{% macro test_field_length(model, column_name, length) %}

{%- set columns = adapter.get_columns_in_relation(model) -%}

{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append('"' + column.name + '"') -%}
{%- endfor -%}

{# Only execute test when field exists. Otherwise execute a dummy test that always succeeds. #}
{% if column_name in column_names %}
    select {{ column_name }}
    from {{ model }}
    where len({{ column_name }}) <> {{ length }}

    {% set query %}
        select count(*) as "test_record_count"
        from {{ model }}
        where len({{ column_name }}) <> {{ length }}
    {% endset %}

    {% set result = run_query(query) %}

    {% if execute %}
        {% set test_record_count = result.columns['test_record_count'].values()[0] %}
    {% else %}
        {% set test_record_count = 0 %}
    {% endif %}

    {# User-friendly log message when the test fails. #}
    {% if test_record_count > 0 %}
        {{ log("Not all records of the field '" ~ model.name ~ "." ~ column_name ~ "' have the expected " ~ length ~ " character length. Please investigate whether the values are loaded as desired.", True) }}
    {% endif %}
{% else %}
    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0
{% endif %}

{% endmacro %}
