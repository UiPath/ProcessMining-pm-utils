{%- macro enquote( field ) -%}
{%- if target.type == 'snowflake' -%}
    {{ "\"" ~ field.split(".")|join("\".\"") ~ "\""}}
{%- else -%}
    {{ field }}
{%- endif -%}
{%- endmacro -%}
