{%- macro left_from_char(field, character) -%}

left({{ field }}, charindex('{{ character }}', {{ field }}) - 1)

{%- endmacro -%}
