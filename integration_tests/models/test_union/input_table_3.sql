{# This creates a table that can be used in test_union.  #}
select
    3 as "RN",
    {{ pm_utils.to_boolean('false') }} as "Column_B",
    7 as "Column_C",
    {{ pm_utils.to_boolean('false') }} as "Column_E",
    null as "Column_F"
