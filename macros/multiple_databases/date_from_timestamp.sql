{% macro date_from_timestamp(attribute) %}

{% if var("database") == 'snowflake' %}
    to_date({{ attribute }})
{% elif var("database") == 'sqlserver' %}
    try_convert(date, {{ attribute }})
{% endif %}

{% endmacro %}
