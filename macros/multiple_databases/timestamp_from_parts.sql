{%- macro timestamp_from_parts(date_field, time_field) -%}

{%- if target.type == 'snowflake' -%}
    case
        when len({{ date_field }}) > 0 and len({{time_field}}) > 0
            then timestamp_from_parts({{ date_field }}, {{ time_field }})
        else
            timestamp_from_parts(null, null)
    end
{%- elif target.type == 'databricks' -%}
    case
        when len({{ date_field }}) > 0 and len({{time_field}}) > 0
            then make_timestamp(
                    date_part('YEAR', {{ date_field }}),
                    date_part('MONTH', {{ date_field }}),
                    date_part('DAY', {{ date_field }}),
                    date_part('HOUR', {{ time_field }}),
                    date_part('MINUTE', {{ time_field }}),
                    date_part('SECOND', {{ time_field }})
                )
        else
            make_timestamp(
                null,
                null,
                null,
                null,
                null,
                null
            )
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
{%- endif -%}

{%- endmacro -%}
