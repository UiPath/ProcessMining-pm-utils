{%- macro to_boolean(attribute) -%}

{%- if target.type == 'snowflake' -%}
    {%- if attribute in ('true', 'false', '1', '0') -%}
        try_to_boolean('{{ attribute }}')
    {%- else -%}
        try_to_boolean(to_varchar({{ attribute }}))
    {%- endif -%}
{%- elif target.type == 'sqlserver' -%}
    {%- if attribute in ('true', 'false', '1', '0') -%}
        try_convert(bit, '{{ attribute }}')
    {%- else -%}
        try_convert(bit, {{ attribute }})
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
