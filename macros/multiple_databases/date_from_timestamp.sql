{%- macro date_from_timestamp(field) -%}

{%- if target.type == 'snowflake' -%}
    to_date({{ field }})
{%- elif target.type == 'sqlserver' -%}
    try_convert(date, {{ field }})
{%- endif -%}

{%- endmacro -%}
