WITH base AS (
    SELECT date_witness,
        witness,
        agent,
        date_agent,
        city_agent,
        country,
        city,
        latitude,
        longitude,
        has_weapon,
        has_hat,
        has_jacket,
        behavior,
        region
    FROM {{ ref('stg_carmen_sightings__combined') }}
),

date_dim AS (
    SELECT date_day_id,
        date_day,
        year,
        month,
        day
    FROM {{ ref('dim_Date') }}
),

agent_dim AS (
    SELECT agent_id,
        agent,
        city_agent,
        region
    FROM {{ ref('dim_Agent') }}
),

witness_dim AS (
    SELECT witness_id,
        witness
    FROM {{ ref('dim_Witness') }}
),

behavior_dim AS (
    SELECT behavior_id,
        behavior
    FROM {{ ref('dim_Behavior') }}
),

location_dim AS (
    SELECT location_id,
        country,
        city,
        latitude,
        longitude
    FROM {{ ref('dim_Location') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY base.date_witness ASC) AS sighting_id,
    agent.agent_id,
    da.date_day_id AS date_agent_id,
    loc.location_id,
    wit.witness_id,
    dw.date_day_id AS date_witness_id,
    beh.behavior_id,
    base.has_weapon,
    base.has_hat,
    base.has_jacket
FROM base
LEFT JOIN agent_dim agent ON base.agent = agent.agent AND base.city_agent = agent.city_agent AND base.region = agent.region
LEFT JOIN witness_dim wit ON base.witness = wit.witness
LEFT JOIN behavior_dim beh ON base.behavior = beh.behavior
LEFT JOIN location_dim loc 
    ON base.latitude = loc.latitude
    AND base.longitude = loc.longitude
LEFT JOIN date_dim dw ON TO_CHAR(base.date_witness, 'YYYYMMDD') = dw.date_day_id
LEFT JOIN date_dim da ON TO_CHAR(base.date_agent, 'YYYYMMDD') = da.date_day_id
ORDER BY sighting_id