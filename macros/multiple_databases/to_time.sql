{%- macro to_time(attribute) -%}

{%- if target.type == 'snowflake' -%}
    try_to_time(to_varchar({{ attribute }}), '{{ var("time_format", "hh24:mi:ss") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(time, {{ attribute }}, {{ var("time_format", 8) }})
{%- endif -%}

{%- endmacro -%}
