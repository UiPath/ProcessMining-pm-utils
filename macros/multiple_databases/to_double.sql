{% macro to_double(attribute) %}

{% if target.type == 'snowflake' %}
    try_to_double({{ attribute }})
{% elif target.type == 'sqlserver' %}
    try_convert(float, {{ attribute }})
{% endif %}

{% endmacro %}
