{% macro test_unique(model, column_name) %}

{# Get columns in the relation to check if the field exists. #}
{%- set columns = adapter.get_columns_in_relation(model) -%}

{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append('"' + column.name + '"') -%}
{%- endfor -%}

{# Only execute test when field exists. Otherwise execute a dummy test that always succeeds. #}
{% if column_name in column_names %}
    {# Query the records that fail the test. #}
    select {{ column_name }}
    from {{ model }}
    group by {{ column_name }}
    having count(*) > 1

    {# Query to get the record count when executing the test. #}
    {% set query %}
        select count(*) as "test_record_count"
        from (
            select {{ column_name }}
            from {{ model }}
            group by {{ column_name }}
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
        {% if var("log_result", False) == True %}
            {{ log('{"Key": "TestUnique", "Details": {"model_name": "" ~ model.name ~ "", "column_name": "" ~ column_name ~ ""}, "Category": "UserError", "Message": "There are duplicate values in \'" ~ model.name ~ "." ~ column_name ~ "\'. Make sure that all records have unique values."}', True) }}
        {% endif %}
    {% endif %}
{% else %}
    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0
{% endif %}

{% endmacro %}
