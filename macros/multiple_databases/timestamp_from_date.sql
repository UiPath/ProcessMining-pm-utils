{%- macro timestamp_from_date(date_field) -%}

{%- if target.type == 'snowflake' -%}
    timestamp_from_parts({{ date_field }}, '0')
{%- elif target.type == 'sqlserver' -%}
    datetimefromparts(
        datepart(year, {{ date_field }}),
        datepart(month, {{ date_field }}),
        datepart(day, {{ date_field }}),
        0,
        0,
        0,
        0
    )
{%- endif -%}

{%- endmacro -%}
