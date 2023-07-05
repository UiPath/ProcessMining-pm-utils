{% macro test_type_date(model, column_name) %}

select *
from INFORMATION_SCHEMA.COLUMNS
where INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = '{{ model.schema }}'
    and INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = '{{ model.name }}'
    and INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = '{{ column_name }}'
    and lower(INFORMATION_SCHEMA.COLUMNS.DATA_TYPE) <> 'date'

{% endmacro %}
