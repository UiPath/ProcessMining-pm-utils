{%- macro create_index(source_relation) -%}

{%- if target.type == 'sqlserver' -%}
    {%- if source_relation is defined -%}
        drop index if exists cci on {{ source_relation }};
        create clustered columnstore index cci on {{ source_relation }};
    {%- else -%}
        drop index if exists cci on {{ this }};
        create clustered columnstore index cci on {{ this }};
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
