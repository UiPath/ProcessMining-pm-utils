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
        nullif(string_agg(convert(nvarchar(2000), {{ string_field}}), '{{ delimiter }}'), '')
    {%- else -%}
        nullif(string_agg(convert(nvarchar(2000), {{ string_field}}), ', '), '')
    {%- endif -%}
{%- elif target.type == 'databricks' -%}
    {%- if delimiter is defined -%}
        concat_ws('{{ delimiter }}', collect_list(cast({{ string_field }} as string)))
    {%- else -%}
        concat_ws(', ', collect_list(cast({{ string_field }} as string)))
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
