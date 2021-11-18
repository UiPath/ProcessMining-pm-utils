{% macro to_double(attribute) %}

{% if var("database") == 'snowflake' %}
    try_to_double({{ attribute }})
{% elif var("database") == 'sqlserver' %}
    try_convert(float, {{ attribute }})
{% endif %}

{% endmacro %}
