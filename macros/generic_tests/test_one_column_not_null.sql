{% macro test_one_column_not_null(model, columns, name) %}

{% set exists_query %}
select count(*) as "record_count"
from Information_schema.Columns
where Information_schema.Columns."TABLE_SCHEMA" = '{{ model.schema }}'
    and Information_schema.Columns."TABLE_NAME" = '{{ model.name }}'
    and Information_schema.Columns."COLUMN_NAME" in (
        {%- for column in columns -%}
        '{{ column }}' {{',' if not loop.last }}
        {%- endfor -%}
    )
{% endset %}

{# Execute the exists query. The record count is the same as number of columns if all fields exist. #}
{% set result_exists_query = run_query(exists_query) %}

{# Get record count only when dbt is in execute mode to prevent compilation errors. #}
{% if execute %}
{% set record_count = result_exists_query.columns['record_count'].values()[0] %}
{% else %}
{% set record_count = columns|length %}
{% endif %}

{# Only execute test when fields exists. Otherwise execute a dummy test that always succeeds. #}
{% if record_count == columns|length %}
{% set column_list = [] %}
{% for column in columns %}
    {% set column_list = column_list.append('case when "' + column + '" is not NULL then 1 else 0 end') %}
{% endfor %}

{% set calculation = column_list | join('\n    + ') %}

select *
from {{ model }}
where {{ calculation }} <> 1
{% else %}
select 'dummy_value' as "dummy"
from {{ model }}
where 1 = 0
{% endif %}

{% endmacro %}
