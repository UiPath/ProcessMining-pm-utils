{% macro to_date(attribute) %}

{% if target.type == 'snowflake' %}
    try_to_date({{ attribute }}, '{{ var("date_format") }}')
{% elif target.type == 'sqlserver' %}
    try_convert(date, {{ attribute }}, {{ var("date_format") }})
{% endif %}

{% endmacro %}
