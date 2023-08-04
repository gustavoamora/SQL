WITH ultimo_mes AS (
  SELECT 
      database_name,
      SUM(mt_total) AS mt_total_mes_anterior
  FROM
      `wavy-business-analytics.big_numbers_sms.SMS_OLAP`
  WHERE
      message_date >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH) 
      AND message_date < DATE_TRUNC(CURRENT_DATE(), MONTH) 
  GROUP BY
      database_name
)

SELECT 
    v.database_name,
    v.carrier_name,
    MAX(v.message_date) AS message_date,
    SUM(v.mt_total) AS mt_total,
    ROUND(100 * SUM(v.mt_total) / t.mt_total_mes_anterior, 2) AS percentual_volume
FROM
    `wavy-business-analytics.big_numbers_sms.SMS_OLAP` v
JOIN
    TotaisMesAnterior t
ON
    v.database_name = t.database_name
WHERE
    v.message_date >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH) -- primeiro dia do mês anterior
    AND v.message_date < DATE_TRUNC(CURRENT_DATE(), MONTH) -- primeiro dia do mês atual
GROUP BY
    v.database_name,
    v.carrier_name,
    t.mt_total_mes_anterior;
