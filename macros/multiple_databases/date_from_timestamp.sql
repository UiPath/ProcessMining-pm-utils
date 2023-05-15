{%- macro date_from_timestamp(field) -%}

{%- if target.type == 'snowflake' -%}
    case
        when len({{ field }}) > 0
            then try_to_date({{ field }})
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
