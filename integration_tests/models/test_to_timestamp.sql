with Input_data as (
    select
        '2023-11-12' as "timestamp_date",
        '2023-11-12 13:14:15' as "timestamp_datetime",
        '2023-11-12 13:14:15.678' as "timestamp_datetime_ms",
        '2023-11-12 13:14:15.6789' as "timestamp_datetime_ms4",
        '13:14:15' as "timestamp_time",
        null as "null_value"
)

select
    {{ pm_utils.to_varchar(pm_utils.to_timestamp('"timestamp_date"')) }} as "timestamp_date",
    {{ pm_utils.to_varchar(pm_utils.to_timestamp('"timestamp_datetime"')) }} as "timestamp_datetime",
    {{ pm_utils.to_varchar(pm_utils.to_timestamp('"timestamp_datetime_ms"')) }} as "timestamp_datetime_ms",
    {{ pm_utils.to_varchar(pm_utils.to_timestamp('"timestamp_datetime_ms4"')) }} as "timestamp_datetime_ms4",
    {{ pm_utils.to_varchar(pm_utils.to_timestamp('"timestamp_time"')) }} as "timestamp_time",
    {{ pm_utils.to_varchar(pm_utils.to_timestamp('"null_value"')) }} as "null_value",
    
    {% if target.type == 'sqlserver' %}
        --SQL Server uses datetime2 format and always specifies the precision with 7 digits.
        --SQL Server will also give a result when only having a date or a time as input
        '2023-11-12 00:00:00.0000000' as "timestamp_date_expected",
        '2023-11-12 13:14:15.0000000' as "timestamp_datetime_expected",
        '2023-11-12 13:14:15.6780000' as "timestamp_datetime_ms_expected",
        '2023-11-12 13:14:15.6789000' as "timestamp_datetime_ms4_expected",
        '1900-01-01 13:14:15.0000000' as "timestamp_time_expected",
        '' as "null_value_expected"
    {% elif target.type == 'snowflake' %}
        '' as "timestamp_date_expected",
        '2023-11-12 13:14:15.000' as "timestamp_datetime_expected",
        '2023-11-12 13:14:15.678' as "timestamp_datetime_ms_expected",
        '2023-11-12 13:14:15.678' as "timestamp_datetime_ms4_expected",
        '' as "timestamp_time_expected",
        '' as "null_value_expected"
    {% endif %}
    
from Input_data
