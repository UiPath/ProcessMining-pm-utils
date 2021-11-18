{% macro timestamp_from_date(date_attribute) %}

{% if var("database") == 'snowflake' %}
    timestamp_from_parts({{ date_attribute }}, '0')
{% elif var("database") == 'sqlserver' %}
    datetimefromparts(
        datepart(year, {{ date_attribute }}),
        datepart(month, {{ date_attribute }}),
        datepart(day, {{ date_attribute }}),
        0,
        0,
        0,
        0
    )
{% endif %}

{% endmacro %}
