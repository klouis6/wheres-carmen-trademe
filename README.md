# wheres-carmen-trademe  
**Skill Assessment: dbt Analytics Engineer for TradeMe**

This document provides an overview of the dbt models used to analyze sightings data of Ms. Carmen Sandiego. The analysis focuses on monthly trends, behaviors, and sightings patterns based on the fact and dimension tables in the `mart` schema.

---

# dbt DAG - Final


---

## 📈 Analytics

In this section, we answer critical questions about Ms. Carmen Sandiego's whereabouts and behavior patterns using dbt models located in the `models/marts/views` folder. Each SQL model encapsulates the logic needed to answer the respective analytical questions.

### a. Monthly Most Likely Agency Region for Sightings

**Question:**  
For each month, which agency region is Carmen Sandiego most likely to be found?

**Logic / Approach:**  
To determine the most likely region where Carmen is sighted each month:
1. We join the `fact_Sighting` model with `dim_Date` to get the month of each sighting.
2. We join with `dim_Agent` to obtain the agent's region.
3. We count the number of sightings per region for each month.
4. We use a `ROW_NUMBER()` window function to select only the top region with the highest count per month.

This ensures that for each month, we return only one region — the one with the most sightings of Ms. Sandiego.

**Model:** [most_likely_region_by_month.sql](models/marts/views/most_likely_region_by_month.sql)

**SQL:**
```sql
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
```

---

### b. Probability of Being Armed, Wearing Jacket, but Not a Hat

**Question:**  
Also for each month, what is the probability that Ms. Sandiego is armed AND wearing a jacket, but NOT a hat? What general observations about Ms. Sandiego can you make from this?

**Logic / Approach:**  
To calculate this monthly probability:
1. We start from the `fact_Sighting` table and join it with `dim_Date` to get the month.
2. We apply a `COUNT_IF` condition to count only the sightings where Carmen:
   - Is armed (`has_weapon = true`)
   - Is wearing a jacket (`has_jacket = true`)
   - Is **not** wearing a hat (`has_hat = false`)
3. We divide the conditional count by the total count for that month to get the probability.
4. The result is presented both as a decimal (0–1) and as a percentage (0–100%).

**Model:** [probability_armed_jacket_no_hat.sql](models/marts/views/probability_armed_jacket_no_hat.sql)

**SQL Logic:**
```sql
select
    dd.month as month_of_year,
    round(
        count_if(fs.has_weapon = true and fs.has_jacket = true and fs.has_hat = false) 
        / count(*)::float, 4
    ) as probability_armed_jacket_no_hat,
    round(
        count_if(fs.has_weapon = true and fs.has_jacket = true and fs.has_hat = false) 
        / count(*)::float * 100, 2
    ) as perc_probability_armed_jacket_no_hat
from {{ ref('fact_Sighting') }} fs
left join {{ ref('dim_Date') }} dd
    on fs.date_witness = dd.date_day
group by dd.month
order by dd.month
```

---

### c. Top 3 Most Occurring Behaviors

**Question:**  
What are the three most occurring behaviors of Ms. Sandiego?

**Logic / Approach:**  
To identify her most common behaviors:
1. We start from the `fact_Sighting` model and join with `dim_Behavior` to get readable behavior descriptions.
2. We group by `behavior_id` and `behavior`, and count how many times each behavior occurred.
3. We use a `ROW_NUMBER()` window function (ordered by count descending) to rank the behaviors.
4. We filter to keep only the **top 3** most frequent ones.

**Model:** [top_3_behaviors.sql](models/marts/views/top_3_behaviors.sql)

**SQL Logic:**
```sql
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
```

---

### d. Monthly Probability of Top 3 Behaviors

**Question:**  
For each month, what is the probability Ms. Sandiego exhibits one of her three most occurring behaviors?

**Logic / Approach:**  
To identify her most common behaviors:
1. We start from getting the top 3 occuring behaviors from 'top_3_behaviors' model.
2. We apply a `COUNT_IF` condition to count only the behaviors where exist in 'top_3_behaviors' model.
3. We divide the conditional count by the total count for that month to get the probability.
4. The result is presented both as a decimal (0–1) and as a percentage (0–100%).

**Model:** [probability_top3_behaviors_by_month.sql](models/marts/views/probability_top3_behaviors_by_month.sql)

**SQL Logic:**
```sql
with top_behavior as (
    select *
    from {{ ref('top_3_behaviors') }}
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
from {{ ref('fact_Sighting') }} fs
left join {{ ref('dim_Date') }} dd
    on fs.date_witness = dd.date_day
left join top_behavior tb
    on fs.behavior_id = tb.behavior_id
group by dd.month
order by dd.month
```

---

> All models are powered by the marts layer and make use of underlying dimension and fact tables.
