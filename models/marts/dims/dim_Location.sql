with stg_carmen_sightings__combined as (
    select *
    from {{ ref('stg_carmen_sightings__combined') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['latitude', 'longitude']) }} as location_id,
    country,
    city,
    latitude,
    longitude
from stg_carmen_sightings__combined
group by 
    country,
    city,
    latitude,
    longitude
