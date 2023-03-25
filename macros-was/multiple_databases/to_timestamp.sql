{%- macro to_timestamp(field) -%}

{%- if target.type == 'snowflake' -%}
    try_to_timestamp(to_varchar({{ field }}), '{{ var("datetime_format", "YYYY-MM-DD hh24:mi:ss.ff3") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(datetime2, {{ field }}, {{ var("datetime_format", 21) }})
{%- endif -%}

{%- endmacro -%}
