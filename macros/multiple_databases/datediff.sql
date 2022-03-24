{%- macro datediff(datepart, start_date_attribute, end_date_attribute) -%}

{%- if target.type == 'snowflake' -%}
    datediff({{ datepart }}, {{ start_date_attribute }}, {{ end_date_attribute }})
{%- elif target.type == 'sqlserver' -%}
    datediff_big({{ datepart }}, {{ start_date_attribute }}, {{ end_date_attribute }})
{%- endif -%}

{%- endmacro -%}
