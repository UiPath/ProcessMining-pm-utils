{%- macro to_date(field, table) -%}

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

{# Warning if type casting will introduce null values for at least 1 record. #}
{% if table is defined %}
    {% set query %}
    select
        count(*) as "record_count"
    from "{{ table.database }}"."{{ table.schema }}"."{{ table.identifier }}"
    where {{ field }} is not null and
        {% if target.type == 'snowflake' -%}
            case
                when try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}') is null
                    then {{ pm_utils.date_from_timestamp(field) }}
                else try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}')
            end is null
        {% elif target.type == 'sqlserver' -%}
            try_convert(date, {{ field }}, {{ var("date_format", 23) }}) is null
        {%- endif -%}
    {% endset %}

    {% set result_query = run_query(query) %}
    {% if execute %}
        {% set record_count = result_query.columns['record_count'].values()[0] %}
    {% else %}
        {% set record_count = 0 %}
    {% endif %}

    {% if record_count > 0 %}
        {{ log("Warning", True) }}
    {% endif %}
{% endif %}

{%- endmacro -%}
