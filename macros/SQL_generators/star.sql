{% macro star(relation, except) %}

{%- set selects = [] -%}
{%- set columns = adapter.get_columns_in_relation(relation) -%}

{# If the except parameter is defined, we will only select the columns that are not in the except list. #}
{% if except is defined %}
    {%- for column in columns -%}
        {%- if column.name not in except -%}
                {%- set selects = selects.append('"' + relation.identifier + '"."' + column.name + '"') -%}
        {%- endif -%}
    {%- endfor -%}

    {# Generate the select statements in a later step to not put a comma after the last select. #}
    {% for select in selects %}
        {{ select }}
        {%- if not loop.last -%}
            ,
        {%- endif -%}
    {% endfor %}
{% else %}
        "{{ relation.identifier }}".*
{% endif %}

{% endmacro %}
