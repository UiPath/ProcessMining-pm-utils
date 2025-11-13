{# This creates a table that can be used in tests that require a relation as argument. #}
select
    3 as "RN",
    {{ pm_utils.to_boolean('false') }} as "Column_B",
    7 as "Column_C",
    2.1 as "Column_E",
    null as "Column_F"
