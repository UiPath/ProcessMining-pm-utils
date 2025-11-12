{%- macro union_relations(relations) -%}
    {#
        relations: a list of relation objects or strings (table/view names) that exist in the database.
        This macro unions any number of tables, aligning columns by name and filling missing columns with NULLs.
        It ensures that columns with the same name are cast to a common type across all relations.
    #}
    {%- set joint_columns = [] -%}
    {%- set column_types = {} -%}
    {%- for relation in relations -%}
        {%- set cols = adapter.get_columns_in_relation(relation) -%}
        {%- for col in cols -%}
            {%- if col.name not in joint_columns -%}
                {%- do joint_columns.append(col.name) -%}
                {%- set _ = column_types.update({col.name: col.dtype}) -%}
            {%- else -%}
                {#- If a column appears in multiple tables, prefer the first type found -#}
            {%- endif -%}
        {%- endfor -%}
    {%- endfor -%}

    {%- set selects = [] -%}
    {%- for relation in relations -%}
        {%- set cols = adapter.get_columns_in_relation(relation) -%}
        {%- set col_names = cols | map(attribute='name') | list -%}
        {%- set col_types = {} -%}
        {%- for col in cols -%}
            {%- set _ = col_types.update({col.name: col.dtype}) -%}
        {%- endfor -%}
        {%- set select_parts = [] -%}
        {%- for col in joint_columns -%}
            {%- set target_type = column_types[col] -%}
            {%- if col in col_names -%}
                {%- set source_type = col_types[col] -%}
                {%- if source_type != target_type -%}
                    {%- do select_parts.append('CAST("' ~ col ~ '" AS ' ~ target_type ~ ') as "' ~ col ~ '"') -%}
                {%- else -%}
                    {%- do select_parts.append('"' ~ col ~ '"') -%}
                {%- endif -%}
            {%- else -%}
                {%- do select_parts.append('CAST(NULL AS ' ~ target_type ~ ') as "' ~ col ~ '"') -%}
            {%- endif -%}
        {%- endfor -%}
        {%- set select_sql = 'select ' ~ select_parts | join(', ') ~ ' from ' ~ relation -%}
        {%- do selects.append(select_sql) -%}
    {%- endfor -%}

    {{ selects | join('\nunion all\n') }}
{%- endmacro -%}
