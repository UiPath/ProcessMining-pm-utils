{% macro test_exists(model, column_name, name) %}

{# Test fails if 0 records are returned. #}
{{ config(fail_calc = 'case when count(*) = 0 then 1 else 0 end') }}

select *
from "INFORMATION_SCHEMA"."COLUMNS"
where "INFORMATION_SCHEMA"."COLUMNS"."TABLE_SCHEMA" = '{{ model.schema }}'
    and "INFORMATION_SCHEMA"."COLUMNS"."TABLE_NAME" = '{{ model.name }}'
    and "INFORMATION_SCHEMA"."COLUMNS"."COLUMN_NAME" = replace('{{ column_name }}', '"', '')

{% endmacro %}
