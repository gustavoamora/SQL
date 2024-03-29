SELECT country_code,
       country_name, 
       DATE_TRUNC(date, ISOWEEK) AS isoweek_date, 
       EXTRACT(ISOWEEK FROM date) AS isoweek_of_year,
       SUM(new_confirmed) AS confirmed,
       LAG(SUM(new_confirmed), 1) OVER (ORDER BY MAX(date)) AS confirmed_previous_week,
       (SUM(new_confirmed) - LAG(SUM(new_confirmed), 1) OVER (ORDER BY MAX(date))) AS confirmed_difference,
       SUM(new_deceased) AS deceased,    
       LAG(SUM(new_deceased), 1) OVER (ORDER BY MAX(date)) AS deceased_previous_week,
       (SUM(new_deceased) - LAG(SUM(new_deceased), 1) OVER (ORDER BY MAX(date))) AS deceased_difference           
FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE country_code = 'MQ'
GROUP BY 1, 2, 3, 4 
ORDER BY 3
