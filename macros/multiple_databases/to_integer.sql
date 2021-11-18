{% macro to_integer(attribute) %}

{% if var("database") == 'snowflake' %}
    try_to_number({{ attribute }})
{% elif var("database") == 'sqlserver' %}
    try_convert(bigint, {{ attribute }})
{% endif %}

{% endmacro %}
