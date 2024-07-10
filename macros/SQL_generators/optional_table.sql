{%- macro optional_table(source_table) -%}

{%- set source_relation = adapter.get_relation(
    database=source_table.database,
    schema=source_table.schema,
    identifier=source_table.name) -%}

{# When source table does not exist, create an empty table in the target schema that will be queried instead. #}
{%- if source_relation is not none -%}
    {{ source_table }}
{%- else -%}
    {% set query %}
        {% if target.type == 'snowflake' %}
            create or replace table "{{ target.database }}"."{{ target.schema }}"."{{ source_table.name }}" (dummy int)
        {% elif target.type == 'sqlserver' %}
            if object_id('"{{ target.database }}"."{{ target.schema }}"."{{ source_table.name }}"', 'U') is null
            create table "{{ target.database }}"."{{ target.schema }}"."{{ source_table.name }}" (dummy int)
        {% endif %}
    {% endset %}

    {% do run_query(query) %}
        "{{ target.database }}"."{{ target.schema }}"."{{ source_table.name }}"
{%- endif -%}

{%- endmacro -%}
