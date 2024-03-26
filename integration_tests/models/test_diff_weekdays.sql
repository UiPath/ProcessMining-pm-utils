select
    {# Compute difference for different use cases where the complete and half of the weekend falls in the date range. #}
    {{ pm_utils.diff_weekdays("'2024-03-14'", "'2024-03-25'") }} as `Two_weekends`,
    8 as `Two_weekends_expected`,

    {{ pm_utils.diff_weekdays("'2024-03-14'", "'2024-03-23'") }} as `One_half_weekends`,
    7 as `One_half_weekends_expected`,

    {{ pm_utils.diff_weekdays("'2024-03-21'", "'2024-03-25'") }} as `One_weekend`,
    3 as `One_weekend_expected`,

    {{ pm_utils.diff_weekdays("'2024-03-21'", "'2024-03-24'") }} as `One_weekend_end`,
    2 as `One_weekend_end_expected`,

    {{ pm_utils.diff_weekdays("'2024-03-21'", "'2024-03-23'") }} as `Half_weekend`,
    2 as `Half_weekend_expected`,

    {{ pm_utils.diff_weekdays("'2024-03-16'", "'2024-03-19'") }} as `Start_weekend`,
    2 as `Start_weekend_expected`,

    {{ pm_utils.diff_weekdays("'2024-03-17'", "'2024-03-19'") }} as `Start_half_weekend`,
    2 as `Start_half_weekend_expected`,

    {{ pm_utils.diff_weekdays("'2024-03-16'", "'2024-03-17'") }} as `Only_weekend`,
    0 as `Only_weekend_expected`
