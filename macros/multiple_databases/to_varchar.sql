{% macro to_varchar(attribute) %}

{% if var("database") == 'snowflake' %}
    to_varchar({{ attribute }})
{% elif var("database") == 'sqlserver' %}
    convert(nvarchar(50), {{ attribute }})
{% endif %}

{% endmacro %}
