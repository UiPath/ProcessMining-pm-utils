{%- macro to_varchar(attribute) -%}

{%- if target.type == 'snowflake' -%}
    to_varchar({{ attribute }})
{%- elif target.type == 'sqlserver' -%}
    convert(nvarchar(max), {{ attribute }})
{%- endif -%}

{%- endmacro -%}
