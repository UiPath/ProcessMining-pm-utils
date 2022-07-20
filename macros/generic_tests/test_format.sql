{% macro test_format(model, column_name, data_type) %}

{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

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

{% endmacro %}
