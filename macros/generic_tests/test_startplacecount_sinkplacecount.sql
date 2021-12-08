{% macro test_startplacecount_sinkplacecount(model, compare_model) %}

{{ config(fail_calc = 'coalesce(diff_startplacecount, diff_sinkplacecount, 0)') }}

select
    abs(startplacecount - casecount) as diff_startplacecount, abs(sinkplacecount - casecount) as diff_sinkplacecount
from (select count(*) as casecount from "{{ var('schema') }}"."{{ compare_model }}") as model_cases
cross join (select count(*) as startplacecount from {{ model }} where "From_activity" is null)  as model_startplace
cross join (select count(*) as sinkplacecount from {{ model }} where "To_activity" is null)  as model_sinkplace

{% endmacro %}
