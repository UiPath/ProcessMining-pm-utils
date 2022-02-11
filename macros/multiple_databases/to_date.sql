{%- macro to_date(attribute) -%}

{%- if target.type == 'snowflake' -%}
    try_to_date(to_varchar({{ attribute }}), '{{ var("date_format") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(date, {{ attribute }}, {{ var("date_format") }})
{%- endif -%}

{%- endmacro -%}
