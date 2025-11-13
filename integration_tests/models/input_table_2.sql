{# This creates a table that can be used in tests that require a relation as argument. #}
select
    {{ pm_utils.to_integer('5') }} as "Column_C",
    {{ pm_utils.to_double('3.5') }} as "Column_D",
    null as "Column_E",
    {{ pm_utils.to_integer('2') }} as "RN",
    'B' as "Column_A"
