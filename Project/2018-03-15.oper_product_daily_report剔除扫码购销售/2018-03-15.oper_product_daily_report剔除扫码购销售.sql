--***************************************************************************************
--OPER_PRODUCT_DAILY_REPORT剔除扫码购销售
--***************************************************************************************
--1.
SELECT A.POSTING_DATE_KEY, COUNT(1)
  FROM FACT_GOODS_SALES A
 GROUP BY A.POSTING_DATE_KEY
 ORDER BY A.POSTING_DATE_KEY;

SELECT A.POSTING_DATE_KEY, COUNT(1)
  FROM FACT_GOODS_SALES_REVERSE A
 GROUP BY A.POSTING_DATE_KEY
 ORDER BY A.POSTING_DATE_KEY;

SELECT A.POSTING_DATE_KEY, COUNT(1)
  FROM OPER_PRODUCT_DAILY_REPORT A
 GROUP BY A.POSTING_DATE_KEY
 ORDER BY A.POSTING_DATE_KEY;

--2.fact_ec_order_2修复
UPDATE FACT_EC_ORDER_2 A
   SET A.CRM_ORDER_NO = A.ERP_ORDER_NO
 WHERE SUBSTR(A.ERP_ORDER_NO, 1, 2) = 51
   AND A.CRM_ORDER_NO IS NULL;
COMMIT;


--3.从20160101开始全部刷新
/*
ods_order.ZTCRMC04 = FACT_GOODS_SALES.ORDER_KEY 订单权责制编号
ods_order.crm_obj_id = FACT_GOODS_SALES.ORDER_H_KEY 订单发生制编号
*/
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2016-01-01';
  END_DATE    DATE := DATE '2016-01-31';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT(IN_DATE_INT);
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

  SELECT A.START_TIME,
         A.END_TIME,
         A.ETL_DURATION,
         A.PROC_NAME,
         A.ETL_RECORD_INS,
         A.ETL_RECORD_UPD,
         A.ETL_STATUS,
         A.ERR_MSG
    FROM W_ETL_LOG A
   WHERE A.PROC_NAME = 'YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT'
   ORDER BY A.START_TIME DESC;

--***************************************************************************************
--OPER_PRODUCT_SCAN_DLY_REPORT扫码购销售
--***************************************************************************************


--tmp
select * from s_parameters2 for update;
select count(1)
  from fact_goods_sales a
 where a.posting_date_key = 20160101;
select count(1)
  from fact_goods_sales a
 where a.posting_date_key = 20160101
   and not exists (select 1
          from fact_ec_order_2 b
         where a.order_key = b.crm_order_no
           and b.order_from = '76');
select count(1)
  from fact_goods_sales a
 where a.posting_date_key = 20160101
   and exists (select 1
          from fact_ec_order_2 b
         where a.order_key = b.crm_order_no
           and b.order_from <> '76');
  
select * from w_etl_log a where a.proc_name='YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT' and a.err_msg='输入参数:IN_POSTING_DATE_KEY:20180314';
select trunc(a.add_time) add_time_key, a.order_from, count(1)
  from fact_ec_order_2 a
 where a.order_from = '76'
 group by trunc(a.add_time), a.order_from
 order by trunc(a.add_time), a.order_from;
 
select trunc(a.add_time) add_time_key,
       substr(a.erp_order_no, 1, 2) erp_order_no,
       count(1)
  from fact_ec_order_2 a
 group by trunc(a.add_time), substr(a.erp_order_no, 1, 2)
 order by trunc(a.add_time), substr(a.erp_order_no, 1, 2);

SELECT * FROM ODSHAPPIGO.ODS_ORDER@BITONEWBI A WHERE A.CRMPOSTDAT = '20160101';
select * from FACT_GOODS_SALES a where a.posting_date_key = 20160101;
select *
  from fact_ec_order_2 a
 where trunc(a.add_time) = date '2016-01-01';
