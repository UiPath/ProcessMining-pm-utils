{%- macro union_relations(relations) -%}
    {#
        relations: a list of relation objects or strings (table/view names) that exist in the database.
        This macro unions any number of tables, aligning columns by name and filling missing columns with NULLs.
    #}
    {%- set joint_columns = [] -%}
    {%- for relation in relations -%}
        {%- set rel = ref(relation) if relation is string else relation -%}
        {%- set cols = adapter.get_columns_in_relation(rel) -%}
        {%- for col in cols -%}
            {%- if col.name not in joint_columns -%}
                {%- do joint_columns.append(col.name) -%}
            {%- endif -%}
        {%- endfor -%}
    {%- endfor -%}

    {%- set selects = [] -%}
    {%- for relation in relations -%}
        {%- set rel = ref(relation) if relation is string else relation -%}
        {%- set cols = adapter.get_columns_in_relation(rel) -%}
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
