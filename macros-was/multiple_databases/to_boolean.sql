{%- macro to_boolean(field) -%}

{%- if target.type == 'snowflake' -%}
    {%- if field in ('true', 'false', '1', '0') -%}
        try_to_boolean('{{ field }}')
    {%- else -%}
        try_to_boolean(to_varchar({{ field }}))
    {%- endif -%}
{%- elif target.type == 'sqlserver' -%}
    {%- if field in ('true', 'false', '1', '0') -%}
        try_convert(bit, '{{ field }}')
    {%- else -%}
        try_convert(bit, {{ field }})
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
