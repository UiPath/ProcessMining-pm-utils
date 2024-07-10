{%- macro dateadd(datepart, number, date_or_datetime_field) -%}
{%- if target.type == 'snowflake' -%}
    dateadd({{ datepart }}, {{ number }}, try_to_timestamp(to_varchar({{ date_or_datetime_field }})))
{%- elif target.type == 'sqlserver' -%}
    dateadd({{ datepart }}, {{ number }}, try_convert(datetime2, {{ date_or_datetime_field }}))
{%- endif -%}
{%- endmacro -%}
