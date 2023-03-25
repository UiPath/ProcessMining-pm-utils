{%- macro to_double(field) -%}

{%- if target.type == 'snowflake' -%}
    try_to_double(to_varchar({{ field }}))
{%- elif target.type == 'sqlserver' -%}
    try_convert(float, {{ field }})
{%- endif -%}

{%- endmacro -%}
