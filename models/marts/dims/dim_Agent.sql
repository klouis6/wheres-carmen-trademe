with stg_carmen_sightings__combined as (
    select *
    from {{ ref('stg_carmen_sightings__combined') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['agent', 'city_agent', 'region']) }} as agent_id,
    agent,
    city_agent,
    region
from stg_carmen_sightings__combined
group by agent,
    city_agent,
    region
