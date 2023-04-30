{% macro test_unique(model, column_name) %}

    select 'dummy_value' as "dummy"
    from {{ model }}
    where 1 = 0

{% endmacro %}
