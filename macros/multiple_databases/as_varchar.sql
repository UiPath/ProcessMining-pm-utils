{%- macro as_varchar(field) -%}

{%- if target.type == 'snowflake' -%}
    to_varchar('{{ "\"" ~ field.split(".")|join("\".\"") ~ "\""}}')
{%- elif target.type == 'sqlserver' -%}
    convert(nvarchar(2000), '{{ field }}')
{%- else -%}
    '{{ field }}'
{%- endif -%}

{%- endmacro -%}
