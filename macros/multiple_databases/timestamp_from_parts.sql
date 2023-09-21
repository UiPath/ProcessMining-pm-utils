{%- macro timestamp_from_parts(date_field, time_field) -%}

{%- if target.type == 'snowflake' -%}
    case
        when len({{ date_field }}) > 0 and len({{time_field}}) > 0
            then timestamp_from_parts({{ date_field }}, {{ time_field }})
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
                    datepart(hour, {{ time_field }}),
                    datepart(minute, {{ time_field }}),
                    datepart(second, {{ time_field }}),
                    datepart(millisecond, {{ time_field }}),
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
{%- elif target.type == 'databricks' -%}
    case
        when length({{ date_field }}) > 0 and length({{time_field}}) > 0
            then timestamp_millis(bigint(bigint(unix_date({{ date_field }})) * 86400000) + unix_millis({{ time_field }}))
        else
            to_timestamp(null)
    end
{%- endif -%}

{%- endmacro -%}
