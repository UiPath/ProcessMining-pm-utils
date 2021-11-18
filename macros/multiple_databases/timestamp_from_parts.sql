{% macro timestamp_from_parts(date_attribute, time_attribute) %}

{% if var("database") == 'snowflake' %}
    timestamp_from_parts({{ date_attribute }}, {{ time_attribute }})
{% elif var("database") == 'sqlserver' %}
    datetimefromparts(
        datepart(year, {{ date_attribute }}),
        datepart(month, {{ date_attribute }}),
        datepart(day, {{ date_attribute }}),
        datepart(hour, {{ time_attribute }}),
        datepart(minute, {{ time_attribute }}),
        datepart(second, {{ time_attribute }}),
        datepart(millisecond, {{ time_attribute }})
    )
{% endif %}

{% endmacro %}
