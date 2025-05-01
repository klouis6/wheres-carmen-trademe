with stg_carmen_sightings__combined as (
    select *
    from {{ ref('stg_carmen_sightings__combined') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['witness']) }} as witness_id,
    witness
from stg_carmen_sightings__combined
group by witness
