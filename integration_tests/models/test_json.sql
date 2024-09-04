with Input_data as (
    select
        '{"Field_A":"ABC"}' as "Column_A",
        '{"Field_A": {"Field_B": "DEF"}}' as "Column_B",
        null as "Column_C"
)

select
    {# Get value from a one level path. #}
    {{ pm_utils.json('"Column_A"', 'Field_A') }} as "One_level_field",
    'ABC' as "One_level_field_expected",

    {# Get value from a two level path. #}
    {{ pm_utils.json('"Column_B"', 'Field_A.Field_B') }} as "Two_level_field",
    'DEF' as "Two_level_field_expected"
from Input_data
