with stg_carmen_sightings__africa as (
    select * from {{ ref('stg_carmen_sightings__africa') }}
),
stg_carmen_sightings__america as (
    select * from {{ ref('stg_carmen_sightings__america') }}
),
stg_carmen_sightings__asia as (
    select * from {{ ref('stg_carmen_sightings__asia') }}
),
stg_carmen_sightings__atlantic as (
    select * from {{ ref('stg_carmen_sightings__atlantic') }}
),
stg_carmen_sightings__australia as (
    select * from {{ ref('stg_carmen_sightings__australia') }}
),
stg_carmen_sightings__europe as (
    select * from {{ ref('stg_carmen_sightings__europe') }}
),
stg_carmen_sightings__indian as (
    select * from {{ ref('stg_carmen_sightings__indian') }}
),
stg_carmen_sightings__pacific as (
    select * from {{ ref('stg_carmen_sightings__pacific') }}
)

select * from stg_carmen_sightings__africa
union all
select * from stg_carmen_sightings__america
union all
select * from stg_carmen_sightings__asia
union all
select * from stg_carmen_sightings__atlantic
union all
select * from stg_carmen_sightings__australia
union all
select * from stg_carmen_sightings__europe
union all
select * from stg_carmen_sightings__indian
union all
select * from stg_carmen_sightings__pacific