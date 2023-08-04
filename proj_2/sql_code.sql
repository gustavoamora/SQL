WITH last_month AS (
  SELECT 
      customer_name,
      SUM(sms_sent) AS volume_last_month
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
    SUM(v.sms_sent) AS sms_sent,
    ROUND(100 * SUM(v.sms_sent) / t.volume_last_month, 2) AS percentual_volume
FROM
    my_table v
JOIN
    last_month t
ON
    v.customer_name = t.customer_name
WHERE
    v.message_date >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH) -- primeiro dia do mês anterior
    AND v.message_date < DATE_TRUNC(CURRENT_DATE(), MONTH) -- primeiro dia do mês atual
GROUP BY
    v.customer_name,
    v.carrier_name,
    t.volume_last_month;
