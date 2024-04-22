{% macro stddev(field, relation) %}

{%- if target.type in ('databricks', 'snowflake') -%}
    stddev({{ field }})
{%- elif target.type == 'sqlserver' -%}
    stdev({{ field }})
{%- endif -%}

{% endmacro %}
