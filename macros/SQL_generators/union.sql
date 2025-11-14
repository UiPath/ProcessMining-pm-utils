{%- macro union(relations) -%}
    {#
        relations: a list of relations (model/ source tables) that exist in the database.
        This macro unions any number of tables, aligning columns by name and filling missing columns with NULLs.
    #}
    {%- set joint_columns = [] -%}
    {%- for relation in relations -%}
        {%- set cols = adapter.get_columns_in_relation(relation) -%}
        {%- for col in cols -%}
            {%- if col.name not in joint_columns -%}
                {%- do joint_columns.append(col.name) -%}
            {%- endif -%}
        {%- endfor -%}
    {%- endfor -%}

    {%- set selects = [] -%}
    {%- for relation in relations -%}
        {%- set cols = adapter.get_columns_in_relation(relation) -%}
        {%- set col_names = cols | map(attribute='name') | list -%}
        {%- set select_parts = [] -%}
        {%- for col in joint_columns -%}
            {%- if col in col_names -%}
                {%- do select_parts.append('"' ~ col ~ '"') -%}
            {%- else -%}
                {%- do select_parts.append('NULL as "' ~ col ~ '"') -%}
            {%- endif -%}
        {%- endfor -%}
        {%- set select_sql = 'select ' ~ select_parts | join(', ') ~ ' from ' ~ relation -%}
        {%- do selects.append(select_sql) -%}
    {%- endfor -%}

    {{ selects | join('\nunion all\n') }}
{%- endmacro -%}
