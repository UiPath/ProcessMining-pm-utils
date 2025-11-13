with Union_Three as (
    {{ pm_utils.union_relations([ref('input_table_1'), ref('input_table_2'), ref('input_table_3')]) }}
),

Union_Three_Expected as (
    select 
    1 as RN, 'A' as Column_A_Expected, pm_utils.to_boolean('true') as Column_B_Expected, 10 as Column_C_Expected, null as Column_E_Expected, null as Column_F_Expected, null as Column_G_Expected
    union all
    select 2, 'B', null, 5, 3.5, null, null
    union all
    select 3, null, pm_utils.to_boolean('false'), 7, null, 2.1, null
)

select
    Union_Three."Column_A",
    Union_Three."Column_B",
    Union_Three."Column_C",
    Union_Three."Column_E",
    Union_Three."Column_F",
    Union_Three."Column_G",
    Union_Three_Expected."Column_A_Expected"
    Union_Three_Expected."Column_B_Expected",
    Union_Three_Expected."Column_C_Expected",
    Union_Three_Expected."Column_E_Expected",
    Union_Three_Expected."Column_F_Expected",
    Union_Three_Expected."Column_G_Expected"
from Union_Three
left join Union_Three_Expected
    on Union_Three."RN" = Union_Three_Expected."RN"
