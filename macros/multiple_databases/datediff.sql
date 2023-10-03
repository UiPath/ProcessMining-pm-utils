{%- macro datediff(datepart, start_date_field, end_date_field) -%}

{%- if target.type == 'snowflake' -%}
    datediff({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
{%- elif target.type == 'sqlserver' -%}
    {%- if datepart == 'week' -%}
        {# To calculate week differences, weeks start by default on Sunday. Change to align with Snowflake (week starts on Monday) #}
        datediff_big({{ datepart }}, dateadd(day, -1, {{ start_date_field }}), dateadd(day, -1, {{ end_date_field }}))
    {%- else -%}
        datediff_big({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
