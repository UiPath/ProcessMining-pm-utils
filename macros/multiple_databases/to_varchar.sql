{%- macro to_varchar(field) -%}

{%- if target.type == 'snowflake' -%}
    to_varchar({{ field }})
{%- elif target.type == 'databricks' -%}
    cast({{ field }} as STRING)
{%- elif target.type == 'sqlserver' -%}
    case
        when charindex(' ', {{ field }}) > 0
            then convert(nvarchar(2000), {{ field }})
        else
            nullif(convert(nvarchar(2000), {{ field }}),'')
    end
{%- endif -%}

{%- endmacro -%}
