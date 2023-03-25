{% macro test_equal_rowcount(model, compare_model) %}

{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

select
    abs(count_a - count_b) as diff_count
from (select count(*) as count_a from {{ model }}) as model_a
cross join (select count(*) as count_b from "{{ model.schema }}"."{{ compare_model }}") as model_b

{% endmacro %}
