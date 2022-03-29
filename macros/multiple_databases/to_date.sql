{%- macro to_date(attribute) -%}

{%- if target.type == 'snowflake' -%}
    try_to_date(to_varchar({{ attribute }}), '{{ var("date_format", "YYYY-MM-DD") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(date, {{ attribute }}, {{ var("date_format", 23) }})
{%- endif -%}

{%- endmacro -%}
