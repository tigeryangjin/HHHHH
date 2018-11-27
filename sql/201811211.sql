SELECT 24*300 FROM DUAL;
--STATS_ONLINE_GOOD2_MINUTE�ظ�ֵ����
SELECT A.STATDATE,
       A.STATHOUR,
       A.STATMINUTE,
       A.START_TIME,
       A.END_TIME,
       A.APPLICATION_KEY,
       A.APPLICATION_NAME,
       A.GOOD_CODE,
       A.GOOD_NAME,
       A.PAGE_NAME,
       A.PAGE_VALUE,
       A.PV,
       A.UV,
       COUNT(1)
  FROM STATS_ONLINE_GOOD2_MINUTE A
 GROUP BY A.STATDATE,
          A.STATHOUR,
          A.STATMINUTE,
          A.START_TIME,
          A.END_TIME,
          A.APPLICATION_KEY,
          A.APPLICATION_NAME,
          A.GOOD_CODE,
          A.GOOD_NAME,
          A.PAGE_NAME,
          A.PAGE_VALUE,
          A.PV,
          A.UV
HAVING COUNT(1) > 1;

SELECT A.ID,
       A.STATDATE,
       A.STATHOUR,
       A.STATMINUTE,
       A.START_TIME,
       A.END_TIME,
       A.APPLICATION_KEY,
       A.APPLICATION_NAME,
       A.GOOD_CODE,
       A.GOOD_NAME,
       A.PAGE_NAME,
       A.PAGE_VALUE,
       A.PV,
       A.UV,
       ROW_NUMBER() OVER(PARTITION BY A.STATDATE, A.STATHOUR, A.STATMINUTE, A.START_TIME, A.END_TIME, A.APPLICATION_KEY, A.APPLICATION_NAME, A.GOOD_CODE, A.GOOD_NAME, A.PAGE_NAME, A.PAGE_VALUE, A.PV, A.UV ORDER BY A.ID) RN
  FROM STATS_ONLINE_GOOD2_MINUTE A
	WHERE A.STATDATE=20180819;



SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME IN ('processgdrealtime', 'processgdrealtime2')
 ORDER BY A.START_TIME DESC;

