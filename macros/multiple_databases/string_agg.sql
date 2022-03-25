{%- macro string_agg(string_attribute, delimiter) -%}

{# Aggregation of string attributes separated by the delimiter.
   This function can only be used as an aggregate. #}
{%- if target.type == 'snowflake' -%}
    {%- if delimiter is defined -%}
        listagg({{ string_attribute }}, '{{ delimiter }}')
    {%- else -%}
        listagg({{ string_attribute }}, ', ')
    {%- endif -%}
{%- elif target.type == 'sqlserver' -%}
    {%- if delimiter is defined -%}
        string_agg(convert(nvarchar(max), {{ string_attribute}}), '{{ delimiter }}')
    {%- else -%}
        string_agg(convert(nvarchar(max), {{ string_attribute}}), ', ')
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
