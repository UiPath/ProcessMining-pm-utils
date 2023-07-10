{%- macro generate_id(id_field) -%}

{%- if target.type == 'snowflake' -%}
    use "{{ this.database }}"."{{ this.schema }}";
    create or replace sequence seq_{{ this.identifier }};
    create or replace table {{ this }} as (
        select
            {{ this }}.*,
            s.nextval as "{{ id_field }}"
        from {{ this }}, table(getnextval(seq_{{ this.identifier }})) s
    )
{%- elif target.type == 'databricks' -%}
    create or replace table {{ this }} as (
        select
            {{ this }}.*,
            monotonically_increasing_id() as `{{ id_field }}`
        from {{ this }}
    )
{%- elif target.type == 'sqlserver' -%}
    alter table {{ this }}
    add {{ id_field }} bigint identity(1,1)
{%- endif -%}

{%- endmacro -%}
