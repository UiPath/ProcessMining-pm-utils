{%- macro mandatory(source_table, mandatory_column, data_type) -%}

{%- if data_type == 'boolean' -%}
    {{ pm_utils.to_boolean(mandatory_column, source_table) }}
{%- elif data_type == 'date' -%}
    {{ pm_utils.to_date(mandatory_column, source_table) }}
{%- elif data_type == 'double' -%}
    {{ pm_utils.to_double(mandatory_column, source_table) }}
{%- elif data_type == 'integer' -%}
    {{ pm_utils.to_integer(mandatory_column, source_table) }}
{%- elif data_type == 'time' -%}
    {{ pm_utils.to_time(mandatory_column, source_table) }}
{%- elif data_type == 'datetime' -%}
    {{ pm_utils.to_timestamp(mandatory_column, source_table) }}
{%- elif data_type == 'text' -%}
    {{ pm_utils.to_varchar(mandatory_column) }}
{%- elif data_type == 'id' -%}
    {{ pm_utils.to_integer(mandatory_column, source_table) }}
{%- else -%}
    {{ pm_utils.to_varchar(mandatory_column) }}
{%- endif -%}

{%- endmacro -%}
