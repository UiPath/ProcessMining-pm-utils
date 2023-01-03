{% macro test_format(model, column_name, data_type, name) %}

{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

{%- set columns = adapter.get_columns_in_relation(model) -%}

{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append('"' + column.name + '"') -%}
{%- endfor -%}

{# Only execute test when field exists. Otherwise execute a dummy test that always succeeds. #}
{% if column_name in column_names %}
    select
        abs(count_before_casting - count_after_casting) as diff_count
    from (
        select
            count(*) as count_before_casting 
        from {{ model }} 
        where {{ column_name }} is null) as model_before_casting
        cross join (
            select
                count(*) as count_after_casting 
            from {{ model }}
            {%- if data_type == 'date' -%}
            where {{ pm_utils.to_date(column_name) }} is null) as model_after_casting
            {%- elif data_type == 'time' -%}
            where {{ pm_utils.to_time(column_name) }} is null) as model_after_casting
            {%- elif data_type == 'datetime' -%}
            where {{ pm_utils.to_timestamp(column_name) }} is null) as model_after_casting
            {%- endif -%}
{% else %}
    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0
{% endif %}

{% endmacro %}
