{% macro test_type_varchar(model, column_name) %}

select *
from "INFORMATION_SCHEMA"."COLUMNS"
where "INFORMATION_SCHEMA"."COLUMNS"."TABLE_SCHEMA" = '{{ model.schema }}'
    and "INFORMATION_SCHEMA"."COLUMNS"."TABLE_NAME" = '{{ model.name }}'
    and "INFORMATION_SCHEMA"."COLUMNS"."COLUMN_NAME" = replace('{{ column_name }}', '"', '')
{% if target.type == 'snowflake' %}
    and "INFORMATION_SCHEMA"."COLUMNS"."DATA_TYPE" <> 'TEXT'
{# Check also whether the length is not max, indicated by the value -1. #}
{% elif target.type == 'sqlserver' %}
    and ("INFORMATION_SCHEMA"."COLUMNS"."DATA_TYPE" <> 'nvarchar'
    or "INFORMATION_SCHEMA"."COLUMNS"."CHARACTER_MAXIMUM_LENGTH" = '-1')
{% endif %}

{% endmacro %}
