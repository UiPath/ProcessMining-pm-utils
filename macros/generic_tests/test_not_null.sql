{% macro test_not_null(model, column_name) %}

{# Get columns in the relation to check if the field exists. #}
{%- set columns = adapter.get_columns_in_relation(model) -%}

{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append('"' + column.name + '"') -%}
{%- endfor -%}

{# Only execute test when field exists. Otherwise execute a dummy test that always succeeds. #}
{% if column_name in column_names %}
    {# Query the records that fail the test. #}
    {%- if target.type == 'snowflake' -%}
        select {{ column_name }}
        from {{ model }}
        where ({{ column_name }}) is null or len({{ column_name }}) = 0
    {%- elif target.type == 'sqlserver' -%}
        select {{ column_name }}
        from {{ model }}
        where {{ column_name }} is null or datalength({{ column_name }}) = 0
    {%- endif -%}
    
    {# Query to get the record count when executing the test. #}
    {% set query %}
        {%- if target.type == 'snowflake' -%}
            select count(*) as "test_record_count"
            from {{ model }}
            where {{ column_name }} is null or len({{ column_name }}) = 0
        {%- elif target.type == 'sqlserver' -%}
            select count(*) as "test_record_count"
            from {{ model }}
            where {{ column_name }} is null or datalength({{ column_name }}) = 0
        {%- endif -%}
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
            {% if config.get('severity') == 'warn' %}
                {% set log_category = 'UserWarning' %}
            {% elif config.get('severity') == 'error' %}
                {% set log_category = 'UserError' %}
            {% else %}
                {% set log_category = 'UserError' %}
            {% endif %}
            {{ log(tojson({'Key': 'TestNotNull', 'Details': {'model_name': model.name, 'column_name': column_name}, 'Category': log_category, 'Message': 'The field \'' ~ model.name ~ '.' ~ column_name ~ '\' shouldn\'t contain NULL or empty values.'}), True) }}
        {% endif %}
    {% endif %}
{% else %}
    select 'dummy_value' as "dummy"
    where 1 = 0
{% endif %}

{% endmacro %}
