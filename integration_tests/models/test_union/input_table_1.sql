{# This creates a table that can be used in test_union. #}
select
    1 as "RN",
    'A' as "Column_A",
    {{ pm_utils.to_boolean('true') }} as "Column_B",
    null as "Column_C"
