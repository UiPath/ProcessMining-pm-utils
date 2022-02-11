{%- macro left_from_char(attribute, character) -%}

left({{ attribute }}, charindex('{{ character }}', {{ attribute }}) - 1)

{%- endmacro -%}
