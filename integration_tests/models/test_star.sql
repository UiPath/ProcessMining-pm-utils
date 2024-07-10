{# This model tests whether we can create successfully the tables using the star macro in different scenarios. 
When the star macro doesn't work as expected, the SQL statements fail due to duplicate column aliases. #}

{# Select all, except a list of columns. This works as expected when we can create select statements with the aliases listed in the except. #}
with Select_all_except as (
    select
        {{ pm_utils.star(ref('input_table'), except=['Column_A']) }},
        'A' as "Column_A"
    from {{ ref('input_table') }}
),

{# Select all columns. This works as expected when we can use the columns in a next transformation. #}
Select_all as (
    select
        {{ pm_utils.star(ref('input_table')) }}
    from {{ ref('input_table') }}
)

select
    "Column_A",
    "Column_B"
from Select_all
