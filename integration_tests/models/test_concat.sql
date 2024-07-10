with Input_data as (
    select
        'A' as "Column_A",
        'B' as "Column_B",
        null as "Column_C"
)

select
    {# Concatenate two text fields (basic scenario) #}
    {{ pm_utils.concat('"Column_A"', '"Column_B"') }} as "Two_text_fields",
    'AB' as "Two_text_fields_expected",

    {# Concatenate two fields of which one is null #}
    {{ pm_utils.concat('"Column_A"', '"Column_C"') }} as "One_null",
    'A' as "One_null_expected"
from Input_data
