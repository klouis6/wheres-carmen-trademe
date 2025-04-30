with stg_carmen_sightings__combined as (
    select *
    from {{ ref('stg_carmen_sightings__combined') }}
)

select
     {{ dbt_utils.generate_surrogate_key(['behavior']) }} as behavior_id,
    behavior
from stg_carmen_sightings__combined
group by behavior
