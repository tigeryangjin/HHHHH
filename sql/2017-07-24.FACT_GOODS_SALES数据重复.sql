--20170721,20170722,20170723 FACT_GOODS_SALES,FACT_GOODS_SALES_REVERSE��������
--1.
begin
  -- Call the procedure
  createordergoods(20170721);
end;
/
begin
  -- Call the procedure
  createordergoods(20170722);
end;
/
begin
  -- Call the procedure
  createordergoods(20170723);
end;
/

begin
  -- Call the procedure
  PROCESSUPDATEORDER(20170721);
end;
/
begin
  -- Call the procedure
  PROCESSUPDATEORDER(20170722);
end;
/
begin
  -- Call the procedure
  PROCESSUPDATEORDER(20170723);
end;
/
--2.
begin
  -- Call the procedure
  yangjin_pkg.oper_product_daily_rpt(20170721);
end;
/
begin
  -- Call the procedure
  yangjin_pkg.oper_product_daily_rpt(20170722);
end;
/
begin
  -- Call the procedure
  yangjin_pkg.oper_product_daily_rpt(20170723);
end;
/
--3.
begin
  -- Call the procedure
  createfactordergoodsreverse(20170721);
end;
/
begin
  -- Call the procedure
  createfactordergoodsreverse(20170722);
end;
/
begin
  -- Call the procedure
  createfactordergoodsreverse(20170723);
end;
/

--4.
--24/10436
select SUM(A.TOTAL_ORDER_QTY) TOTAL_ORDER_QTY,
       SUM(A.TOTAL_ORDER_AMOUNT) TOTAL_ORDER_AMOUNT
  from oper_product_daily_report a
 where a.posting_date_key = 20170721
   and a.item_code = 217469
   AND A.SALES_SOURCE_SECOND_NAME = '��ý��΢�ţ�2.0��';
--5.
select a.sales_source_second_name,
       SUM(A.TOTAL_ORDER_QTY) TOTAL_ORDER_QTY,
       SUM(A.TOTAL_ORDER_AMOUNT) TOTAL_ORDER_AMOUNT,
			 SUM(A.NET_ORDER_AMOUNT) NET_ORDER_AMOUNT,
			 sum(a.effective_order_amount) effective_order_amount
  from oper_product_daily_report a
 where a.posting_date_key = 20170726
 group by a.sales_source_second_name
 order by a.sales_source_second_name;
 
--TMP
--20170726,A20021,217428,excel��ȡ���ļ�¼���������ݿ�û�м�¼��
SELECT *
  FROM oper_product_daily_report a
 where a.posting_date_key = 20170726
   AND A.SALES_SOURCE_SECOND_NAME = '��ý��΢�ţ�2.0��'
   AND A.ITEM_CODE = 217428;
	 
SELECT *
  FROM FACT_GOODS_SALES_REVERSE A
 WHERE A.POSTING_DATE_KEY = 20170726
   AND A.SALES_SOURCE_SECOND_KEY = 20021
   AND A.GOODS_COMMON_KEY = 217428;
	 
SELECT *
  FROM FACT_GOODS_SALES A
 WHERE A.POSTING_DATE_KEY = 20170726
   AND A.SALES_SOURCE_SECOND_KEY = 20021
   AND A.GOODS_COMMON_KEY = 217428;
	 
SELECT /*+PARALLEL(16)*/
 *
  FROM ODSHAPPIGO.ODS_ORDER A
 WHERE A.crmpostdat = 20170726
   AND A.zkunnr_l2 = 'A20021'
   AND A.zmater2 = 217428;

SELECT t.order_key, t.goods_common_key, t.posting_date_key, count(1)
  FROM FACT_GOODS_SALES_REVERSE T
 WHERE T.POSTING_DATE_KEY = 20170721
 group by t.order_key, t.goods_common_key, t.posting_date_key;
 
SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%INSERT INTO%FACT_GOODS_SALES%';

SELECT * FROM W_ETL_LOG A WHERE A.PROC_NAME='processupdateorder' ORDER BY A.START_TIME DESC;
SELECT * FROM W_ETL_LOG A WHERE A.PROC_NAME='createfactordergoodsreverse' ORDER BY A.START_TIME DESC;

SELECT 115542.7-130698.7 FROM DUAL;
