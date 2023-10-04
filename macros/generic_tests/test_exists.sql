{# We execute a dummy query without using any table to either return 0 or 1 records.
For a successful test, return 0 records according to the dbt standard. #}
{% macro test_exists(model, column_name) %}

{% set table_exists = load_relation(model) is not none %}

{# Set severity for the user-friendly log message when the test fails. #}
{% if config.get('severity') == 'warn' %}
    {% set log_category = 'UserWarning' %}
{% elif config.get('severity') == 'error' %}
    {% set log_category = 'UserError' %}
{% else %}
    {% set log_category = 'UserError' %}
{% endif %}

{# If the test is for a column and the table doesn't exist, we return success to prevent the same error multiple times. #}
{% if column_name is defined and not table_exists %}
    select 'dummy_value' as "dummy"
    where 1 = 0
{# If column_name is defined, the test is on a column level. #}
{% elif column_name is defined and table_exists %}
    {# Get columns in the relation to check if the field exists. #}
    {%- set columns = adapter.get_columns_in_relation(model) -%}

    {%- set column_names = [] -%}
    {%- for column in columns -%}
        {%- set column_names = column_names.append('"' + column.name + '"') -%}
    {%- endfor -%}

    {% if column_name in column_names %}
        select 'dummy_value' as "dummy"
        where 1 = 0
    {% else %}
        select 'dummy_value' as "dummy"
        {% if var("log_result", False) == True and execute %}
            {{ log(tojson({'Key': 'TestExistsColumn', 'Details': {'model_name': model.name, 'column_name': column_name}, 'Category': log_category, 'Message': 'The field \'' ~ model.name ~ '.' ~ column_name ~ '\' doesn\'t exist in the source data. Note that the field detection is case-sensitive.'}), True) }}
        {% endif %}
    {% endif %}
{# If column_name is not defined, the test is on a table level. #}
{% elif column_name is not defined %}
    {% if table_exists %}
        select 'dummy_value' as "dummy"
        where 1 = 0
    {% else %}
        select 'dummy_value' as "dummy"
        {% if var("log_result", False) == True and execute %}
            {{ log(tojson({'Key': 'TestExistsTable', 'Details': {'model_name': model.name}, 'Category': log_category, 'Message': 'The table \'' ~ model.name ~ '\' doesn\'t exist in the source data. Note that the name is case-sensitive.'}), True) }}
        {% endif %}
    {% endif %}
{% endif %}

{% endmacro %}
