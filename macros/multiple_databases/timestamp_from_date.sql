{%- macro timestamp_from_date(date_field) -%}

{%- if target.type == 'snowflake' -%}
    case
        when len({{ date_field }}) > 0
            then timestamp_from_parts({{ date_field }}, '0')
        else
            timestamp_from_parts(NULL, NULL)
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
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                3
            )
    end
{%- endif -%}

{%- endmacro -%}
