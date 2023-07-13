{%- macro enquote( field ) -%}
{%- if target.type == 'XXXsnowflake' -%}
    {{ "\"" ~ field.split(".")|join("\".\"") ~ "\""}}
{%- else -%}
    {{ field }}
{%- endif -%}
{%- endmacro -%}
