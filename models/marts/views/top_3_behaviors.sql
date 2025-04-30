select
    fs.behavior_id,
    db.behavior,
    count(*) as count_behavior
from {{ ref('fact_Sighting') }} fs
left join {{ ref('dim_Behavior') }} db
    on fs.behavior_id = db.behavior_id
group by fs.behavior_id, db.behavior
qualify row_number() over (order by count(*) desc) <= 3
order by count_behavior desc