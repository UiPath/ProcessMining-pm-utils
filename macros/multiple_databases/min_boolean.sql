{%- macro min_boolean(field) -%}

{# This macro selects any of the records in an aggregate for boolean fields. #}
{%- if target.type == 'snowflake' -%}
    min({{ field }})
{%- elifif target.type == 'databricks' -%}
    min({{ field }})
{%- elif target.type == 'sqlserver' -%}
    try_convert(bit, min({{ pm_utils.to_integer(field) }}))
{%- endif -%}

{%- endmacro -%}
