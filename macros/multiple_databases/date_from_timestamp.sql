{%- macro date_from_timestamp(field) -%}

{%- if target.type == 'snowflake' -%}
    case
        when len({{ field }}) > 0
            then to_date({{ field }})
        else
            to_date(NULL)
    end
{%- elif target.type == 'sqlserver' -%}
    case
        when len({{ field }}) > 0
            then try_convert(date, {{ field }})
        else
            try_convert(date, NULL)
    end
{%- endif -%}

{%- endmacro -%}
