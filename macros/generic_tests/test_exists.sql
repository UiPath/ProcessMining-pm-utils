{% macro test_exists(model, column_name) %}

{% set table_exists = load_relation(model) is not none %}

{# Test fails if 0 records are returned. #}
{{ config(fail_calc = 'case when count(*) = 0 then 1 else 0 end') }}

{# If the test is for a column and the table does not exist, we don't run the test to prevent the same error multiple times. #}
{% if column_name is defined and not table_exists %}

    {# Dummy query to make sure the test always returns a result #}
    select 'dummy_value' as "dummy"

{% else %}

    {# Query the table info in INFORMATION_SCHEMA to check if it exists. If the test is defined on column level, also check if column exists #}
    select *
    from "INFORMATION_SCHEMA"."COLUMNS"
    where "INFORMATION_SCHEMA"."COLUMNS"."TABLE_SCHEMA" = '{{ model.schema }}'
        and "INFORMATION_SCHEMA"."COLUMNS"."TABLE_NAME" = '{{ model.name }}'
        {%- if column_name is defined -%}
        and "INFORMATION_SCHEMA"."COLUMNS"."COLUMN_NAME" = replace('{{ column_name }}', '"', '')
        {%- endif -%}

    {# Query to get the record count when executing the test. #}
    {% set query %}
        select count(*) as "test_record_count"
        from "INFORMATION_SCHEMA"."COLUMNS"
        where "INFORMATION_SCHEMA"."COLUMNS"."TABLE_SCHEMA" = '{{ model.schema }}'
            and "INFORMATION_SCHEMA"."COLUMNS"."TABLE_NAME" = '{{ model.name }}'
            {%- if column_name is defined -%}
            and "INFORMATION_SCHEMA"."COLUMNS"."COLUMN_NAME" = replace('{{ column_name }}', '"', '')
            {% endif %}
    {% endset %}

    {% set result = run_query(query) %}

    {% if execute %}
        {% set test_record_count = result.columns['test_record_count'].values()[0] %}
    {% else %}
        {% set test_record_count = 1 %}
    {% endif %}

    {# User-friendly log message when the test fails. #}
    {% if test_record_count == 0 %}
        {% if var("log_result", False) == True %}
            {% if config.get('severity') == 'warn' %}
                {% set log_category = 'UserWarning' %}
            {% elif config.get('severity') == 'error' %}
                {% set log_category = 'UserError' %}
            {% else %}
                {% set log_category = 'UserError' %}
            {% endif %}
            {% if column_name is defined %}
                {{ log(tojson({'Key': 'TestExistsColumn', 'Details': {'model_name': model.name, 'column_name': column_name}, 'Category': log_category, 'Message': 'The field \'' ~ model.name ~ '.' ~ column_name ~ '\' doesn\'t exist in the source data. Note that the field detection is case-sensitive.'}), True) }}
            {% else %}
                {{ log(tojson({'Key': 'TestExistsTable', 'Details': {'model_name': model.name}, 'Category': log_category, 'Message': 'The table \'' ~ model.name ~ '\' doesn\'t exist in the source data. Note that the name is case-sensitive.'}), True) }}
            {% endif %}
        {% endif %}
    {% endif %}

{% endif %}

{% endmacro %}
