{%- macro mandatory(relation, mandatory_column, data_type) -%}

{%- if data_type == 'boolean' -%}
    {{ pm_utils.to_boolean(mandatory_column, relation) }}
{%- elif data_type == 'date' -%}
    {{ pm_utils.to_date(mandatory_column, relation) }}
{%- elif data_type == 'double' -%}
    {{ pm_utils.to_double(mandatory_column, relation) }}
{%- elif data_type == 'integer' -%}
    {{ pm_utils.to_integer(mandatory_column, relation) }}
{%- elif data_type == 'datetime' -%}
    {{ pm_utils.to_timestamp(mandatory_column, relation) }}
{%- elif data_type == 'text' -%}
    {{ pm_utils.to_varchar(mandatory_column) }}
{%- elif data_type == 'id' -%}
    {{ pm_utils.to_integer(mandatory_column, relation) }}
{%- else -%}
    {{ pm_utils.to_varchar(mandatory_column) }}
{%- endif -%}

{%- endmacro -%}
