{% macro to_timestamp(attribute) %}

{% if target.type == 'snowflake' %}
    try_to_timestamp({{ attribute }}, {{ var("datetime_format") }})
{% elif target.type == 'sqlserver' %}
    try_convert(datetime, {{ attribute }}, {{ var("datetime_format") }})
{% endif %}

{% endmacro %}
