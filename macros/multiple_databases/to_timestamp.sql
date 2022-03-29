{%- macro to_timestamp(attribute) -%}

{%- if target.type == 'snowflake' -%}
    try_to_timestamp(to_varchar({{ attribute }}), '{{ var("datetime_format", "YYYY-MM-DD hh24:mi:ss.ff3") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(datetime, {{ attribute }}, {{ var("datetime_format", 21) }})
{%- endif -%}

{%- endmacro -%}
