{%- macro timestamp_from_parts(date_field, time_field) -%}

{%- if target.type == 'snowflake' -%}
    timestamp_from_parts({{ date_field }}, {{ time_field }})
{%- elif target.type == 'sqlserver' -%}
    datetime2fromparts(
        datepart(year, {{ date_field }}),
        datepart(month, {{ date_field }}),
        datepart(day, {{ date_field }}),
        datepart(hour, {{ time_field }}),
        datepart(minute, {{ time_field }}),
        datepart(second, {{ time_field }}),
        datepart(millisecond, {{ time_field }}),
        3
    )
{%- endif -%}

{%- endmacro -%}
