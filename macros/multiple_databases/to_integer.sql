{%- macro to_integer(field, table) -%}

{%- if target.type == 'snowflake' -%}
    try_to_number(to_varchar({{ field }}))
{%- elif target.type == 'sqlserver' -%}
    try_convert(bigint, {{ field }})
{%- endif -%}

{# Warning if type casting will introduce null values for at least 1 record. #}
{% if table is defined %}
    {% set query %}
    select
        count(*) as "record_count"
    from "{{ table.database }}"."{{ table.schema }}"."{{ table.identifier }}"
    where {{ field }} is not null and
        {% if target.type == 'snowflake' -%}
            try_to_number(to_varchar({{ field }})) is null
        {% elif target.type == 'sqlserver' -%}
            try_convert(bigint, {{ field }}) is null
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
