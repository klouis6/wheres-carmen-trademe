{% macro get_carmen_sightings(source_name, table_name) %}
    with {{ table_name }} as (
        select *
        from {{ source(source_name, table_name) }}
    )

    select 
        DATE_WITNESS,
        WITNESS,
        AGENT,
        DATE_AGENT,
        CITY_AGENT,
        COUNTRY_CODE as COUNTRY,
        CITY,
        LATITUDE,
        LONGITUDE,
        HAS_WEAPON,
        HAS_HAT,
        HAS_JACKET,
        BEHAVIOR
    from {{ table_name }}
{% endmacro %}