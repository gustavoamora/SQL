WITH last_month AS (
  SELECT 
      customer_name,
      SUM(mt_total) AS total_last_month
  FROM
      my_table
  WHERE
      message_date >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH) 
      AND message_date < DATE_TRUNC(CURRENT_DATE(), MONTH) 
  GROUP BY
      customer_name
)

SELECT 
    v.customer_name,
    v.carrier_name,
    MAX(v.message_date) AS message_date,
    SUM(v.mt_total) AS mt_total,
    ROUND(100 * SUM(v.mt_total) / t.total_last_month, 2) AS percentual_volume
FROM
    my_table v
JOIN
    last_month t
ON
    v.customer_name = t.customer_name
WHERE
    v.message_date >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH) 
    AND v.message_date < DATE_TRUNC(CURRENT_DATE(), MONTH) 
GROUP BY
    v.customer_name,
    v.carrier_name,
    t.total_last_month;
