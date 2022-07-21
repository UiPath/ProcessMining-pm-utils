{%- macro to_date(field) -%}

{# Cast to date when the input is in a date or a datetime format. This is default behavior for SQL Server. #}
{%- if target.type == 'snowflake' -%}
    case
        when try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}') is null
            then {{ pm_utils.date_from_timestamp(field) }}
        else try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}')
    end
{%- elif target.type == 'sqlserver' -%}
    try_convert(date, {{ field }}, {{ var("date_format", 23) }})
{%- endif -%}

{%- endmacro -%}
