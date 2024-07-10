{%- macro charindex(expression_to_find, field, start_location=None) -%}
{%- set expression_length -%}
    {% if target.type == 'sqlserver' -%}
        datalength('{{ expression_to_find }}')
    {% else -%}
        length('{{ expression_to_find }}')
    {% endif -%}
{%- endset -%}
case
    when {{ expression_length }} > 0
    then
        {% if start_location is none -%}
            charindex('{{ expression_to_find }}', {{ field }})
        {% else -%}
            charindex('{{ expression_to_find }}', {{ field }}, {{ start_location }})
        {% endif -%}
    else
        0
end
{%- endmacro -%}
