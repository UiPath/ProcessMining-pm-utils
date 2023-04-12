{% macro test_exists(model, column_name) %}

{# Test fails if 0 records are returned. #}
{{ config(fail_calc = 'case when count(*) = 0 then 1 else 0 end') }}

{# Query the column in INFORMATION_SCHEMA to check if it exists. #}
select *
from "INFORMATION_SCHEMA"."COLUMNS"
where "INFORMATION_SCHEMA"."COLUMNS"."TABLE_SCHEMA" = '{{ model.schema }}'
    and "INFORMATION_SCHEMA"."COLUMNS"."TABLE_NAME" = '{{ model.name }}'
    and "INFORMATION_SCHEMA"."COLUMNS"."COLUMN_NAME" = replace('{{ column_name }}', '"', '')

{# Query to get the record count when executing the test. #}
{% set query %}
    select count(*) as "test_record_count"
    from "INFORMATION_SCHEMA"."COLUMNS"
    where "INFORMATION_SCHEMA"."COLUMNS"."TABLE_SCHEMA" = '{{ model.schema }}'
        and "INFORMATION_SCHEMA"."COLUMNS"."TABLE_NAME" = '{{ model.name }}'
        and "INFORMATION_SCHEMA"."COLUMNS"."COLUMN_NAME" = replace('{{ column_name }}', '"', '')
{% endset %}

{% set result = run_query(query) %}

{% if execute %}
    {% set test_record_count = result.columns['test_record_count'].values()[0] %}
{% else %}
    {% set test_record_count = 1 %}
{% endif %}

{# User-friendly log message when the test fails. #}
{% if test_record_count == 0 %}
    {% set json_object =
        {"Key": "TestExists", "Details": {"model_name": "" ~ model.name ~ "", "column_name": "" ~ column_name ~ ""}, "Category": "UserError", "Message": "The field '" ~ model.name ~ "." ~ column_name ~ "' doesn't exist in the source data. Note that the field detection is case-sensitive."}
    %}
    {% if var("log_result", False) == True %}
        {{ log(json_object, True) }}
    {% endif %}
{% endif %}

{% endmacro %}
