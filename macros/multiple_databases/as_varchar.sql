{%- macro as_varchar(field) -%}

{%- if target.type == 'snowflake' -%}
    to_varchar('{{ field }}')
{%- elif target.type == 'sqlserver' -%}
    convert(nvarchar(2000), '{{ field }}')
{%- elif target.type == 'databricks' -%}
    cast('{{ field }}' as STRING)
{%- endif -%}

{%- endmacro -%}
