{%- macro optional(optional_column, source_table, data_type) -%}

{%- set columns = adapter.get_columns_in_relation(source_table) -%}

-- Create list of column names.
{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append('"' + column.name + '"') -%}
{%- endfor -%}

-- When the column is in the list, use the column, otherwise create the column with null values.
{% if optional_column in column_names -%}
    {%- if data_type == 'boolean' -%}
        {{ pm_utils.to_boolean(optional_column) }} as {{ optional_column }}
    {%- elif data_type == 'date' -%}
        {{ pm_utils.to_date(optional_column) }} as {{ optional_column }}
    {%- elif data_type == 'double' -%}
        {{ pm_utils.to_double(optional_column) }} as {{ optional_column }}
    {%- elif data_type == 'integer' -%}
        {{ pm_utils.to_integer(optional_column) }} as {{ optional_column }}
    {%- elif data_type == 'time' -%}
        {{ pm_utils.to_time(optional_column) }} as {{ optional_column }}
    {%- elif data_type == 'datetime' -%}
        {{ pm_utils.to_timestamp(optional_column) }} as {{ optional_column }}
    {%- elif data_type == 'text' -%}
        {{ pm_utils.to_varchar(optional_column) }} as {{ optional_column }}
    {%- else -%}
        {{ pm_utils.to_varchar(optional_column) }} as {{ optional_column }}
    {%- endif -%}
{%- else -%}
    {%- if data_type == 'boolean' -%}
        {{ pm_utils.to_boolean('null') }} as {{ optional_column }}
    {%- elif data_type == 'date' -%}
        {{ pm_utils.to_date('null') }} as {{ optional_column }}
    {%- elif data_type == 'double' -%}
        {{ pm_utils.to_double('null') }} as {{ optional_column }}
    {%- elif data_type == 'integer' -%}
        {{ pm_utils.to_integer('null') }} as {{ optional_column }}
    {%- elif data_type == 'time' -%}
        {{ pm_utils.to_time('null') }} as {{ optional_column }}
    {%- elif data_type == 'datetime' -%}
        {{ pm_utils.to_timestamp('null') }} as {{ optional_column }}
    {%- elif data_type == 'text' -%}
        {{ pm_utils.to_varchar('null') }} as {{ optional_column }}
    {%- else -%}
        {{ pm_utils.to_varchar('null') }} as {{ optional_column }}
    {%- endif -%}
{%- endif -%}

{%- endmacro -%}
