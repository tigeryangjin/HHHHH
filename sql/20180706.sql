SELECT A.MEMBER_KEY,
       COUNT(A.ORDER_OBJ_ID) ORDER_COUNT,
       SUM(A.ORDER_AMOUNT) ORDER_AMOUNT
  FROM (SELECT T.POSTING_DATE_KEY,
               T.ORDER_OBJ_ID,
               T.MEMBER_KEY,
               T.ORDER_AMOUNT
          FROM FACT_ORDER T
         WHERE T.POSTING_DATE_KEY = 20180718 /*��������*/
           AND T.SALES_SOURCE_KEY = 20 /*��ý��ͨ·*/
           AND T.ORDER_STATE = 1
           AND EXISTS (SELECT 1
                  FROM yangjin.member_tmp C
                 WHERE T.MEMBER_KEY = C.MEMBER_KEY)) A
 GROUP BY A.MEMBER_KEY;

SELECT COUNT(B.MEMBER_KEY) MEMBER_COUNT, SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
  FROM (SELECT A.MEMBER_KEY,
               COUNT(A.ORDER_OBJ_ID) ORDER_COUNT,
               SUM(A.ORDER_AMOUNT) ORDER_AMOUNT
          FROM (SELECT T.POSTING_DATE_KEY,
                       T.ORDER_OBJ_ID,
                       T.MEMBER_KEY,
                       T.ORDER_AMOUNT
                  FROM FACT_ORDER T
                 WHERE T.POSTING_DATE_KEY = 20180718 /*��������*/
                   AND T.SALES_SOURCE_KEY = 20 /*��ý��ͨ·*/
                   AND T.ORDER_STATE = 1
                   AND EXISTS
                 (SELECT 1
                          FROM yangjin.member_tmp C
                         WHERE T.MEMBER_KEY = C.MEMBER_KEY)) A
         GROUP BY A.MEMBER_KEY) B;

SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%FACT_ORDER%';

CREATEORDERGOODS;
PROCESSUPDATEORDER;

SELECT D.ADD_TIME, D.VID, D.CUST_NO, E.ERP_CODE
  FROM FACT_EC_ORDER_2 D, FACT_EC_ORDER_GOODS E
 WHERE D.ORDER_ID = E.ORDER_ID
   AND D.ADD_TIME BETWEEN DATE '2018-07-17' AND DATE
 '2018-07-19'
   AND D.VID = 'webportal0f09f94450a99f1c9035c4e23ef0e9fb';

SELECT A.DATE_KEY, COUNT(1)
  FROM fact_daily_goodsresource_1 A
 GROUP BY A.DATE_KEY
 ORDER BY A.DATE_KEY;

SELECT * FROM fact_daily_goodsresource_1 A WHERE A.DATE_KEY >= 20180718;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processgoodresource1'
 ORDER BY A.START_TIME DESC;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY = 20180718
   AND A.PAGE_NAME = 'KFZT';

SELECT * FROM new_ztmm023;

SELECT * FROM OPER_EC_PRODUCT_SUMMARY_REPORT A WHERE A.ITEM_CODE = 241583;
SELECT * FROM OPER_EC_PRODUCT_SUMMARY_TMP A WHERE A.ITEM_CODE = 241583;

SELECT DISTINCT A.W_UPDATE_DT
  FROM OPER_EC_PRODUCT_SUMMARY_REPORT A
 ORDER BY A.W_UPDATE_DT DESC;

SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%FACT_PV_IA_HMSC%';

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'YJ_REPORT.OPER_EC_PRODUCT_SUMMARY_PROC'
 ORDER BY A.START_TIME DESC;

SELECT A.ERP_CODE, COUNT(1)
  FROM OPER_EC_PRODUCT_SUMMARY_TMP A
 GROUP BY A.ERP_CODE
HAVING COUNT(1) > 1;

--DIM_GOOD_COST�ظ�ֵ
SELECT A.ITEM_CODE, COUNT(1)
  FROM DIM_GOOD_COST A
 GROUP BY A.ITEM_CODE
HAVING COUNT(1) > 1;

SELECT A.ITEM_CODE, COUNT(1)
  FROM (SELECT DISTINCT A1.ITEM_CODE, A1.COST_PRICE FROM DIM_GOOD_COST A1) A
 GROUP BY A.ITEM_CODE
HAVING COUNT(1) > 1;

SELECT * FROM DIM_GOOD_COST A WHERE A.ITEM_CODE = 173634;

SELECT '10.10.204.27' IP, 'dw_user' "USER", A.PNAME, A.PTYPE, A.DEVELOPER
  FROM S_PARAMETERS2 A
 WHERE UPPER(A.DEVELOPER) = 'YANGJIN'
   AND NOT EXISTS (SELECT 1
          FROM W_ETL_LOG B
         WHERE A.PNAME = B.PROC_NAME
           AND B.START_TIME >= SYSDATE - 1);

SELECT * FROM FACT_VISITOR_REGISTER;

SELECT MAX(A.PERIOD) FROM data_acquisition_item A;

SELECT /*+PARALLEL(8)*/
 A.PERIOD, COUNT(1)
  FROM data_acquisition_item A
 GROUP BY A.PERIOD
 ORDER BY A.PERIOD DESC;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'YANGJIN_PKG.DATA_ACQUISITION_ITEM_BASE'
 ORDER BY A.START_TIME DESC;

SELECT A.DATA_SOURCE,
       A.PERIOD,
       A.ACQ_CATEGORY_NAME,
       A.MATDLT,
       A.MATZLT,
       A.MATXLT,
       A.ACQ_ITEM_CODE,
       A.ACQ_NAME,
       A.ACQ_URL,
       A.ACQ_PIC,
       A.ACQ_SHOP_NAME,
       A.ACQ_PRICE,
       A.ACQ_SALES,
       A.SALES_AMT,
       A.INSERT_DATE,
       A.VALID_FLAG
  FROM data_acquisition_item A
 WHERE A.PERIOD = 20180702
   AND A.PERIOD IS NOT NULL;

SELECT COUNT(1) FROM data_acquisition_item_base;