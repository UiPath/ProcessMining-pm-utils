{%- macro concat() -%}

concat(
{%- for argument in varargs -%}
    coalesce({{ argument }}, '')
    {%- if not loop.last -%}
        ,
    {%- endif -%}
{%- endfor -%}
)

{%- endmacro -%}
