{% macro test_format(model, column_name, data_type) %}

{# Test fails if the difference in number of null values before and after data type casting is different. #}
{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

{# Get columns in the relation to check if the field exists. #}
{%- set columns = adapter.get_columns_in_relation(model) -%}

{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append( column.name ) -%}
{%- endfor -%}

{# Only execute test when field exists. Otherwise execute a dummy test that always succeeds. #}
{% if column_name in column_names %}
    {# Query to get the difference in number of null values. #}
    {% set query %}
        select
            abs(count_before_casting - count_after_casting) as diff_count
        from (
            select
                count(*) as count_before_casting 
            from {{ model }} 
            where {{ column_name }} is null) as model_before_casting
            cross join (
                select
                    count(*) as count_after_casting 
                from {{ model }}
                {%- if data_type == 'date' -%}
                where {{ pm_utils.to_date(column_name) }} is null) as model_after_casting
                {%- elif data_type == 'time' -%}
                where {{ pm_utils.to_time(column_name) }} is null) as model_after_casting
                {%- elif data_type == 'datetime' -%}
                where {{ pm_utils.to_timestamp(column_name) }} is null) as model_after_casting
                {%- endif -%}
    {% endset %}
    {{ query }}

    {% set result = run_query(query) %}

    {% if execute %}
        {% set test_diff_count = result.columns['diff_count'].values()[0] %}
    {% else %}
        {% set test_diff_count = 0 %}
    {% endif %}

    {# User-friendly log message when the test fails. #}
    {% if test_diff_count > 0 %}
        {%- if target.type == 'snowflake' -%}
            {%- if data_type == 'date' -%}
                {% set log_text = var("date_format", "YYYY-MM-DD") %}
            {%- elif data_type == 'time' -%}
                {% set log_text = var("time_format", "hh24:mi:ss.ff3")  %}
            {%- elif data_type == 'datetime' -%}
                {% set log_text = var("datetime_format", "YYYY-MM-DD hh24:mi:ss.ff3")  %}
            {%- endif -%}
        {%- elif target.type == 'sqlserver' -%}
            {%- if data_type == 'date' -%}
                {% set log_text = var("date_format", 23) %}
            {%- elif data_type == 'time' -%}
                {% set log_text = var("time_format", 14)  %}
            {%- elif data_type == 'datetime' -%}
                {% set log_text = var("datetime_format", 21)  %}
            {%- endif -%}
        {%- endif -%}
        {% if var("log_result", False) == True %}
            {% if config.get('severity') == 'warn' %}
                {% set log_category = 'UserWarning' %}
            {% elif config.get('severity') == 'error' %}
                {% set log_category = 'UserError' %}
            {% else %}
                {% set log_category = 'UserError' %}
            {% endif %}
            {{ log(tojson({'Key': 'TestFormat', 'Details': {'model_name': model.name, 'column_name': column_name, 'log_text': log_text}, 'Category': log_category, 'Message': 'The field \'' ~ model.name ~ '.' ~ column_name ~ '\' contains values that don\'t follow the format ' ~ log_text ~ '.'}), True) }}
        {% endif %}
    {% endif %}
{% else %}
    select 0 as diff_count
{% endif %}

{% endmacro %}
