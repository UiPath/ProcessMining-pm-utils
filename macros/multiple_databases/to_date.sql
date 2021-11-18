{% macro to_date(attribute) %}

-- Date format: YYYY-MM-DD hh:mm:ss
{% if var("database") == 'snowflake' %}
    try_to_date({{ attribute }}, 'YYYY-MM-DD')
{% elif var("database") == 'sqlserver' %}
    try_convert(date, {{ attribute }}, 23)
{% endif %}

{% endmacro %}
