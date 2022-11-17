{% macro test_format(model, column_name, data_type) %}

{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

{% set exists_query %}
select count(*) as "record_count"
from Information_schema.Columns
where Information_schema.Columns."TABLE_SCHEMA" = '{{ model.schema }}'
    and Information_schema.Columns."TABLE_NAME" = '{{ model.name }}'
    and Information_schema.Columns."COLUMN_NAME" = replace('{{ column_name }}', '"', '')
{% endset %}

{# Execute the exists query. The record count is 1 if the field exists and 0 if it does not exist.#}
{% set result_exists_query = run_query(exists_query) %}

{# Get record count only when dbt is in execute mode to prevent compilation errors. #}
{% if execute %}
{% set record_count = result_exists_query.columns['record_count'].values()[0] %}
{% else %}
{% set record_count = 1 %}
{% endif %}

{# Only execute test when field exists. Otherwise execute a dummy test that always succeeds. #}
{% if record_count > 0 %}
select
    abs(count_before_casting - count_after_casting) as diff_count
from (
    select
        count(*) as count_before_casting 
    from {{ model }} 
    where {{ column_name }} is null) as model_before_casting
    cross join (
        select
            count(*) as count_after_casting 
        from {{ model }}
        {%- if data_type == 'date' -%}
        where {{ pm_utils.to_date(column_name) }} is null) as model_after_casting
        {%- elif data_type == 'time' -%}
        where {{ pm_utils.to_time(column_name) }} is null) as model_after_casting
        {%- elif data_type == 'datetime' -%}
        where {{ pm_utils.to_timestamp(column_name) }} is null) as model_after_casting
        {%- endif -%}
{% else %}
select 'dummy_value' as "dummy"
from {{ model }}
where 1 = 0
{% endif %}

{% endmacro %}
