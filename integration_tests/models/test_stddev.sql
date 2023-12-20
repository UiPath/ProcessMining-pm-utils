with Input_data as (
	select val
    from (values (1),(2),(3),(4)) as Input(val)
),

Input_data_with_null as (
	select val
    from (values (1),(2),(null),(4)) as Input(val)
),

stddev_input_data as (
    select
        round({{ pm_utils.stddev('val') }}, 3) as `stddev_input_data`
    from Input_data
),

stddev_input_data_null as (
    select
        round({{ pm_utils.stddev('val') }}, 3) as `stddev_input_data_null`
    from Input_data_with_null
)

select
    {{ pm_utils.to_varchar('stddev_input_data.`stddev_input_data`') }} as `stddev_actual`,
    '1.291' as `stddev_expected`,

    {{ pm_utils.to_varchar('stddev_input_data_null.`stddev_input_data_null`') }} as `stddev_with_null_values_actual`,
    '1.528' as `stddev_with_null_values_expected`
from stddev_input_data
cross join stddev_input_data_null
