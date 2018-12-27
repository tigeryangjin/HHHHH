SELECT * FROM DIM_PAGE A WHERE A.PAGE_KEY=7781;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processpvpage'
--AND A.ETL_RECORD_INS > 0
 ORDER BY A.START_TIME DESC;

select distinct a.page_name,
                a.application_key,
                a.application_name,
                sysdate as insert_date
  from fact_page_view a
 where a.id between 1390963600 and 1390968091
   and not exists
 (select *
          from dim_page b
         where b.page_name = a.page_name
           and b.application_key = a.application_key);

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'HappigoSign'
   AND A.APPLICATION_KEY IS NULL
   AND A.VISIT_DATE_KEY = 20181218;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.APPLICATION_KEY IS NULL
   AND A.VISIT_DATE_KEY >= 20181201;
	 
SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.APPLICATION_NAME = 'wxlite_maill'
   AND A.VISIT_DATE_KEY = 20181219
 ORDER BY A.ID DESC;

SELECT * FROM FACT_PAGE_VIEW_VT;

SELECT * FROM DIM_APPLICATION;

SELECT *
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%INSERT%DIM_APPLICATION%';
 
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'SP_SBI_W_APPLICATION_D'
 ORDER BY A.START_TIME DESC;
 
BIHAPPIGO.SP_SBI_W_APPLICATION_D;

SELECT * FROM DIM_APPLICATION A;

SELECT *
  FROM DIM_APPLICATION@DW_DATALINK A
 WHERE NOT EXISTS (SELECT 1
          FROM DIM_APPLICATION B
         WHERE A.APPLICATION_NAME = B.APPLICATION_NAME);

INSERT INTO DIM_APPLICATION
  (ID,
   APPLICATION_KEY,
   APPLICATION_NAME,
   CREATE_DATE,
   APPLICATION__CN_NAME,
   CHANNEL_KEY,
   CHANNEL_NAME)
SELECT 
FROM DIM_APPLICATION@DW_DATALINK;

SELECT COUNT(1) FROM FACT_PAGE_VIEW A WHERE A.APPLICATION_KEY IS NULL;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.APPLICATION_KEY IS NULL
   AND A.VISIT_DATE_KEY >= 20181001;

