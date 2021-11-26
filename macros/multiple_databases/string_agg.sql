{% macro string_agg(string_attribute, delimiter) %}

-- Aggregation of string attributes separated by the delimiter.
-- This function can only be used as an aggregate.
{% if target.type == 'snowflake' %}
    listagg({{ string_attribute }}, '{{ delimiter }}')
{% elif target.type == 'sqlserver' %}
    string_agg({{ string_attribute}}, '{{ delimiter }}')
{% endif %}

{% endmacro %}
