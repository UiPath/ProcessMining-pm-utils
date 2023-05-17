{%- macro to_boolean(field, relation) -%}

{# Snowflake try_to function requires an expression of type varchar. #}
{%- if target.type == 'snowflake' -%}
    {%- if field in ('true', 'false', '1', '0') -%}
        try_to_boolean('{{ field }}')
    {%- else -%}
        try_to_boolean(to_varchar({{ field }}))
    {%- endif -%}
{%- elif target.type == 'sqlserver' -%}
    {%- if field in ('true', 'false', '1', '0') -%}
        try_convert(bit, '{{ field }}')
    {%- else -%}
        case
            when len({{ field }}) > 0
                then try_convert(bit, {{ field }})
            else
                try_convert(bit, null)
        end
    {%- endif -%}
{%- endif -%}

{# Warning if type casting will introduce null values for at least 1 record. #}
{% if relation is defined %}
    {% set query %}
    select
        count(*) as "record_count"
    from "{{ relation.database }}"."{{ relation.schema }}"."{{ relation.identifier }}"
    where {{ field }} is not null and
        {% if target.type == 'snowflake' -%}
            {%- if field in ('true', 'false', '1', '0') -%}
                try_to_boolean('{{ field }}') is null
            {%- else -%}
                try_to_boolean(to_varchar({{ field }})) is null
            {%- endif -%}
        {% elif target.type == 'sqlserver' -%}
            {%- if field in ('true', 'false', '1', '0') -%}
                try_convert(bit, '{{ field }}') is null
            {%- else -%}
                case
                    when len({{ field }}) > 0
                        then try_convert(bit, {{ field }})
                    else
                        try_convert(bit, null)
                end is null
            {%- endif -%}
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
            {{ log(tojson({'Key': 'ConvertBoolean', 'Details': {'relation_identifier': relation.identifier, 'field': field, 'record_count': record_count|string}, 'Category': 'UserWarning', 'Message': 'Failed to convert \'' ~ relation.identifier ~ '.' ~ field ~ '\' to a boolean for ' ~ record_count ~ ' records. Their values are set to NULL.'}), True) }}
        {% endif %}
    {% endif %}
{% endif %}

{%- endmacro -%}
