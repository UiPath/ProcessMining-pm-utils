{%- macro datediff(datepart, start_date_field, end_date_field) -%}

{%- if target.type == 'snowflake' -%}
    datediff({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
{%- elif target.type == 'databricks' -%}
    cast({{end_date_field }} as DOUBLE)  - cast({{start_date_field }} as DOUBLE) * 1000
{%- elif target.type == 'sqlserver' -%}
    datediff_big({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
{%- endif -%}

{%- endmacro -%}