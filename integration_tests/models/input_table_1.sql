{# This creates a table that can be used in tests that require a relation as argument. #}
select
    {{ pm_utils.to_integer('1') }} as "RN",
    'A' as "Column_A",
    {{ pm_utils.to_boolean('true') }} as "Column_B",
    null as "Column_C"
