{%- macro create_index(source_table) -%}

{%- if target.type == 'sqlserver' -%}
    drop index if exists cci on {{ this.database }}.{{ var("schema_sources") }}.{{ source_table }};
    create clustered columnstore index cci on {{ this.database }}.{{ var("schema_sources") }}.{{ source_table }};
{%- endif -%}

{%- endmacro -%}
