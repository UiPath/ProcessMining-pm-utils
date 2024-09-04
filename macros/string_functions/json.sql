{% macro json(field, path) %}

{% if target.type == 'snowflake' %}
    JSON_EXTRACT_PATH_TEXT({{ field }}, '{{ path }}')
{% elif target.type == 'sqlserver' %}
    json_value({{ field }}, '$.{{ path }}')
{% endif %}

{% endmacro %}
