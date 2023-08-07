{%- macro as_varchar(field) -%}

{%- if target.type == 'databricks' -%}
    cast('{{ field }}' as string)
{%- elif target.type == 'snowflake' -%}
    to_varchar('{{ field }}')
{%- elif target.type == 'sqlserver' -%}
    convert(nvarchar(2000), '{{ field }}')
{%- endif -%}

{%- endmacro -%}
