--1.
SELECT A.VISIT_DATE_KEY, COUNT(1)
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY >= 20181110
 GROUP BY A.VISIT_DATE_KEY;

--2.
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'createpaveviewfact'
 ORDER BY A.START_TIME DESC;

--tmp
SELECT *
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%INSERT %FACT_PAGE_VIEW%';
CREATEPAVEVIEWFACT;

