{% macro test_edge_count(model, event_log, case_ID) %}

{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

{# Number of edges is equal to the number of events plus number of cases, since source and sink edges are included. #}
select
    abs(count_edges - count_events - count_cases) as diff_count
from (select count(*) as count_edges from {{ model }}) as model_edges
cross join (select count(*) as count_events from "{{ model.schema }}"."{{ event_log }}") as model_events
{# Compute number of cases by grouping the event log on case ID. #}
cross join (select count(*) as count_cases from (select "{{ case_ID }}" from "{{ model.schema }}"."{{ event_log }}" group by "{{ case_ID }}") as grouped_event_log) as model_cases

{% endmacro %}
