{%- macro dateadd(datepart, number, date_or_datetime_field) -%}
{%- if target.type == 'snowflake' -%}
    dateadd({{ datepart }}, {{ number }}, try_to_timestamp(to_varchar({{ date_or_datetime_field }})))
{%- elif target.type == 'sqlserver' -%}
    dateadd({{ datepart }}, {{ number }}, try_convert(datetime2, {{ date_or_datetime_field }}))
{%- elif target.type == 'databricks' -%}
    {# Cast number to bigint to prevent overflow values when doing computations. #}
    {%- set number_bigint -%}
        try_cast({{ number }} as bigint)
    {%- endset -%}
    {# Convert the base timestamp and the units to be added both to milliseconds to do the addition.
    Convert the total milliseconds back to a timestamp using timestamp_millis. #}
    {%- set base_timestamp_in_ms -%}
        unix_millis(try_to_timestamp({{ date_or_datetime_field }}))
    {%- endset -%}
    {%- if datepart == 'millisecond' -%}
        timestamp_millis({{ base_timestamp_in_ms }} + {{ number_bigint }})
    {%- elif datepart == 'second' -%}
        timestamp_millis({{ base_timestamp_in_ms }} + {{ number_bigint }} * 1000)
    {%- elif datepart == 'minute' -%}
        timestamp_millis({{ base_timestamp_in_ms }} + {{ number_bigint }} * 1000 * 60)
    {%- elif datepart == 'hour' -%}
        timestamp_millis({{ base_timestamp_in_ms }} + {{ number_bigint }} * 1000 * 60 * 60)
    {%- elif datepart == 'day' -%}
        timestamp_millis({{ base_timestamp_in_ms }} + {{ number_bigint }} * 1000 * 60 * 60 * 24)
    {%- elif datepart == 'week' -%}
        timestamp_millis({{ base_timestamp_in_ms }} + {{ number_bigint }} * 1000 * 60 * 60 * 24 * 7)
    {%- endif -%}
    {# Since the number of days in a month can differ, use the add_months function for month, quarter and year.
    The add_months function needs a date as input. Compute the milliseconds of the date and time part separately and add them together. #}
    {%- set time_part_in_ms -%}
        {{ base_timestamp_in_ms }} - unix_millis(date_trunc('DD', try_to_timestamp({{ date_or_datetime_field }})))
    {%- endset -%}
    {%- if datepart == 'month' -%}
        timestamp_millis(unix_millis(try_to_timestamp(add_months(to_date({{ date_or_datetime_field }}), {{ number_bigint }}))) + {{ time_part_in_ms }})
    {%- elif datepart == 'quarter' -%}
        timestamp_millis(unix_millis(try_to_timestamp(add_months(to_date({{ date_or_datetime_field }}), {{ number_bigint }} * 3))) + {{ time_part_in_ms }})
    {%- elif datepart == 'year' -%}
        timestamp_millis(unix_millis(try_to_timestamp(add_months(to_date({{ date_or_datetime_field }}), {{ number_bigint }} * 12))) + {{ time_part_in_ms }})
    {%- endif -%}
{%- endif -%}
{%- endmacro -%}
