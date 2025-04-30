select 
    dd.month as month_of_year,
    da.region as top_agency_region,
    count(*) as no_of_sightings
from {{ ref('fact_Sighting') }} as fs
left join {{ ref('dim_Date') }} as dd
    on fs.date_witness = dd.date_day
left join {{ ref('dim_Agent') }} as da
    on fs.agent_id = da.agent_id
group by dd.month, da.region
qualify row_number() over (partition by dd.month order by count(*) desc) = 1
order by dd.month