--PROCESSGDREALTIME
--PROCESSGDREALTIME2
SELECT NVL(A.END_TIME,
           TO_DATE('2016-07-19 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
  FROM STATS_ONLINE_GOOD_MINUTE A
 WHERE EXISTS (SELECT 1
          FROM (SELECT MAX(C.ID) ID FROM STATS_ONLINE_GOOD_MINUTE C) B
         WHERE A.ID = B.ID);

SELECT NVL(A.END_TIME,
           TO_DATE('2016-07-19 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
  FROM STATS_ONLINE_GOOD2_MINUTE A
 WHERE EXISTS (SELECT 1
          FROM (SELECT MAX(C.ID) ID FROM STATS_ONLINE_GOOD2_MINUTE C) B
         WHERE A.ID = B.ID);

SELECT MAX(A.END_TIME) FROM STATS_ONLINE_GOOD2_MINUTE A;
--76822769
SELECT * FROM STATS_ONLINE_GOOD2_MINUTE A WHERE A.STATDATE = 20181122;

SELECT * FROM STATS_ONLINE_GOOD2_MINUTE A WHERE A.ID = 79583337;

SELECT DISTINCT A.STATDATE
  FROM STATS_ONLINE_GOOD2_MINUTE A
 ORDER BY A.STATDATE;

select nvl(max(t.end_time),
           to_date('2016-07-19 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
  into i
  from stats_online_good_minute t;

SELECT MAX(A.ID) MAX_ID FROM stats_online_good_minute A;
SELECT MAX(A.ID) FROM stats_online_good2_minute A;

SELECT * FROM stats_online_good_minute A WHERE A.ID = 68521918;
SELECT * FROM stats_online_good2_minute A WHERE A.ID = 76822214;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processgdrealtime'
 ORDER BY A.START_TIME DESC;

--PROCESSGOODPAGE
SELECT DISTINCT A.name
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%INSERT%STATS_ONLINE_GOOD_MINUTE%'
   AND A.OWNER = 'DW_USER';

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY >= 20181121
   AND A.PAGE_KEY = 0
 ORDER BY A.ID;

select nvl(max(t.end_time),
           to_date('2016-07-19 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
--into i
  from stats_online_good_minute t;

select nvl(to_number(to_char(max(e.visit_date), 'yyyymmddhh24mi')),
           20160719000000)
--into i1
  from fact_page_view e
 where e.visit_date_key >= to_number(to_char(sysdate - 1, 'yyyymmdd'))
   and e.page_key in (1924, 2841, 24146, 11586, 355, 38629)
   and e.ip_geo_key != 0;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processgdrealtime2'
 ORDER BY A.START_TIME DESC;

select to_number(to_char(nvl(max(t.end_time),
                             to_date('2016-07-19 00:00:00',
                                     'yyyy-mm-dd hh24:mi:ss')) +
                         10 / 24 / 60,
                         'yyyymmddhh24mi'))
--into i
  from stats_online_good2_minute t;

select nvl(to_number(to_char(max(e.visit_date), 'yyyymmddhh24mi')),
           20160719000000)
--into i1
  from fact_page_view e
 where e.visit_date_key = to_number(to_char(sysdate, 'yyyymmdd'))
   and e.page_key in (1924, 2841, 24146, 11586, 355, 38629)
   and e.ip_geo_key != 0;

--processgdrealtime2

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'createpaveviewfact'
 ORDER BY A.START_TIME DESC;

SELECT A.ID, COUNT(1)
  FROM fact_page_view A
 WHERE A.VISIT_DATE_KEY >= 20181121
 GROUP BY A.ID
HAVING COUNT(1) > 1;

SELECT * FROM fact_page_view A WHERE A.ID = 1360587908;

--
SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%INSERT%DIM_VER%';

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processpagerelation'
 ORDER BY A.START_TIME DESC;

SELECT *
  FROM YJ_DAILY_CHECK_ERR_V T
 WHERE T.PROC_NAME NOT IN ('processpvvisitor',
                           'processvidscan',
                           'createsearchfact',
                           'processver',
                           'processpagerelation',
                           'processgoodpage');

--PROCESSPVVISITOR
SELECT *
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%INSERT%FACT_VISITOR_REGISTER%';

SELECT MIN(A.ID)
  FROM FACT_PAGE_VIEW A
 WHERE A.ID > 384785523
   AND A.DEVICE_KEY = 0;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'createsearchfact'
 ORDER BY A.START_TIME DESC;

SELECT *
  FROM YJ_DAILY_CHECK_ERR_V T
 WHERE T.PROC_NAME NOT IN ('processpvvisitor', 'processvidscan');

update dim_vid_scan g1
   set g1.active_date_key =
       (select k1.create_date_key
          from fact_visitor_register k1
         where k1.vid = g1.vid)
 where g1.scan_date_key = 20181121;

update dim_vid_scan l2
   set l2.is_new = 1
 where l2.scan_date_key = 20181121
   and l2.scan_date_key = l2.active_date_key;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processvidscan'
 ORDER BY A.START_TIME DESC;

--FACT_VISITOR_REGISTER�ظ�ֵ
CREATE TABLE YANGJIN.VISTOR_TMP AS
  SELECT A.VID, MAX(A.ID) MAX_ID, MAX(A.VISTOR_KEY) MAX_VISTOR_KEY
    FROM FACT_VISITOR_REGISTER A
   WHERE A.CREATE_DATE_KEY = 20181121
   GROUP BY A.VID
  HAVING COUNT(1) > 1;

DELETE FACT_VISITOR_REGISTER A
 WHERE EXISTS (SELECT 1
          FROM YANGJIN.VISTOR_TMP B
         WHERE A.VID = B.VID
           AND A.ID = B.MAX_ID);

SELECT * FROM YANGJIN.VISTOR_TMP;

SELECT * FROM FACT_VISITOR_REGISTER A;

update fact_page_view hh
   set hh.DEVICE_KEY =
       (select k.VISTOR_KEY
          from FACT_VISITOR_REGISTER k
         where k.vid = hh.vid)
 where hh.id between 120360272 and 120386092
      /*yangjin 2018-10-26*/
   and hh.device_key = 0;

update fact_session aa
   set aa.visitor_key =
       (select k.VISTOR_KEY
          from FACT_VISITOR_REGISTER k
         where k.vid = aa.vid)
 where aa.id between 120360272 and 120386092;

SELECT A.VID, COUNT(1)
  FROM FACT_VISITOR_REGISTER A
 WHERE EXISTS (SELECT 1
          FROM fact_session B
         WHERE A.VID = B.VID
           AND B.ID between 120360272 and 120386092)
 GROUP BY A.VID;

SELECT *
  FROM FACT_VISITOR_REGISTER A
 WHERE A.VID = '0329823b49463de15e8536e752ce00f8';

SELECT * FROM fact_session A WHERE A.ID between 120360272 and 120386092;

select min(a.id) as smin, max(a.id) as smax
  from fact_session a
 where a.Visitor_Key = 0;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processpvvisitor'
 ORDER BY A.START_TIME DESC;

/*
SNS_BlogList_Recommend
SNS_Blog_Edit
*/
SELECT *
  FROM FACT_PAGE_VIEW SUBPARTITION(FPV201811) A
 WHERE A.PAGE_NAME IN ('SNS_BlogList_Recommend', 'SNS_Blog_Edit');
