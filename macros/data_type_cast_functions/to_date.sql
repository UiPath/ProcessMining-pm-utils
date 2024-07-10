{%- macro to_date(field, relation) -%}

{# Cast to date when the input is in a date or a datetime format. This is default behavior for SQL Server. #}
{# Snowflake try_to function requires an expression of type varchar. #}
{%- if target.type == 'snowflake' -%}
    case
        when try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}') is null
            then {{ pm_utils.date_from_timestamp(field) }}
        else try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}')
    end
{%- elif target.type == 'sqlserver' -%}
    case
        when len({{ field }}) > 0
            then try_convert(date, {{ field }}, {{ var("date_format", 23) }})
        else
            try_convert(date, null)
    end
{%- endif -%}

{# Warning if type casting will introduce null values for at least 1 record. #}
{% if relation is defined %}
    {% set query %}
    select
        count(*) as "record_count"
    from "{{ relation.database }}"."{{ relation.schema }}"."{{ relation.identifier }}"
    where {{ field }} is not null and
        {% if target.type == 'snowflake' -%}
            case
                when try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}') is null
                    then {{ pm_utils.date_from_timestamp(field) }}
                else try_to_date(to_varchar({{ field }}), '{{ var("date_format", "YYYY-MM-DD") }}')
            end is null
        {% elif target.type == 'sqlserver' -%}
            case
                when len({{ field }}) > 0
                    then try_convert(date, {{ field }}, {{ var("date_format", 23) }})
                else
                    try_convert(date, null)
            end is null
        {%- endif -%}
    {% endset %}

    {% set result_query = run_query(query) %}
    {% if execute %}
        {% set record_count = result_query.columns['record_count'].values()[0] %}
    {% else %}
        {% set record_count = 0 %}
    {% endif %}

    {% if record_count > 0 %}
        {% if var("log_result", False) == True %}
            {{ log(tojson({'Key': 'ConvertDate', 'Details': {'relation_identifier': relation.identifier, 'field': field, 'record_count': record_count|string}, 'Category': 'UserWarning', 'Message': 'Failed to convert \'' ~ relation.identifier ~ '.' ~ field ~ '\' to a date for ' ~ record_count ~ ' records. Their values are set to NULL.'}), True) }}
        {% endif %}
    {% endif %}
{% endif %}

{%- endmacro -%}
