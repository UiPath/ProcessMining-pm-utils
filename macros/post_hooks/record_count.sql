{%- macro record_count() -%}

{% set query %}
select count(*) as "record_count" from {{ this }}
{% endset %}

{% set result_query = run_query(query) %}
{% if execute %}
    {% set record_count = result_query.columns['record_count'].values()[0] %}
{% else %}
    {% set record_count = 0 %}
{% endif %}

{% if record_count > (var("max_records_error")|int) %}
    {% if var("log_result", False) == True %}
        {{ log(tojson({'Key': 'RecordCount', 'Details': {'table': this.identifier}, 'Category': 'UserError', 'Message': 'The table ' ~ this.identifier ~ ' exceeds ' ~ var("max_records_error") ~ ' records, which is unexpectedly large. If this is intentional, you can adjust the max_records_error variable in the dbt_project.yml'}), True) }}
    {% endif %}
{% elif record_count > (var("max_records_warning")|int) %}
    {% if var("log_result", False) == True %}
        {{ log(tojson({'Key': 'RecordCount', 'Details': {'table': this.identifier}, 'Category': 'UserWarning', 'Message': 'The table ' ~ this.identifier ~ ' exceeds ' ~ var("max_records_warning") ~ ' records, which is unexpectedly large. If this is intentional, you can adjust the max_records_warning variable in the dbt_project.yml'}), True) }}
    {% endif %}
{% endif %}

{%- endmacro -%}
