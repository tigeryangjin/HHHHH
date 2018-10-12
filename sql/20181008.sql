SELECT A.CREATEON,
       A.ID,
       A.VID,
       A.MID,
       A.V,
       A.T,
       A.HMSC,
       A.HMMD,
       A.HMPL,
       A.HMKW,
       A.HMCI,
       A.URL,
       A.QUERY,
       A.AGENT,
       A.IP,
       A.A,
       A.VER,
       A.P,
       A.ISPROCESSED
  FROM ODSHAPPIGO.ODS_PAGEVIEW A
 ORDER BY A.ID DESC;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'createpaveviewfact'
   AND A.START_TIME >= DATE '2018-10-08'
 ORDER BY A.START_TIME DESC;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processpvpage'
 ORDER BY A.START_TIME DESC;

--1987514
--2347554

SELECT COUNT(1) FROM ODSHAPPIGO.ODS_PAGEVIEW A WHERE A.ISPROCESSED = 0;

SELECT MAX(A.ID) FROM FACT_PAGE_VIEW A;

SELECT * FROM FACT_PAGE_VIEW A WHERE A.ID >= 1290228454 - 10000;

SELECT /*+INDEX(FPV_ID)*/
 MIN(a.id), MAX(a.id)
  FROM DW_USER.fact_page_view a
 WHERE a.page_key = 0
   AND a.id > 1290000000 - 100000000;

/*
1290246456
1290000000
*/

SELECT MAX(ID) FROM DW_USER.FACT_PAGE_VIEW;

SELECT *
  FROM fact_page_view a
 WHERE a.page_key = 0
   AND a.id > 1290000000;

SELECT * FROM ALL_OBJECTS A WHERE A.OBJECT_NAME = 'FACT_PAGE_VIEW';

select min(a.id), max(a.id)
  from fact_page_view a
 where a.page_key = 0
   and a.id > 1280000000;

select min(a.id), max(a.id)
  from fact_page_view a
 where a.page_key = 0
   and a.id > (select max(b.id) - 100000 from fact_page_view b);

SELECT * FROM fact_page_view A WHERE A.VISIT_DATE_KEY = 20180920;
createpaveviewfact;

SELECT TRUNC(A.CREATEON) CREATEON, COUNT(1)
  FROM ODSHAPPIGO.ODS_PAGEVIEW A
 WHERE A.CREATEON >= DATE '2018-09-10'
 GROUP BY TRUNC(A.CREATEON);

select 65927644, 64324788 + 1602856 + 22908 from dual;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'YANGJIN_PKG.OPER_MEMBER_NOT_IN_EC'
 ORDER BY A.START_TIME DESC;

SELECT *
  FROM ODSHAPPIGO.ODS_PAGEVIEW A
 WHERE A.ISPROCESSED = 0
 ORDER BY A.ID;
 
SELECT * FROM DBA_TABLES A WHERE A.TABLE_NAME = 'ODS_PAGEVIEW';
SELECT * FROM DBA_SEGMENTS A WHERE A.segment_name='ODS_PAGEVIEW';

SELECT (191015082 * 376) / 1024 / 1024,
       86419439616 / 1024 / 1024,
       82416 - 68494.4828338623,
       13921.5171661377 / 82416
  FROM DUAL;

SELECT * FROM W_ETL_LOG A ORDER BY A.START_TIME DESC;

createpaveviewfact;
processpvpage;

select * from fact_page_view a where a.visit_date_key>=20181010 order by a.id desc;

select * from w_etl_log a where a.start_time is null;
select count(1) from w_etl_log;

delete w_etl_log a where a.start_time is null;
commit;

select * from w_etl_log a order by a.start_time;

delete w_etl_log a where a.start_time<date'2018-01-01';
commit;
