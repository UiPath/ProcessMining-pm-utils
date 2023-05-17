{%- macro date_from_timestamp(field) -%}

{# Snowflake try_to function requires an expression of type varchar. #}
{%- if target.type == 'snowflake' -%}
    case
        when len({{ field }}) > 0
            then try_to_date(to_varchar({{ field }}))
        else
            to_date(null)
    end
{%- elif target.type == 'sqlserver' -%}
    case
        when len({{ field }}) > 0
            then try_convert(date, {{ field }})
        else
            try_convert(date, null)
    end
{%- endif -%}

{%- endmacro -%}
