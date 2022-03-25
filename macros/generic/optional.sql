{%- macro optional(source_table, optional_column, data_type) -%}

{%- set columns = adapter.get_columns_in_relation(source_table) -%}

{# Create list of column names.#}
{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append('"' + column.name + '"') -%}
{%- endfor -%}

{# When the column is in the list, use the column, otherwise create the column with null values.#}
{%- if optional_column in column_names -%}
    {% set column_value = optional_column -%}
{%- else -%}    
    {% set column_value = 'null' -%}
{%- endif -%}

{%- if data_type == 'boolean' -%}
    {{ pm_utils.to_boolean(column_value) }} as {{ optional_column }}
{%- elif data_type == 'date' -%}
    {{ pm_utils.to_date(column_value) }} as {{ optional_column }}
{%- elif data_type == 'double' -%}
    {{ pm_utils.to_double(column_value) }} as {{ optional_column }}
{%- elif data_type == 'integer' -%}
    {{ pm_utils.to_integer(column_value) }} as {{ optional_column }}
{%- elif data_type == 'time' -%}
    {{ pm_utils.to_time(column_value) }} as {{ optional_column }}
{%- elif data_type == 'datetime' -%}
    {{ pm_utils.to_timestamp(column_value) }} as {{ optional_column }}
{%- elif data_type == 'text' -%}
    {{ pm_utils.to_varchar(column_value) }} as {{ optional_column }}
{%- else -%}
    {{ pm_utils.to_varchar(column_value) }} as {{ optional_column }}
{%- endif -%}

{%- endmacro -%}
