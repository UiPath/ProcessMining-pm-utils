{%- macro charindex(expression_to_find, field, start_location=None) -%}
case
    when len('{{ expression_to_find }}') > 0
    then
        {% if start_location is none -%}
            {% if target.type == 'databricks' -%}
                position('{{ expression_to_find }}', {{ field }})
            {% else -%}
                charindex('{{ expression_to_find }}', {{ field }})
            {% endif -%}
        {% else -%}
            {% if target.type == 'databricks' -%}
                position('{{ expression_to_find }}', {{ field }}, {{ start_location }})
            {% else -%}
                charindex('{{ expression_to_find }}', {{ field }}, {{ start_location }})
            {% endif -%}
        {% endif -%}
    else
        0
end
{%- endmacro -%}
