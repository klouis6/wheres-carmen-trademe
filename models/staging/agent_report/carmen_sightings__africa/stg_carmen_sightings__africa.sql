with carmen_sightings__africa as (
    select *
        from {{ source('carmen_sightings', 'carmen_sightings__africa') }}
)

select 
    DATE_WITNESS,
    DATE_AGENT,
    WITNESS,
    AGENT,
    LATITUDE,
    LONGITUDE,
    CITY,
    COUNTRY_CODE,
    CITY_AGENT,
    HAS_WEAPON,
    HAS_HAT,
    HAS_JACKET,
    BEHAVIOR,
    from carmen_sightings__africa