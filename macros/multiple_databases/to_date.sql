{%- macro to_date(field) -%}

{%- if target.type == 'snowflake' -%}
    try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(date, {{ field }}, {{ var("date_format", 23) }})
{%- endif -%}

{%- endmacro -%}
