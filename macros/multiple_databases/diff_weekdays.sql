{%- macro diff_weekdays(start_date_field, end_date_field) -%}

{# Take two dates as input and compute the total number of days between the two dates. Also count it as one day in case the "from date" and the "to date" are on the same day. 
From this total number of days, we subtract the weekend days (Saturday and Sunday). We use the function datediff with parameter week.
This function returns 1 for every complete week, where a week is defined from Sunday to Saturday.
Since the function only returns full weeks, we need to adjust the parameters to account for date ranges that start on Sunday or end at Saturday. #}
{{ pm_utils.datediff('day', start_date_field, end_date_field) }} + 1
- {{ pm_utils.datediff('week', start_date_field, pm_utils.dateadd('day', 1, end_date_field)) }}
- {{ pm_utils.datediff('week', pm_utils.dateadd('day', -1, start_date_field), end_date_field) }}

{%- endmacro -%}
