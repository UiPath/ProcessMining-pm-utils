{%- macro to_double(attribute) -%}

{%- if target.type == 'snowflake' -%}
    try_to_double(to_varchar({{ attribute }}))
{%- elif target.type == 'sqlserver' -%}
    try_convert(float, {{ attribute }})
{%- endif -%}

{%- endmacro -%}
