{% macro test_type_double(model, column_name) %}

select *
from INFORMATION_SCHEMA.COLUMNS
where INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = '{{ model.schema }}'
    and lower(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME) = lower('{{ model.name }}')
    and INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = replace(replace('{{ column_name }}', '"', ''), '`', '')
    and lower(INFORMATION_SCHEMA.COLUMNS.DATA_TYPE) <> 'float'

{% endmacro %}
