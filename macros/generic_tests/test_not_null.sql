{% macro test_not_null(model, column_name) %}

{% set exists_query %}
select count(*) as "record_count"
from Information_schema.Columns
where Information_schema.Columns."TABLE_SCHEMA" = '{{ model.schema }}'
    and Information_schema.Columns."TABLE_NAME" = '{{ model.name }}'
    and Information_schema.Columns."COLUMN_NAME" = replace('{{ column_name }}', '"', '')
{% endset %}

{% set result_exists_query = run_query(exists_query) %}

{# Execute the exists query. The result is 1 if the field exists and 0 if it does not exist. #}
{% if execute %}
{% set record_count = result_exists_query.columns['record_count'].values()[0] %}
{% else %}
{% set record_count = -1 %}
{% endif %}

{# Only execute test when field exists. Otherwise execute a dummy test that always returns 0 records. #}
{% if record_count > 0 %}
select {{ column_name }}
from {{ model }}
where {{ column_name }} is null
{% else %}
select 'dummy_value' as "dummy"
from {{ model }}
where 1 = 0
{% endif %}

{% endmacro %}
