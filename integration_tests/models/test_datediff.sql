select
    {# Compute difference for every unit. Input parameters are date or datetime data types. #}
    {{ pm_utils.datediff('year', "'2023-01-01'", "'2024-03-05'") }} as "Year",
    1 as "Year_expected",

    {{ pm_utils.datediff('quarter', "'2023-01-01'", "'2024-03-05'") }} as "Quarter",
    4 as "Quarter_expected",

    {{ pm_utils.datediff('month', "'2023-01-01'", "'2024-03-05'")}} as "Month",
    14 as "Month_expected",

    {{ pm_utils.datediff('week', "'2024-03-23'", "'2024-03-24'") }} as "Week_saturday_to_sunday",
    {{ pm_utils.datediff('week', "'2024-03-24'", "'2024-03-30'") }} as "Week_sunday_to_saturday",
    1 as "Week_saturday_to_sunday_expected",
    0 as "Week_sunday_to_saturday_expected",

    {{ pm_utils.datediff('day', "'2024-03-01'", "'2024-03-30'") }} as "Day",
    29 as "Day_expected",

    {{ pm_utils.datediff('hour', "'2024-03-01 00:00:00'", "'2024-03-01 23:59:59'") }} as "Hour",
    23 as "Hour_expected",

    {{ pm_utils.datediff('minute', "'2024-03-01 00:00:00'", "'2024-03-01 00:59:59'") }} as "Minute",
    59 as "Minute_expected",

    {{ pm_utils.datediff('second', "'2024-03-01 00:00:00'", "'2024-03-01 00:00:59'") }} as "Second",
    59 as "Second_expected",

    {{ pm_utils.datediff('millisecond', "'2024-03-01 00:00:00'", "'2024-03-01 00:00:00.999'") }} as "Millisecond",
    999 as "Millisecond_expected"
