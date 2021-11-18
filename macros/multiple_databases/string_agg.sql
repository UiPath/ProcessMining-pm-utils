{% macro string_agg(string_attribute) %}

-- Aggregation of string attributes separated by a comma.
-- This function can only be used as an aggregate.
{% if var("database") == 'snowflake' %}
    listagg({{ string_attribute }}, ', ')
{% elif var("database") == 'sqlserver' %}
    string_agg({{ string_attribute}}, ', ')
{% endif %}

{% endmacro %}
