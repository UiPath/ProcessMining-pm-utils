{% macro test_edgecount(model, case_model, event_model) %}

{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

select
    abs(edgecount - casecount - eventcount) as diff_count
from (select count(*) as edgecount from {{ model }}) as model_edges
cross join (select count(*) as casecount from "{{ var('DBT_SCHEMA') }}"."{{ case_model }}")  as model_cases
cross join (select count(*) as eventcount from "{{ var('DBT_SCHEMA') }}"."{{ event_model }}")  as model_events

{% endmacro %}
