{% macro test_type_boolean(model, column_name) %}

select *
from INFORMATION_SCHEMA.COLUMNS
where INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = '{{ model.schema }}'
    and INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = '{{ model.name }}'
    and INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = '{{ column_name }}'
{% if target.type == 'snowflake' %}
    and INFORMATION_SCHEMA.COLUMNS.DATA_TYPE <> 'BOOLEAN'
{% elif target.type == 'sqlserver' %}
    and INFORMATION_SCHEMA.COLUMNS.DATA_TYPE <> 'bit'
{% endif %}

{% endmacro %}
