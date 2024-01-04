with Input_data as (
    select
        '2023-11-12 13:14:15.678' as `testdate`,
        null as `null_value`,
        {{ pm_utils.to_integer('1') }} as `bigint_value`,
        {{ pm_utils.to_integer('30') }} as `bigint_value_30`,
)

select
    {# Add 1 unit for every possible dateparts. #}
    {{ pm_utils.to_varchar(pm_utils.dateadd('millisecond', 1, '`testdate`')) }} as `add_milliseconds`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('second', 1, '`testdate`')) }} as `add_seconds`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('minute', 1, '`testdate`')) }} as `add_minutes`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('hour', 1, '`testdate`')) }} as `add_hours`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('day', 1, '`testdate`')) }} as `add_days`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('week', 1, '`testdate`')) }} as `add_weeks`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('month', 1, '`testdate`')) }} as `add_months`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('quarter', 1, '`testdate`')) }} as `add_quarters`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('year', 1, '`testdate`')) }} as `add_years`,

    {# Add 30 days to cover the scenario a bigint is required to store the amount of milliseconds. #}
    {{ pm_utils.to_varchar(pm_utils.dateadd('day', 30, '`testdate`')) }} as `add_30_days_in_days`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('second', 2592000, '`testdate`')) }} as `add_30_days_in_seconds`,

    {# Use a bigint datatype as the input for number of units to be added. #}
    {{ pm_utils.to_varchar(pm_utils.dateadd('year', '`bigint_value`', '`testdate`')) }} as `add_bigint`,
    {{ pm_utils.to_varchar(pm_utils.dateadd('day', '`bigint_value_30`', '`testdate`')) }} as `add_bigint_30_days`,

    {% if target.type == 'sqlserver' %}
        {# SQL Server uses datetime2 format, which has a precision of 7 digits #}
        '2023-11-12 13:14:15.6790000' as `add_milliseconds_expected`,
        '2023-11-12 13:14:16.6780000' as `add_seconds_expected`,
        '2023-11-12 13:15:15.6780000' as `add_minutes_expected`,
        '2023-11-12 14:14:15.6780000' as `add_hours_expected`,
        '2023-11-13 13:14:15.6780000' as `add_days_expected`,
        '2023-11-19 13:14:15.6780000' as `add_weeks_expected`,
        '2023-12-12 13:14:15.6780000' as `add_months_expected`,
        '2024-02-12 13:14:15.6780000' as `add_quarters_expected`,
        '2024-11-12 13:14:15.6780000' as `add_years_expected`,
        '2023-12-12 13:14:15.6780000' as `add_30_days_in_days_expected`,
        '2023-12-12 13:14:15.6780000' as `add_30_days_in_seconds_expected`,
        '2024-11-12 13:14:15.6780000' as `add_bigint_expected`,
        '2023-12-12 13:14:15.6780000' as `add_bigint_30_days_expected`,
    {% else %}
        '2023-11-12 13:14:15.679' as `add_milliseconds_expected`,
        '2023-11-12 13:14:16.678' as `add_seconds_expected`,
        '2023-11-12 13:15:15.678' as `add_minutes_expected`,
        '2023-11-12 14:14:15.678' as `add_hours_expected`,
        '2023-11-13 13:14:15.678' as `add_days_expected`,
        '2023-11-19 13:14:15.678' as `add_weeks_expected`,
        '2023-12-12 13:14:15.678' as `add_months_expected`,
        '2024-02-12 13:14:15.678' as `add_quarters_expected`,
        '2024-11-12 13:14:15.678' as `add_years_expected`,
        '2023-12-12 13:14:15.678' as `add_30_days_in_days_expected`,
        '2023-12-12 13:14:15.678' as `add_30_days_in_seconds_expected`,
        '2024-11-12 13:14:15.678' as `add_bigint_expected`,
        '2023-12-12 13:14:15.678' as `add_bigint_30_days_expected`,
    {% endif %}
    
    {# Use null as the date #}
    {{ pm_utils.to_varchar(pm_utils.dateadd('year', 1, '`null_value`')) }} as `add_to_null_value`,
    '' as `add_to_null_value_expected`

from Input_data
