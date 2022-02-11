{%- macro generate_edge_table(table_name, event_log_model, case_ID, activity, event_order, properties) -%}

Event_log as (
    select * from {{ event_log_model }}
),

Last_events_of_cases as (
    select
        max(Event_log."{{ event_order }}") as "Event_order_last_event"
    from Event_log
    group by Event_log."{{ case_ID }}"
),

/* The Edges table contains all edges indicated by the Case ID, the From activity and To activity.
The edge table also includes edges from the source node and to the sink node. The source and sink nodes are indicated by Activity = NULL.
Optionally, additional properties of the event log can be added to the edge table to optimize metrics. */
Edges_preprocessing as (
    select
        Event_log."{{ case_ID }}",
        lag(Event_log."{{ activity }}") over (
            partition by Event_log."{{ case_ID }}"
            order by Event_log."{{ event_order }}") as "From_activity",
        Event_log."{{ activity }}" as "To_activity"
        {% for property in properties -%}
            , Event_log."{{ property }}"
        {% endfor -%}
    from Event_log
    union all
    -- To generate the edges to the sink node, records are appended with the activtiy of the last event as From activity and NULL as To activity.
    select
        Event_log."{{ case_ID }}",
        Event_log."{{ activity }}" as "From_activity",
        NULL as "To_activity"
        {% for property in properties -%}
            , Event_log."{{ property }}"
        {% endfor -%}
    from Event_log
    inner join Last_events_of_cases
        on Event_log."{{ event_order }}" = Last_events_of_cases."Event_order_last_event"
),

Edges_with_edge_ID as (
    select
        row_number() over (order by Edges_preprocessing."{{ case_ID }}") as "Edge_ID",
        Edges_preprocessing."{{ case_ID }}",
        Edges_preprocessing."From_activity",
        Edges_preprocessing."To_activity"
        {% for property in properties -%}
            , Edges_preprocessing."{{ property }}"
        {% endfor -%}
    from Edges_preprocessing
),

-- For every edge per case the first occurence is marked to optimize metrics.
Edge_first_occurence as (
    select
        min(Edges_with_edge_ID."Edge_ID") as "Edge_first_occurence"
    from Edges_with_edge_ID
    group by Edges_with_edge_ID."{{ case_ID }}",
        Edges_with_edge_ID."From_activity",
        Edges_with_edge_ID."To_activity"
),

-- Optionally, for other properties besides the Case ID the first occurence of an edge can be marked to optimize metrics.
{% for property in properties -%}
    {{'Edge_first_occurence' ~ '_' ~ property }} as (
        select
            min(Edges_with_edge_ID."Edge_ID") as "Edge_first_occurence"
        from Edges_with_edge_ID
        group by Edges_with_edge_ID."{{ property }}",
            Edges_with_edge_ID."From_activity",
            Edges_with_edge_ID."To_activity"
    ),
{% endfor -%}

{{ table_name }} as (
    select
        Edges_with_edge_ID."Edge_ID",
        Edges_with_edge_ID."{{ case_ID }}",
        Edges_with_edge_ID."From_activity",
        Edges_with_edge_ID."To_activity",
        -- Every first occurence of an edge is marked as unique, therefore given the value 1.
        case
            when Edge_first_occurence."Edge_first_occurence" is not NULL
            then 1
            else NULL
        end as "Unique_edge"
        {% for property in properties -%}
            , case
                when {{'Edge_first_occurence' ~ '_' ~ property }}."Edge_first_occurence" is not NULL
                then 1
                else NULL
            end as "{{ 'Unique_edge' ~ '_' ~ property }}"
        {% endfor -%}
    from Edges_with_edge_ID 
    left join Edge_first_occurence
        on Edges_with_edge_ID."Edge_ID" = Edge_first_occurence."Edge_first_occurence"
    {% for property in properties -%}
    left join {{'Edge_first_occurence' ~ '_' ~ property }}
        on Edges_with_edge_ID."Edge_ID" = {{'Edge_first_occurence' ~ '_' ~ property }}."Edge_first_occurence"
    {% endfor -%}
)

{%- endmacro -%}
