{%- macro string_agg(string_field, delimiter) -%}

{# Aggregation of string fields separated by the delimiter.
   This function can only be used as an aggregate. #}
{%- if target.type == 'snowflake' -%}
    {%- if delimiter is defined -%}
        nullif(listagg({{ string_field }}, '{{ delimiter }}'), '')
    {%- else -%}
        nullif(listagg({{ string_field }}, ', '), '')
    {%- endif -%}
{%- elif target.type == 'sqlserver' -%}
    {%- if delimiter is defined -%}
        string_agg(convert(nvarchar(2000), {{ string_field}}), '{{ delimiter }}')
    {%- else -%}
        string_agg(convert(nvarchar(2000), {{ string_field}}), ', ')
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
