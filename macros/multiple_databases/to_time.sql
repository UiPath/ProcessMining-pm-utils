{%- macro to_time(field, relation) -%}

{# Snowflake try_to function requires an expression of type varchar. #}
{%- if target.type == 'snowflake' -%}
    try_to_time(to_varchar('{{ "\"" ~ field.split(".")|join("\".\"") ~ "\""}}'), '{{ var("time_format", "hh24:mi:ss.ff3") }}')
{%- elif target.type == 'databricks' -%}
    {{ field }}
{%- elif target.type == 'sqlserver' -%}
    case
        when len({{ field }}) > 0
            then try_convert(time, {{ field }}, {{ var("time_format", 14) }})
        else
            try_convert(time, null)
    end
{%- endif -%}

{# Warning if type casting will introduce null values for at least 1 record. #}
{% if relation is defined %}
    {% set query %}
    select
        count(*) as record_count
    from {{ relation.database }}.{{ relation.schema }}.{{ relation.identifier }}
    where {{ field }} is not null and
        {% if target.type == 'snowflake' -%}
            try_to_time(to_varchar({{ field }}), '{{ var("time_format", "hh24:mi:ss.ff3") }}') is null
        {%- elif target.type == 'databricks' -%}
            {{ field }} is null
        {% elif target.type == 'sqlserver' -%}
            case
                when len({{ field }}) > 0
                    then try_convert(time, {{ field }}, {{ var("time_format", 14) }})
                else
                    try_convert(time, null)
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
            {{ log(tojson({'Key': 'ConvertTime', 'Details': {'relation_identifier': relation.identifier, 'field': field, 'record_count': record_count|string}, 'Category': 'UserWarning', 'Message': 'Failed to convert \'' ~ relation.identifier ~ '.' ~ field ~ '\' to a time for ' ~ record_count ~ ' records. Their values are set to NULL.'}), True) }}
        {% endif %}
    {% endif %}
{% endif %}

{%- endmacro -%}
