{%- macro to_time(field) -%}

{%- if target.type == 'snowflake' -%}
    try_to_time(to_varchar({{ field }}), '{{ var("time_format", "hh24:mi:ss.ff3") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(time, {{ field }}, {{ var("time_format", 14) }})
{%- endif -%}

{%- endmacro -%}
