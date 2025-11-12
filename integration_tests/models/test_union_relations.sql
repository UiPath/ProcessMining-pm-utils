with Union_Three as (
    {{ pm_utils.union_relations([source('sources', 'input_data_1'), source('sources', 'input_data_2'), source('sources', 'input_data_3')]) }}
)

select
    Union_Three."Column_A",
    Union_Three."Column_B",
    Union_Three."Column_C",
    Union_Three."Column_E",
    Union_Three."Column_F",
    Union_Three."Column_G"
    Union_Three_Expected."Column_A" as "Column_A_Expected",
    Union_Three_Expected."Column_B" as "Column_B_Expected",
    Union_Three_Expected."Column_C" as "Column_C_Expected",
    Union_Three_Expected."Column_E" as "Column_E_Expected",
    Union_Three_Expected."Column_F" as "Column_F_Expected",
    Union_Three_Expected."Column_G" as "Column_G_Expected"
from Union_Three
join {{ source('sources', 'union_data') }} as Union_Three_Expected
    on Union_Three."RN" = Union_Three_Expected."RN"


