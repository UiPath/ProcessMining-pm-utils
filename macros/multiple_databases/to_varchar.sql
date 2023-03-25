{%- macro to_varchar(field) -%}

{%- if target.type == 'snowflake' -%}
    to_varchar({{ field }})
{%- elif target.type == 'databricks' -%}
    cast({{ field }} as STRING)
{%- elif target.type == 'sqlserver' -%}
    convert(nvarchar(2000), {{ field }})
{%- else -%}
    cast({{ field }} as STRING)
{%- endif -%}

{%- endmacro -%}
