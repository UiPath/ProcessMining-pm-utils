with Input_data as (
    select
        'This is a text!' as `Text`
)

select
    {# Find a substring (basic scenario) #}
    {{ pm_utils.charindex('his', '`Text`') }} as `Find_basic_scenario`,
    2 as `Find_basic_scenario_expected`,

    {# Find a substring with multiple occurences #}
    {{ pm_utils.charindex('is', '`Text`') }} as `Find_first_of_multiple_occurrences`,
    3 as `Find_first_of_multiple_occurrences_expected`,

    {# Find a space. Covering an edge case in SQL Server, spaces in values are ignored by default #}
    {{ pm_utils.charindex(' ', '`Text`') }} as `Find_first_space`,
    5 as `Find_first_space_expected`,

    {# Find a substring with multiple occurences using a start location after the first occurence #}
    {{ pm_utils.charindex('is', '`Text`', 4) }} as `Find_with_start_location`,
    6 as `Find_with_start_location_expected`,

    {# Find non occuring value #}
    {{ pm_utils.charindex('x', '`Text`') }} as `Find_non_occurring_value`,
    13 as `Find_non_occurring_value_expected`,

    {# Find empty value #}
    {{ pm_utils.charindex('', '`Text`') }} as `Find_empty_value`,
    0 as `Find_empty_value_expected`,

    {# Find null value #}
    {{ pm_utils.charindex(null, '`Text`') }} as `Find_null_value`,
    0 as `Find_null_value_expected`

from Input_data
