{%- macro timestamp_from_parts(date_attribute, time_attribute) -%}

{%- if target.type == 'snowflake' -%}
    timestamp_from_parts({{ date_attribute }}, {{ time_attribute }})
{%- elif target.type == 'sqlserver' -%}
    datetimefromparts(
        datepart(year, {{ date_attribute }}),
        datepart(month, {{ date_attribute }}),
        datepart(day, {{ date_attribute }}),
        datepart(hour, {{ time_attribute }}),
        datepart(minute, {{ time_attribute }}),
        datepart(second, {{ time_attribute }}),
        datepart(millisecond, {{ time_attribute }})
    )
{%- endif -%}

{%- endmacro -%}
