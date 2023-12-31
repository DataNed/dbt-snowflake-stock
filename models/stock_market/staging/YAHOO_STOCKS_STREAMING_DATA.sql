--Set target properties
{{ config(
    database='DBT_STAGING',
    tags=["stocks_streaming"],
    pre_hook="ALTER EXTERNAL TABLE DBT_RAW.LANDING_ZONE.INTRADAY_STREAMING REFRESH" 
) }}

SELECT
SYMBOL
, TO_TIMESTAMP_NTZ(
    CASE 
      WHEN LENGTH(TRIM(TIMESTAMP)) = 7 THEN TIMESTAMP || '-01'
      WHEN LENGTH(TRIM(TIMESTAMP)) = 10 THEN TIMESTAMP
      ELSE NULL
    END
  ) AS INGESTED_TIME
,TRY_CAST(OPEN AS NUMBER) AS OPEN
,TRY_CAST(HIGH AS NUMBER) AS HIGH
,TRY_CAST(LOW AS NUMBER) AS LOW
,TRY_CAST(CLOSE AS NUMBER) AS CLOSE
,TRY_CAST(VOLUME AS NUMBER) AS VOLUME
FROM
DBT_RAW.LANDING_ZONE.INTRADAY_STREAMING

