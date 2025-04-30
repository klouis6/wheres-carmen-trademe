# wheres-carmen-trademe
Skill Assessment: dbt Analytics Engineer for TradeMe

This document provides SQL queries used to analyze sightings data of Ms. Carmen Sandiego. The analysis focuses on monthly trends, behaviors, and sightings patterns based on available fact and dimension tables in the `wheres_carmen_db.dbt_tmariono_mart` schema.

---

## a. Monthly Most Likely Agency Region for Sightings

**Question:**  
For each month, which agency region is Carmen Sandiego most likely to be found?

```sql
select 
    dd.month as month_of_year,
    da.region as top_agency_region,
    count(*) as no_of_sightings
from wheres_carmen_db.dbt_tmariono_mart.fact_sighting as fs
left join wheres_carmen_db.dbt_tmariono_mart.dim_date as dd
    on fs.date_witness_id = dd.date_day_id
left join wheres_carmen_db.dbt_tmariono_mart.dim_agent as da
    on fs.agent_id = da.agent_id
group by dd.month, da.region
qualify row_number() over (partition by dd.month order by count(*) desc) = 1
order by dd.month;
```

---

## b. Probability of Being Armed, Wearing Jacket, but Not a Hat

**Question:**  
Also for each month, what is the probability that Ms. Sandiego is armed AND wearing a jacket, but NOT a hat?

```sql
select
    dd.month as month_of_year,
    round(
        count_if(fs.has_weapon = true and fs.has_jacket = true and fs.has_hat = false) 
        / count(*)::float, 4
    ) as probability_armed_jacket_no_hat,
    probability_armed_jacket_no_hat * 100 as perc_probability_armed_jacket_no_hat
from wheres_carmen_db.dbt_tmariono_mart.fact_sighting as fs
left join wheres_carmen_db.dbt_tmariono_mart.dim_date as dd
    on fs.date_witness_id = dd.date_day_id
group by dd.month
order by dd.month;
```

---

## c. Top 3 Most Occurring Behaviors

**Question:**  
What are the three most occurring behaviors of Ms. Sandiego?

```sql
select
    db.behavior,
    count(*) as count_behavior
from wheres_carmen_db.dbt_tmariono_mart.fact_sighting as fs
left join wheres_carmen_db.dbt_tmariono_mart.dim_behavior as db
    on fs.behavior_id = db.behavior_id
group by db.behavior
order by count_behavior desc
limit 3;
```

---

## d. Monthly Probability of Top 3 Behaviors

**Question:**  
For each month, what is the probability Ms. Sandiego exhibits one of her three most occurring behaviors?

```sql
with top_behavior as (
    select
        db.behavior_id
    from wheres_carmen_db.dbt_tmariono_mart.fact_sighting as fs
    left join wheres_carmen_db.dbt_tmariono_mart.dim_behavior as db
        on fs.behavior_id = db.behavior_id
    group by db.behavior_id
    order by count(*) desc
    limit 3
)

select
    dd.month as month_of_year,
    round(
        count_if(fs.behavior_id in (select behavior_id from top_behavior)) 
        / count(*)::float, 4
    ) as probability_top3_behaviors,
    round(
        count_if(fs.behavior_id in (select behavior_id from top_behavior)) 
        / count(*)::float * 100, 2
    ) as perc_probability_top3_behaviors
from wheres_carmen_db.dbt_tmariono_mart.fact_sighting as fs
left join wheres_carmen_db.dbt_tmariono_mart.dim_date as dd
    on fs.date_witness_id = dd.date_day_id
group by dd.month
order by dd.month;
```

---
