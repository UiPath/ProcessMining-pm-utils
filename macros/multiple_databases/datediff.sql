{%- macro datediff(datepart, start_date_field, end_date_field) -%}

{%- if target.type == 'snowflake' -%}
    datediff({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
{%- elif target.type == 'sqlserver' -%}
    {%- if datepart == 'week' -%}
        {# To calculate week differences, weeks start by default on Sunday. Change to align with Snowflake (week starts on Monday) #}
        datediff_big({{ datepart }}, dateadd(day, -1, {{ start_date_field }}), dateadd(day, -1, {{ end_date_field }}))
    {%- else -%}
        datediff_big({{ datepart }}, {{ start_date_field }}, {{ end_date_field }})
    {%- endif -%}
{%- elif target.type == 'databricks' -%}
    {%- if datepart == 'millisecond' -%}
        unix_millis(to_timestamp({{ end_date_field }})) - unix_millis(to_timestamp({{ start_date_field }}))
    {%- elif datepart == 'second' -%}
        unix_seconds(to_timestamp({{ end_date_field }})) - unix_seconds(to_timestamp({{ start_date_field }}))
    {%- elif datepart == 'minute' -%}
        bigint((unix_seconds(to_timestamp({{ end_date_field }})) - unix_seconds(to_timestamp({{ start_date_field }})))/60)
    {%- elif datepart == 'hour' -%}
        bigint((unix_seconds(to_timestamp({{ end_date_field }})) - unix_seconds(to_timestamp({{ start_date_field }})))/3600)
    {%- elif datepart == 'day' -%}
        bigint(datediff({{ end_date_field }}, {{ start_date_field }}))
    {%- elif datepart == 'year' -%}
        bigint(year({{ end_date_field }}) - year({{ start_date_field }}))
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
