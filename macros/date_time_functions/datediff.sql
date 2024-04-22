{%- macro datediff(datepart, start_date_field, end_date_field) -%}

{%- if target.type == 'snowflake' -%}
    {# Snowflake week is defined from Monday to Sunday. Add one day to align computation for week differences. #}
    {%- if datepart == 'week' -%}
        datediff({{ datepart }}, dateadd(day, 1, {{ start_date_field }}), dateadd(day, 1, {{ end_date_field }}))
    {%- else -%}
        datediff({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
    {%- endif -%}
{%- elif target.type == 'sqlserver' -%}
    datediff_big({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
{%- elif target.type == 'databricks' -%}
    {%- if datepart == 'millisecond' -%}
        unix_millis(to_timestamp({{ end_date_field }})) - unix_millis(to_timestamp({{ start_date_field }}))
    {%- elif datepart == 'second' -%}
        unix_seconds(to_timestamp({{ end_date_field }})) - unix_seconds(to_timestamp({{ start_date_field }}))
    {%- elif datepart == 'minute' -%}
        bigint((unix_seconds(to_timestamp({{ end_date_field }})) - unix_seconds(to_timestamp({{ start_date_field }}))) / 60)
    {%- elif datepart == 'hour' -%}
        bigint((unix_seconds(to_timestamp({{ end_date_field }})) - unix_seconds(to_timestamp({{ start_date_field }}))) / 3600)
    {%- elif datepart == 'day' -%}
        bigint(datediff({{ end_date_field }}, {{ start_date_field }}))
    {%- elif datepart == 'week' -%}
        case
            when dayofweek({{ end_date_field }}) < dayofweek({{ start_date_field }})
                then bigint(datediff({{ end_date_field }}, {{ start_date_field }}) / 7) + 1
            else bigint(datediff({{ end_date_field }}, {{ start_date_field }}) / 7)
        end
    {%- elif datepart == 'month' -%}
        bigint(months_between(to_timestamp({{ end_date_field }}), to_timestamp({{ start_date_field }})))
    {%- elif datepart == 'quarter' -%}
        bigint(quarter({{ end_date_field }}) - quarter({{ start_date_field }}) + 4 * (year({{ end_date_field }}) - year({{ start_date_field }})))
    {%- elif datepart == 'year' -%}
        bigint(year({{ end_date_field }}) - year({{ start_date_field }}))
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
