{% macro test_not_null(model, column_name) %}

    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0

{% endmacro %}
