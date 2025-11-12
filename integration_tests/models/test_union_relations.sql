with Input_data_1 as (
    select
        {{ pm_utils.to_varchar('A') }} as "Column_A",
        {{ pm_utils.to_boolean('true') }} as "Column_B",
        {{ pm_utils.to_integer('10') }} as "Column_C",  
        {{ pm_utils.to_timestamp('2023-02-01 10:00:00') }} as "Column_D"
),

Input_data_2 as (
    select
        {{ pm_utils.to_integer('20') }} as "Column_C",
        {{ pm_utils.to_double('30.5') }} as "Column_E",
        {{ pm_utils.to_timestamp('2023-02-02 10:00:00') }} as "Column_D",
        null as "Column_F"
),

Input_data_3 as (
    select
        {{ pm_utils.to_integer('15') }} as "Column_C",
        {{ pm_utils.to_varchar('D') }} as "Column_A",
        {{ pm_utils.to_boolean('false') }} as "Column_B",
        {{ pm_utils.to_integer('1') }} as "Column_F",
        null as "Column_G"
),

Union_Three as (
    {{ pm_utils.union_relations(['Input_data_1', 'Input_data_2', 'Input_data_3']) }}
),

Union_Three_Expected as (
    select * from values
        ( {{ pm_utils.to_varchar('A') }}, {{ pm_utils.to_boolean('true') }}, {{ pm_utils.to_integer('10') }}, {{ pm_utils.to_timestamp('2023-02-01 10:00:00') }}, null, null, null ),
        ( null, null, {{ pm_utils.to_integer('20') }}, {{ pm_utils.to_timestamp('2023-02-02 10:00:00') }}, {{ pm_utils.to_double('30.5') }}, null, null ),
        ( {{ pm_utils.to_varchar('D') }}, {{ pm_utils.to_boolean('false') }}, {{ pm_utils.to_integer('15') }}, null, null, {{ pm_utils.to_integer('1') }}, null )
    as ("Column_A_Expected", "Column_B_Expected", "Column_C_Expected", "Column_D_Expected", "Column_E_Expected", "Column_F_Expected", "Column_G_Expected")
)

select
    Union_Three."Column_A",
    Union_Three."Column_B",
    Union_Three."Column_C",
    Union_Three."Column_D",
    Union_Three."Column_E",
    Union_Three."Column_F",
    Union_Three."Column_G"
from Union_Three
union all
select
    Union_Three_Expected."Column_A_Expected",
    Union_Three_Expected."Column_B_Expected",
    Union_Three_Expected."Column_C_Expected",
    Union_Three_Expected."Column_D_Expected",
    Union_Three_Expected."Column_E_Expected",
    Union_Three_Expected."Column_F_Expected",
    Union_Three_Expected."Column_G_Expected"
from Union_Three_Expected


