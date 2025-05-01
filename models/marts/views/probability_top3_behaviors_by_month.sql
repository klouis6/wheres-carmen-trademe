with top_behavior as (
    select *
    from {{ ref('top_3_behaviors') }}
)

select
    dd.month as month_of_year,
    round(
        count_if(fs.behavior_id in (select behavior_id from top_behavior)) 
        / count(*)::float, 4
    ) as probability_top3_behaviors
from {{ ref('fact_Sighting') }} fs
left join {{ ref('dim_Date') }} dd
    on fs.date_witness = dd.date_day
left join top_behavior tb
    on fs.behavior_id = tb.behavior_id
group by dd.month