{% macro string_agg(string_attribute, delimiter) %}

-- Aggregation of string attributes separated by the delimiter.
-- This function can only be used as an aggregate.
{% if var("database") == 'snowflake' %}
    listagg({{ string_attribute }}, '{{ delimiter }}')
{% elif var("database") == 'sqlserver' %}
    string_agg({{ string_attribute}}, '{{ delimiter }}')
{% endif %}

{% endmacro %}
