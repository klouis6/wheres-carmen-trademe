SELECT
    {{ dbt_utils.generate_surrogate_key(['agent_dim.agent_id', 'date_agent_dim.date_day', 'locaction_dim.location_id', 'witness_dim.witness_id', 'date_witness_dim.date_day', 'behavior_dim.behavior_id']) }} AS sighting_id,
    agent_dim.agent_id,
    date_agent_dim.date_day AS date_agent,
    locaction_dim.location_id,
    witness_dim.witness_id,
    date_witness_dim.date_day AS date_witness,
    behavior_dim.behavior_id,
    base.has_weapon,
    base.has_hat,
    base.has_jacket
FROM {{ ref('stg_carmen_sightings__combined') }} as base
LEFT JOIN {{ ref('dim_Agent') }} as agent_dim ON base.agent = agent_dim.agent AND base.city_agent = agent_dim.city_agent AND base.region = agent_dim.region
LEFT JOIN {{ ref('dim_Witness') }} as witness_dim ON base.witness = witness_dim.witness
LEFT JOIN {{ ref('dim_Behavior') }} as behavior_dim ON base.behavior = behavior_dim.behavior
LEFT JOIN {{ ref('dim_Location') }} as locaction_dim 
    ON base.latitude = locaction_dim.latitude
    AND base.longitude = locaction_dim.longitude
LEFT JOIN {{ ref('dim_Date') }} as date_witness_dim ON base.date_witness = date_witness_dim.date_day
LEFT JOIN {{ ref('dim_Date') }} as date_agent_dim ON base.date_agent = date_agent_dim.date_day