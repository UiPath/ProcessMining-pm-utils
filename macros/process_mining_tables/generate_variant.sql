{%- macro generate_variant(table_name, event_log_model, case_ID, activity, event_order) -%}

Event_log as (
    select * from {{ ref(event_log_model) }}
),

-- The activities per Case ID are concatenated, ordered by Event order, such that every particular order of executed activities is a separate variant.
Cases_with_variant_ID as (
    select
        Event_log."{{ case_ID }}",
        {% if target.type == 'snowflake' -%}
            listagg(Event_log."{{ activity }}", '->')
        {% elif target.type == 'sqlserver' -%}
            string_agg(convert(nvarchar(max), Event_log."{{ activity }}"), '->')
        {% endif -%}
            within group (order by Event_log."{{ event_order }}") as "Variant_ID"
    from Event_log
    group by Event_log."{{ case_ID }}"
),

-- A variant number is decided by counting the amount of occurrences of the variant.
Variant as (
    select
        Cases_with_variant_ID."Variant_ID",
        concat('Variant ', row_number() over (order by count(Cases_with_variant_ID."Variant_ID") desc)) as "Variant"
    from Cases_with_variant_ID
    group by Cases_with_variant_ID."Variant_ID"
),

-- The variants are joined to the cases on the Variant ID to create a table with the Case ID and Variant attribute.
{{ table_name }} as (
    select
        Cases_with_variant_ID."{{ case_ID }}",
        Variant."Variant"
    from Cases_with_variant_ID
    inner join Variant
        on Cases_with_variant_ID."Variant_ID" = Variant."Variant_ID"
)

{%- endmacro -%}
