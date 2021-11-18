{% macro to_time(attribute) %}

-- Time format: hh:mm:ss
{% if var("database") == 'snowflake' %}
    try_to_time({{ attribute }}, 'hh24:mi:ss')
{% elif var("database") == 'sqlserver' %}
    try_convert(time, {{ attribute }}, 8)
{% endif %}

{% endmacro %}
