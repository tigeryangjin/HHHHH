/*
����㣺����ȡ���Ķ�����ȡ���������Ƿ�û��д��fact_goods_sales
item_code:217428,����A20021,��2017-07-25�����ˣ�Ȼ����2017-07-26ȡ�������ˣ����ǽ������ݶԲ��ϡ�
ԭ��25�ն����ļ�¼��update_timeû�б����³�20170726��PROCESSUPDATEORDER���̼���distinct֮��ִ�мƻ����ˣ�ִ�в��ɹ���

createordergoods
PROCESSUPDATEORDER
CREATEFACTORDERGOODSREVERSE
PROCESSUPDATEORDERREVERSE

�޸���distinct֮�����в��죺item_code:223064��217685

*/

begin
  -- Call the procedure
  yangjin_pkg.fact_goods_sales_fix(20170721);
end;
/

--1.
--7.25
begin
  -- Call the procedure
  createordergoods(20170725);
end;
/

begin
  -- Call the procedure
  PROCESSUPDATEORDER(20170725);
end;
/

begin
  -- Call the procedure
  CREATEFACTORDERGOODSREVERSE(20170725);
end;
/

begin
  -- Call the procedure
  PROCESSUPDATEORDERREVERSE(20170725);
end;
/

--7.26
begin
  -- Call the procedure
  createordergoods(20170726);
end;
/

begin
  -- Call the procedure
  PROCESSUPDATEORDER(20170726);
end;
/

begin
  -- Call the procedure
  CREATEFACTORDERGOODSREVERSE(20170726);
end;
/

begin
  -- Call the procedure
  PROCESSUPDATEORDERREVERSE(20170726);
end;
/


--7.21-7.23
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


--oper_product_daily_rpt
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

begin
  -- Call the procedure
  yangjin_pkg.oper_product_daily_rpt(20170725);
end;
/

begin
  -- Call the procedure
  yangjin_pkg.oper_product_daily_rpt(20170726);
end;
/

--2.
select a.sales_source_second_name,
       SUM(A.TOTAL_ORDER_QTY) TOTAL_ORDER_QTY,
       SUM(A.TOTAL_ORDER_AMOUNT) TOTAL_ORDER_AMOUNT,
       SUM(A.NET_ORDER_AMOUNT) NET_ORDER_AMOUNT,
       sum(a.effective_order_amount) effective_order_amount
  from oper_product_daily_report a
 where a.posting_date_key = 20170724
 group by a.sales_source_second_name
 order by a.sales_source_second_name;

SELECT /*+PARALLEL(16)*/
 *
  FROM ODSHAPPIGO.ODS_ORDER A
 WHERE A.crmpostdat = 20170726
   AND A.zkunnr_l2 = 'A20021'
   AND A.zmater2 = 217428;

SELECT /*+PARALLEL(16)*/
 *
  FROM ODSHAPPIGO.ODS_ORDER A
 WHERE A.ZTCRMC04 = 5203071476;

--
SELECT * FROM FACT_GOODS_SALES A WHERE A.POSTING_DATE_KEY=20170725 AND A.SALES_SOURCE_SECOND_KEY=20021 AND A.GOODS_COMMON_KEY=217428;
SELECT * FROM FACT_GOODS_SALES A WHERE A.POSTING_DATE_KEY=20170726 AND A.SALES_SOURCE_SECOND_KEY=20021 AND A.GOODS_COMMON_KEY=217428;
SELECT * FROM FACT_GOODS_SALES_REVERSE A WHERE A.POSTING_DATE_KEY=20170726 AND A.SALES_SOURCE_SECOND_KEY=20021 AND A.GOODS_COMMON_KEY=217428;
SELECT * FROM OPER_PRODUCT_DAILY_REPORT A WHERE A.POSTING_DATE_KEY=20170725 AND A.SALES_SOURCE_SECOND_NAME='��ý��΢�ţ�2.0��' AND A.ITEM_CODE=217428;
SELECT * FROM OPER_PRODUCT_DAILY_REPORT A WHERE A.POSTING_DATE_KEY=20170726 AND A.SALES_SOURCE_SECOND_NAME='��ý��΢�ţ�2.0��' AND A.ITEM_CODE=217428;
SELECT * FROM OPER_PRODUCT_DAILY_REPORT A WHERE A.POSTING_DATE_KEY=20170726 AND A.SALES_SOURCE_SECOND_NAME='��ý��΢�ţ�2.0��' ORDER BY A.ITEM_CODE,A.EFFECTIVE_ORDER_AMOUNT;
