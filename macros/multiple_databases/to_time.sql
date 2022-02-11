{%- macro to_time(attribute) -%}

{%- if target.type == 'snowflake' -%}
    try_to_time(to_varchar({{ attribute }}), '{{ var("time_format") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(time, {{ attribute }}, {{ var("time_format") }})
{%- endif -%}

{%- endmacro -%}
