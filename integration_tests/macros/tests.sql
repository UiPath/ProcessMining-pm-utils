{% test equal_value(model, actual, expected) %}
    select * from {{ model }} where {{ actual }} != {{ expected }}
{% endtest %}
