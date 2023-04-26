{%- macro to_time(field, table) -%}

{%- if target.type == 'snowflake' -%}
    try_to_time(to_varchar({{ field }}), '{{ var("time_format", "hh24:mi:ss.ff3") }}')
{%- elif target.type == 'sqlserver' -%}
    try_convert(time, {{ field }}, {{ var("time_format", 14) }})
{%- endif -%}

{# Warning if type casting will introduce null values for at least 1 record. #}
{% if table is defined %}
    {% set query %}
    select
        count(*) as "record_count"
    from "{{ table.database }}"."{{ table.schema }}"."{{ table.identifier }}"
    where {{ field }} is not null and
        {% if target.type == 'snowflake' -%}
            try_to_time(to_varchar({{ field }}), '{{ var("time_format", "hh24:mi:ss.ff3") }}') is null
        {% elif target.type == 'sqlserver' -%}
            try_convert(time, {{ field }}, {{ var("time_format", 14) }}) is null
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
            {{ log(tojson({'Key': 'ConvertTime', 'Details': {'table_identifier': table.identifier, 'field': field, 'record_count': record_count|string}, 'Category': 'UserWarning', 'Message': 'Failed to convert \'' ~ table.identifier ~ '.' ~ field ~ '\' to a time for ' ~ record_count ~ ' records. Their values are set to NULL.'}), True) }}
        {% endif %}
    {% endif %}
{% endif %}

{%- endmacro -%}
