{%- macro datediff(datepart, start_date_field, end_date_field) -%}

{%- if target.type == 'snowflake' -%}
    {# Snowflake week is defined from Monday to Sunday. Add one day to align computation for week differences. #}
    {%- if datepart == 'week' -%}
        datediff({{ datepart }}, dateadd(day, 1, {{ start_date_field }}), dateadd(day, 1, {{ end_date_field }}))
    {%- else -%}
        datediff({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
    {%- endif -%}
{%- elif target.type == 'sqlserver' -%}
    datediff_big({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
{%- endif -%}

{%- endmacro -%}
