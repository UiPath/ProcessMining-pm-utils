{# This tests that we can successfully create a table except a column, which we create outside of the star macro.
In case the except wouldn't work, this SQL statement would fail due to duplicate column aliases. #}
select
    {{ pm_utils.star(ref('input_table'), except['Column_B']) }},
    'B' as `Column_B`
from {{ ref('input_table') }}
