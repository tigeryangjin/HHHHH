/*
processstatvtminute
processstatvtminute5
processstatvtminute30

10:app-ios
20:app-android
30:3G
40:¹ÙÍø
50:Î¢ĞÅ

*/

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processstatvtminute'
 ORDER BY A.START_TIME DESC;
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processstatvtminute5'
 ORDER BY A.START_TIME DESC;
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processstatvtminute'
 ORDER BY A.START_TIME DESC;


SELECT *
  FROM STATS_ONLINE_VISITOR_MINUTE A
 WHERE A.STATDATE = 20181102
 AND A.FREQUENCY=1
 ORDER BY A.ID DESC;

select --w_statid_s.nextval,
 Z2.APPLICATION_KEY,
 CASE
   WHEN Z2.APPLICATION_KEY = 10 THEN
    'app-ios'
   WHEN Z2.APPLICATION_KEY = 20 THEN
    'app-android'
   WHEN Z2.APPLICATION_KEY = 30 THEN
    '3G'
   WHEN Z2.APPLICATION_KEY = 40 THEN
    '¹ÙÍø'
   WHEN Z2.APPLICATION_KEY = 50 THEN
    'Î¢ĞÅ'
 END application_name,
 to_number(to_char(&i + 1 / 24 / 60, 'yyyymmdd')) as realdate,
 to_number(to_char(&i + 1 / 24 / 60, 'hh24')) as realhour,
 to_number(to_char(&i + 1 / 24 / 60, 'mi')) as realminute,
 to_date(to_char(&i, 'yyyy-mm-dd hh24:mi'), 'yyyy-mm-dd hh24:mi:ss') as start_time,
 to_date(to_char(&i + 1 / 24 / 60, 'yyyy-mm-dd hh24:mi'),
         'yyyy-mm-dd hh24:mi:ss') as end_time,
 z2.uvcount,
 1
  from (select P3.APPLICATION_KEY, nvl(count(distinct p3.vid), 1) as uvcount
        
          from fact_page_view_vt p3
         where p3.visit_date >= &i
           and p3.visit_date < &i + 1 / 24 / 60
           and p3.application_key IN (10, 20, 30, 40, 50)
         GROUP BY P3.APPLICATION_KEY) z2;

SELECT DISTINCT A.APPLICATION_KEY
  FROM fact_page_view_vt A
 WHERE A.VISIT_DATE_KEY = 20181101;

SELECT *
  FROM STATS_ONLINE_VISITOR_MINUTE A
 WHERE A.STATDATE = 20181102
 ORDER BY A.APPLICATION_KEY, A.STATHOUR, A.STATMINUTE, A.FREQUENCY;
