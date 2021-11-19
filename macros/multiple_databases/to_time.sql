{% macro to_time(attribute) %}

{% if var("database") == 'snowflake' %}
    try_to_time({{ attribute }}, {{ var("time_format") }})
{% elif var("database") == 'sqlserver' %}
    try_convert(time, {{ attribute }}, {{ var("time_format") }})
{% endif %}

{% endmacro %}
