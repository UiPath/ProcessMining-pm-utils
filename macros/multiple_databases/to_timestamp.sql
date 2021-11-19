{% macro to_timestamp(attribute) %}

{% if var("database") == 'snowflake' %}
    try_to_timestamp({{ attribute }}, {{ var("datetime_format") }})
{% elif var("database") == 'sqlserver' %}
    try_convert(datetime, {{ attribute }}, {{ var("datetime_format") }})
{% endif %}

{% endmacro %}
