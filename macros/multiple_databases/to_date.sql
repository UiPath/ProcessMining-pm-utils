{% macro to_date(attribute) %}

{% if var("database") == 'snowflake' %}
    try_to_date({{ attribute }}, {{ var("date_format") }})
{% elif var("database") == 'sqlserver' %}
    try_convert(date, {{ attribute }}, {{ var("date_format") }})
{% endif %}

{% endmacro %}
