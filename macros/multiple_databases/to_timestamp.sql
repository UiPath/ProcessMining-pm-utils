{% macro to_timestamp(attribute) %}

-- Timestamp format: YYYY-MM-DD hh:mm:ss
{% if var("database") == 'snowflake' %}
    try_to_timestamp({{ attribute }}, 'YYYY-MM-DD hh24:mi:ss.ff3')
{% elif var("database") == 'sqlserver' %}
    try_convert(datetime, {{ attribute }}, 20)
{% endif %}

{% endmacro %}
