{%- macro dateadd(datepart, number, date_or_datetime_field) -%}
{%- if target.type == 'snowflake' -%}
    dateadd({{ datepart }}, {{ number }}, try_to_timestamp(to_varchar({{ date_or_datetime_field }})))
{%- elif target.type == 'sqlserver' -%}
    dateadd({{ datepart }}, {{ number }}, try_convert(datetime2, {{ date_or_datetime_field }}))
{%- elif target.type == 'databricks' -%}
    {%- set datetime_field -%}
        try_to_timestamp({{ date_or_datetime_field }})
    {%- endset -%}
    {%- set time_field -%}
        unix_millis({{ datetime_field }}) - unix_millis(date_trunc('DD', {{ datetime_field }}))
    {%- endset -%}
    {%- if datepart == 'millisecond' -%}
        timestamp_millis(unix_millis({{ datetime_field }}) + {{ number }})
    {%- elif datepart == 'second' -%}
        timestamp_millis(unix_millis({{ datetime_field }}) + {{ number }}*1000)
    {%- elif datepart == 'minute' -%}
        timestamp_millis(unix_millis({{ datetime_field }}) + {{ number }}*60000)
    {%- elif datepart == 'hour' -%}
        timestamp_millis(unix_millis({{ datetime_field }}) + {{ number }}*3600000)
    {%- elif datepart == 'day' -%}
        timestamp_millis(unix_millis(try_to_timestamp(date_add(to_date({{ datetime_field }}), {{ number }}))) + {{ time_field }})
    {%- elif datepart == 'week' -%}
        timestamp_millis(unix_millis(try_to_timestamp(date_add(to_date({{ datetime_field }}), {{ number }}*7))) + {{ time_field }})
    {%- elif datepart == 'month' -%}
        timestamp_millis(unix_millis(try_to_timestamp(add_months(to_date({{ datetime_field }}), {{ number }}))) + {{ time_field }})
    {%- elif datepart == 'quarter' -%}
        timestamp_millis(unix_millis(try_to_timestamp(add_months(to_date({{ datetime_field }}), {{ number }}*3))) + {{ time_field }})
    {%- elif datepart == 'year' -%}
        timestamp_millis(unix_millis(try_to_timestamp(add_months(to_date({{ datetime_field }}), {{ number }}*12))) + {{ time_field }})
    {%- endif -%}
{%- endif -%}
{%- endmacro -%}
