{%- macro to_timestamp(field, relation) -%}

{# Snowflake try_to function requires an expression of type varchar. #}
{%- if target.type == 'snowflake' -%}
    try_to_timestamp(to_varchar({{ field }}), '{{ var("datetime_format", "YYYY-MM-DD hh24:mi:ss.ff3") }}')
{%- elif target.type == 'databricks' -%}
    to_timestamp({{ field }})
{%- elif target.type == 'sqlserver' -%}
    case
        when len({{ field }}) > 0
            then try_convert(datetime2, {{ field }}, {{ var("datetime_format", 21) }})
        else
            try_convert(datetime2, null)
    end
{%- endif -%}

{# Warning if type casting will introduce null values for at least 1 record. #}
{% if False and relation is defined %}
    {% set query %}
    select
        count(*) as record_count
        {% if target.type == 'snowflake' %}
            from "{{ relation.database }}"."{{ relation.schema }}"."{{ relation.identifier }}"
        {% else  %}
            from {{ relation.database }}.{{ relation.schema }}.{{ relation.identifier }}
        {% endif %}
        where {{ field }} is not null and

        {% if target.type == 'snowflake' -%}
            try_to_timestamp(to_varchar({{ field }}), '{{ var("datetime_format", "YYYY-MM-DD hh24:mi:ss.ff3") }}') is null
        {%- elif target.type == 'databricks' -%}
            to_timestamp({{ field }}) is null
        {% elif target.type == 'sqlserver' -%}
            case
                when len({{ field }}) > 0
                    then try_convert(datetime2, {{ field }}, {{ var("datetime_format", 21) }})
                else
                    try_convert(datetime2, null)
            end is null
        {%- endif -%}
    {% endset %}
    
    {% set result_query = run_query(query) %}
    {% if execute %}
        {% set record_count = result_query.columns[0].values()[0] %}
    {% else %}
        {% set record_count = 0 %}
    {% endif %}

    {% if record_count > 0 %}
        {% if var("log_result", True) == True %}
            {{ log(tojson({'Key': 'ConvertDatetime', 'Details': {'relation_identifier': relation.identifier, 'field': field, 'record_count': record_count|string}, 'Category': 'UserWarning', 'Message': 'Failed to convert \'' ~ relation.identifier ~ '.' ~ field ~ '\' to a datetime for ' ~ record_count ~ ' records. Their values are set to NULL.'}), True) }}
        {% endif %}
    {% endif %}
{% endif %}

{%- endmacro -%}
