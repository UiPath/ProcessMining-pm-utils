{% macro test_type_timestamp(model, column_name) %}

select *
from Information_schema.Columns
where Information_schema.Columns."TABLE_SCHEMA" = '{{ model.schema }}'
    and Information_schema.Columns."TABLE_NAME" = '{{ model.name }}'
    and Information_schema.Columns."COLUMN_NAME" = '{{ column_name }}'
{% if target.type == 'snowflake' %}
    and Information_schema.Columns."DATA_TYPE" <> 'TIMESTAMP_NTZ'
{% elif target.type == 'sqlserver' %}
    and Information_schema.Columns."DATA_TYPE" <> 'datetime'
{% endif %}

{% endmacro %}
