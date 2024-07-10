{% macro stddev(field, relation) %}

{%- if target.type == 'snowflake' -%}
    stddev({{ field }})
{%- elif target.type == 'sqlserver' -%}
    stdev({{ field }})
{%- endif -%}

{% endmacro %}
