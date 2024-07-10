{%- macro timestamp_from_parts(date_field, time_field) -%}

{%- if target.type == 'snowflake' -%}
    case
        when len({{ date_field }}) > 0 and len({{ time_field }}) > 0
            then timestamp_from_parts({{ date_field }}, try_to_time({{ time_field }}, '{{ var("time_format", "hh24:mi:ss.ff3") }}'))
        else
            timestamp_from_parts(null, null)
    end
{%- elif target.type == 'sqlserver' -%}
    case
        when len({{ date_field }}) > 0 and len({{time_field}}) > 0
            then datetime2fromparts(
                    datepart(year, {{ date_field }}),
                    datepart(month, {{ date_field }}),
                    datepart(day, {{ date_field }}),
                    datepart(hour, try_convert(time, {{ time_field }}, {{ var("time_format", 14) }})),
                    datepart(minute, try_convert(time, {{ time_field }}, {{ var("time_format", 14) }})),
                    datepart(second, try_convert(time, {{ time_field }}, {{ var("time_format", 14) }})),
                    datepart(millisecond, try_convert(time, {{ time_field }}, {{ var("time_format", 14) }})),
                    3
                )
        else
            datetime2fromparts(
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                3
            )
    end
{%- endif -%}

{%- endmacro -%}
