SELECT * FROM DIM_PAGE;
SELECT * FROM FACT_PAGE_VIEW A WHERE A.VISIT_DATE_KEY=20180417;
SELECT * FROM FACT_PAGE_VIEW_HIT;
SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%INSERT%FACT_PAGE_VIEW%';

SELECT A.VISIT_DATE_KEY, COUNT(A.VID) PV, COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY BETWEEN 20170101 AND 20170417
 GROUP BY A.VISIT_DATE_KEY;

160213
000934
003243
