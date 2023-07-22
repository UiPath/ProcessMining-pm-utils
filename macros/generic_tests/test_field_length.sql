{% macro test_field_length(model, column_name, length) %}

{# Get columns in the relation to check if the field exists. #}
{%- set columns = adapter.get_columns_in_relation(model) -%}

{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- if target.type == 'databricks' -%}
        {%- set column_names = column_names.append('`' + column.name + '`') -%}
    {%- else -%}
        {%- set column_names = column_names.append('"' + column.name + '"') -%}
    {%- endif -%}
{%- endfor -%}

{# Only execute test when field exists. Otherwise execute a dummy test that always succeeds. #}
{% if column_name in column_names %}
    {# Query the records that fail the test. #}
    select {{ column_name }}
    from {{ model }}
    where len({{ column_name }}) <> {{ length }}

    {# Query to get the record count when executing the test. #}
    {% set query %}
        select count(*) as test_record_count
        from {{ model }}
        where len({{ column_name }}) <> {{ length }}
    {% endset %}

    {% set result = run_query(query) %}

    {% if execute %}
        {% set test_record_count = result.columns[0].values()[0] %}
    {% else %}
        {% set test_record_count = 0 %}
    {% endif %}

    {# User-friendly log message when the test fails. #}
    {% if test_record_count > 0 %}
        {% if var(log_result, False) == True %}
            {% if config.get('severity') == 'warn' %}
                {% set log_category = 'UserWarning' %}
            {% elif config.get('severity') == 'error' %}
                {% set log_category = 'UserError' %}
            {% else %}
                {% set log_category = 'UserError' %}
            {% endif %}
            {{ log(tojson({'Key': 'TestFieldLength', 'Details': {'model_name': model.name, 'column_name': column_name, 'length': length}, 'Category': log_category, 'Message': 'Not all records of the field \'' ~ model.name ~ '.' ~ column_name ~ '\' have the expected ' ~ length ~ ' character length. Please investigate whether the values are loaded as desired.'}), True) }}
        {% endif %}
    {% endif %}
{% else %}
    select 'dummy_value' as dummy
    where 1 = 0
{% endif %}

{% endmacro %}
