{%- macro to_double(field, table) -%}

{%- if target.type == 'snowflake' -%}
    try_to_double(to_varchar({{ field }}))
{%- elif target.type == 'sqlserver' -%}
    try_convert(float, {{ field }})
{%- endif -%}

{# Warning if type casting will introduce null values for at least 1 record. #}
{% if table is defined %}
    {% set query %}
    select
        count(*) as "record_count"
    from "{{ table.database }}"."{{ table.schema }}"."{{ table.identifier }}"
    where {{ field }} is not null and
        {% if target.type == 'snowflake' -%}
            try_to_double(to_varchar({{ field }})) is null
        {% elif target.type == 'sqlserver' -%}
            try_convert(float, {{ field }}) is null
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
            {{ log(tojson({'Key': 'ConvertDouble', 'Details': {'table_identifier': table.identifier, 'field': field, 'record_count': record_count|string}, 'Category': 'UserWarning', 'Message': 'Failed to convert \'' ~ table.identifier ~ '.' ~ field ~ '\' to a double for ' ~ record_count ~ ' records. Their values are set to NULL.'}), True) }}
        {% endif %}
    {% endif %}
{% endif %}

{%- endmacro -%}
