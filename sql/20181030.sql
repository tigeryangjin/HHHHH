select nvl(max(t.end_time),
           to_date('2016-07-19 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
--into i
  from stats_online_good_minute t;

select to_number(to_char(max(e.visit_date), 'yyyymmddhh24mi'))
--into i1
  from fact_page_view e
 where e.visit_date_key = to_number(to_char(sysdate, 'yyyymmdd'))
   and e.page_key in (1924, 2841, 24146, 11586, 355, 38629)
   and e.ip_geo_key != 0;
	 
SELECT TO_NUMBER(DATE'2018-10-31') FROM DUAL;

SELECT * FROM STATS_ONLINE_GOOD_MINUTE A WHERE A.STATDATE = 20181031;

SELECT *
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%STATS_ONLINE_GOOD_MINUTE%';

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processioshmsc'
 ORDER BY A.START_TIME DESC;
PROCESSGDREALTIME;
SELECT *
  FROM STATS_ONLINE_GOOD_MINUTE A
 WHERE A.STATDATE = 20181030
   AND A.GOOD_CODE = 203009;
