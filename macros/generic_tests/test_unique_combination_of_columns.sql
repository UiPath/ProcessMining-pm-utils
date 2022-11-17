{% macro test_unique_combination_of_columns(model, combination_of_columns, name) %}

{% set exists_query %}
select count(*) as "record_count"
from Information_schema.Columns
where Information_schema.Columns."TABLE_SCHEMA" = '{{ model.schema }}'
    and Information_schema.Columns."TABLE_NAME" = '{{ model.name }}'
    and Information_schema.Columns."COLUMN_NAME" in (
        {%- for column in combination_of_columns -%}
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
{% set record_count = combination_of_columns|length %}
{% endif %}

{# Only execute test when fields exists. Otherwise execute a dummy test that always succeeds. #}
{% if record_count == combination_of_columns|length %}
{% set column_list = [] %}
{% for column in combination_of_columns %}
    {% set column_list = column_list.append('"'+column+'"') %}
{% endfor %}

{% set columns_csv = column_list | join(', ') %}

select {{ columns_csv }}
from {{ model }}
group by {{ columns_csv }}
having count(*) > 1
{% else %}
select 'dummy_value' as "dummy"
from {{ model }}
where 1 = 0
{% endif %}

{% endmacro %}
