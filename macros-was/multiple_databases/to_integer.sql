{%- macro to_integer(field) -%}

{%- if target.type == 'snowflake' -%}
    try_to_number(to_varchar({{ field }}))
{%- elif target.type == 'sqlserver' -%}
    try_convert(bigint, {{ field }})
{%- endif -%}

{%- endmacro -%}
