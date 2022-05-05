{%- macro to_varchar(field) -%}

{%- if target.type == 'snowflake' -%}
    to_varchar({{ field }})
{%- elif target.type == 'sqlserver' -%}
    convert(nvarchar(max), {{ field }})
{%- endif -%}

{%- endmacro -%}
