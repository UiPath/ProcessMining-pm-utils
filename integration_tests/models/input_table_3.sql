{# This creates a table that can be used in tests that require a relation as argument. #}
select
    {{ pm_utils.to_integer('3') }} as "RN",
    {{ pm_utils.to_boolean('false') }} as "Column_B",
    {{ pm_utils.to_integer('7') }} as "Column_C",
    {{ pm_utils.to_boolean('false') }} as "Column_E",
    null as "Column_F"
