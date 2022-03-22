{%- macro optional(optional_column, source_table) -%}

{%- set columns = adapter.get_columns_in_relation(source_table) -%}

-- Create list of column names.
{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append(column.name) -%}
{%- endfor -%}

-- When the column is in the list, use the column, otherwise create the column with null values.
{% if optional_column in column_names -%}
    "{{ optional_column }}"
{%- else -%}
    null as "{{ optional_column }}"
{%- endif -%}

{%- endmacro -%}