select * from FACT_GOODS_SALES a where a.order_key <> a.order_h_key;
select *
  from all_col_comments a
 where lower(a.COLUMN_NAME) like '%crm_order_no%';
select * from FACTEC_ORDER a where a.add_time = 20160101;
SELECT b.order_from, count(1)
  FROM FACT_GOODS_SALES A, fact_ec_order_2 b
 WHERE a.order_key = b.crm_order_no
   and A.POSTING_DATE_KEY = 20160101
 group by b.order_from
 order by b.order_from;
select a.order_from, count(1)
  from fact_ec_order_2 a
 where group by a.order_from
 order by a.order_from;
SELECT a.order_key,
       b.crm_order_no,
       b.order_from,
       a.posting_date_key,
       b.add_time
  FROM FACT_GOODS_SALES A, fact_ec_order_2 b
 WHERE a.order_key = b.crm_order_no
   and A.POSTING_DATE_KEY = 20160101;
SELECT * FROM OPER_PRODUCT_DAILY_REPORT;
SELECT * FROM FACT_GOODS_SALES A WHERE A.POSTING_DATE_KEY = 20180314;
SELECT *
  FROM FACT_EC_ORDER_2 A
 WHERE TRUNC(A.ADD_TIME) = DATE '2018-03-14';
SELECT *
  FROM FACT_GOODS_SALES A
 WHERE A.POSTING_DATE_KEY = TO_CHAR(TRUNC(SYSDATE) - 1, 'YYYYMMDD');
SELECT *
  FROM FACT_GOODS_SALES_REVERSE A
 WHERE A.POSTING_DATE_KEY = TO_CHAR(TRUNC(SYSDATE) - 1, 'YYYYMMDD');

SELECT COUNT(1) FROM FACT_EC_ORDER_2 A WHERE A.ORDER_FROM <> '76';
SELECT DISTINCT A.ORDER_FROM FROM FACT_EC_ORDER_2 A;

SELECT A.ORDER_ID,
       A.ERP_ORDER_NO,
       A.CRM_ORDER_NO,
       A.ORDER_FROM,
       B.GOODS_ID,
       B.GOODS_COMMONID,
       B.ERP_CODE,
       B.GOODS_NAME
  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
 WHERE A.ORDER_ID = B.ORDER_ID
   AND TRUNC(A.ADD_TIME) = DATE '2018-03-15'
   AND A.ORDER_FROM = '76'
   AND EXISTS (SELECT 1
          FROM (SELECT A.ORDER_ID,
                       A.ERP_ORDER_NO,
                       A.CRM_ORDER_NO,
                       A.ORDER_FROM,
                       B.GOODS_ID,
                       B.GOODS_COMMONID,
                       B.ERP_CODE,
                       B.GOODS_NAME
                  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND TRUNC(A.ADD_TIME) = DATE
                 '2018-03-15'
                   AND A.ORDER_FROM <> '76') C
         WHERE B.GOODS_COMMONID = C.GOODS_COMMONID);
SELECT A.ORDER_ID,
       A.ERP_ORDER_NO,
       A.CRM_ORDER_NO,
       A.ORDER_FROM,
       B.GOODS_ID,
       B.GOODS_COMMONID,
       B.ERP_CODE,
       B.GOODS_NAME
  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
 WHERE A.ORDER_ID = B.ORDER_ID
   AND TRUNC(A.ADD_TIME) = DATE '2018-03-15' AND B.GOODS_COMMONID=143403;
SELECT * FROM DIM_GOOD A WHERE A.GOODS_COMMONID=234421;
SELECT * FROM DIM_GOOD A WHERE A.ITEM_CODE=234421;
SELECT * FROM DIM_EC_GOOD A WHERE A.GOODS_COMMONID= 171916;
SELECT * FROM ODSHAPPIGO.ODS_ORDER A WHERE A.CRMPOSTDAT = '20180310';
SELECT DISTINCT A.CRMPOSTDAT FROM ODSHAPPIGO.ODS_ORDER A;
