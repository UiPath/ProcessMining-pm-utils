{%- macro to_integer(attribute) -%}

{%- if target.type == 'snowflake' -%}
    try_to_number(to_varchar({{ attribute }}))
{%- elif target.type == 'sqlserver' -%}
    try_convert(bigint, {{ attribute }})
{%- endif -%}

{%- endmacro -%}
