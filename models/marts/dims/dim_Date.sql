with raw_generated_data as (
    {{ dbt_date.get_date_dimension("1980-01-01", "2030-12-31") }}
)

select 
    date_day,
    year_number as year,
    month_of_year as month,
    day_of_month as day
from raw_generated_data
