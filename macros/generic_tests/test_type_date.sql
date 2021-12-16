{% macro test_type_date(model, column_name) %}

select *
from Information_schema.Columns
where Information_schema.Columns."TABLE_SCHEMA" = '{{ model.schema }}'
    and Information_schema.Columns."TABLE_NAME" = '{{ model.name }}'
    and Information_schema.Columns."COLUMN_NAME" = '{{ column_name }}'
    and lower(Information_schema.Columns."DATA_TYPE") <> 'date'

{% endmacro %}
