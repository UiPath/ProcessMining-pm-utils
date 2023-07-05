{% macro test_type_integer(model, column_name) %}

select *
from INFORMATION_SCHEMA.COLUMNS
where INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA = '{{ model.schema }}'
    and INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = '{{ model.name }}'
    and INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = '{{ column_name }}'
{% if target.type == 'snowflake' %}
    and INFORMATION_SCHEMA.COLUMNS.DATA_TYPE <> 'NUMBER'
{% elif target.type == 'sqlserver' %}
    and INFORMATION_SCHEMA.COLUMNS.DATA_TYPE not in ('int', 'bigint')
{% endif %}

{% endmacro %}
