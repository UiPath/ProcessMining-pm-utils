{%- macro date_from_timestamp(attribute) -%}

{%- if target.type == 'snowflake' -%}
    to_date({{ attribute }})
{%- elif target.type == 'sqlserver' -%}
    try_convert(date, {{ attribute }})
{%- endif -%}

{%- endmacro -%}
