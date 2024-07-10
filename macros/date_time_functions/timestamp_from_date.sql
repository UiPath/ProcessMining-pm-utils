{%- macro timestamp_from_date(date_field) -%}

{%- if target.type == 'snowflake' -%}
    case
        when len({{ date_field }}) > 0
            then timestamp_from_parts({{ date_field }}, '0')
        else
            timestamp_from_parts(null, null)
    end
{%- elif target.type == 'sqlserver' -%}
    case
        when len({{ date_field }}) > 0
            then datetime2fromparts(
                    datepart(year, {{ date_field }}),
                    datepart(month, {{ date_field }}),
                    datepart(day, {{ date_field }}),
                    0,
                    0,
                    0,
                    0,
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
