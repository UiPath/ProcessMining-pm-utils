{% macro test_type_varchar(model, column_name) %}

select *
from Information_schema.Columns
where Information_schema.Columns."TABLE_SCHEMA" = '{{ model.schema }}'
    and Information_schema.Columns."TABLE_NAME" = '{{ model.name }}'
    and Information_schema.Columns."COLUMN_NAME" = replace('{{ column_name }}', '"', '')
{% if target.type == 'snowflake' %}
    and Information_schema.Columns."DATA_TYPE" <> 'TEXT'
{# Check also whether the length is not max, indicated by the value -1. #}
{% elif target.type == 'sqlserver' %}
    and (Information_schema.Columns."DATA_TYPE" <> 'nvarchar'
    or Information_schema.Columns."CHARACTER_MAXIMUM_LENGTH" = '-1')
{% endif %}

{% endmacro %}
