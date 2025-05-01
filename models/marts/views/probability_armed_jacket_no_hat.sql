select
    dd.month as month_of_year,
    round(
        count_if(fs.has_weapon and fs.has_jacket and not fs.has_hat) 
        / count(*)::float, 4
    ) as probability_armed_jacket_no_hat
from {{ ref('fact_Sighting') }} fs
left join {{ ref('dim_Date') }} dd
    on fs.date_witness = dd.date_day
group by dd.month