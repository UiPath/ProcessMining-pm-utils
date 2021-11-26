{% macro to_integer(attribute) %}

{% if target.type == 'snowflake' %}
    try_to_number({{ attribute }})
{% elif target.type == 'sqlserver' %}
    try_convert(bigint, {{ attribute }})
{% endif %}

{% endmacro %}
