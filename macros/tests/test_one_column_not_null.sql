{% macro test_one_column_not_null(model, columns) %}

{# Get columns in the relation to check if the fields exist. #}
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
        {% set column_list = column_list.append('case when "' + column + '" is not null then 1 else 0 end') %}
    {% endfor %}
    {% set calculation = column_list | join('\n    + ') %}

    {# Query the records that fail the test. #}
    select *
    from {{ model }}
    where {{ calculation }} <> 1

    {# Query to get the record count when executing the test. #}
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
        {% if var("log_result", False) == True %}
            {# Generate variable part of log text. #}
            {% set log_text_list = [] %}
            {% for column in columns %}
                {% if loop.index < (columns|length - 1) %}
                    {% set log_entry = "'" ~ column ~ "', " %}
                {% elif loop.index == columns|length - 1 %}
                    {% set log_entry = "'" ~ column ~ "' and " %}
                {% else %}
                    {% set log_entry = "'" ~ column ~ "'" %}
                {% endif %}
                {% set log_text_list = log_text_list.append(log_entry) %}
            {% endfor %}
            {% set log_text = log_text_list | join('') %}
            {# Define log category. #}
            {% if config.get('severity') == 'warn' %}
                {% set log_category = 'UserWarning' %}
            {% elif config.get('severity') == 'error' %}
                {% set log_category = 'UserError' %}
            {% else %}
                {% set log_category = 'UserError' %}
            {% endif %}
            {{ log(tojson({'Key': 'TestOneColumnNotNull', 'Details': {'model_name': model.name, 'log_text': log_text}, 'Category': log_category, 'Message': 'The table \'' ~ model.name ~ '\' contains records that have values in multiple fields for ' ~ log_text ~ '. Make sure that only one field has a value and the others are NULL in each record.'}), True) }}
        {% endif %}
    {% endif %}
{% else %}
    select 'dummy_value' as "dummy"
    where 1 = 0
{% endif %}

{% endmacro %}
