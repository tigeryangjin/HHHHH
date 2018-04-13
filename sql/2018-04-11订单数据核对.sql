--1.
select a.item_code,
       sum(a.effective_order_amount) effective_order_amount,
       sum(a.effective_order_qty) effective_order_qty
  from oper_product_daily_report a
 where a.posting_date_key = 20180410
   and a.sales_source_second_name = '��ý��΢�ţ�2.0��'
   and a.item_code is not null
 group by a.item_code
 order by a.item_code;

--2.
select distinct a.sales_source_second_name
  from oper_product_daily_report a
 where a.posting_date_key = 20180410;

--3.
select *
  from fact_goods_sales a
 where a.posting_date_key = 20180410
   and a.sales_source_second_key = 20017
   and a.goods_common_key = 235804;

--4.
select * from dim_good a where a.item_code = 233724;
select * from dim_good a where a.item_code = 236656;
select * from dim_good a where a.item_code = 235804; --������
select * from dim_good a where a.item_code = 233724; --������

--5.
select *
  from odshappigo.ods_zmaterial a
 where a.zmater2 = '000000000000232918';

--6.
select *
  from w_etl_log a
 where lower(a.table_name) = 'dim_good'
--and a.proc_name = 'processgoodunion'
 order by a.start_time desc;

select *
  from w_etl_log a
 where lower(a.table_name) = 'dim_good'
   and a.proc_name = 'processgood'
 order by a.start_time desc;

--7.
call processgood(20180409);
call processgood(20180410);
call processgoodunion(20180409);
call processgoodunion(20180410);

--8.
select *
  from fact_ec_order_2 a, fact_ec_order_goods b
 where a.order_id = b.order_id
   and trunc(a.add_time) = date '2018-04-10'
   and a.order_state >= 20
   and b.erp_code = 235325;

select *
  from fact_ec_order_2 a
 where a.order_id in (2890444, 2891733, 2891735, 2891788, 2891691);

select *
  from factec_order a
 where a.order_id in (2890444, 2891733, 2891735, 2891788, 2891691);

--9.
select *
  from oper_product_daily_report a
 where a.posting_date_key = 20180410
   and a.item_code = 234188;

--10.
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2018-04-01';
  END_DATE    DATE := DATE '2018-04-10';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    ODSHAPPIGO.OD_ORDER_ETL.INSERT_MODIFY_TP(IN_DATE_INT);
    ODSHAPPIGO.OD_ORDER_ETL.MERGE_SAP_BIC_AZTCRD00100;
    ODSHAPPIGO.OD_ORDER_ETL.INSERT_ODS_ORDER(IN_DATE_INT);
    ODSHAPPIGO.OD_ORDER_ETL.INSERT_ODS_ORDER_CANCEL(IN_DATE_INT);
    CREATEORDERGOODS(IN_DATE_INT);
    PROCESSUPDATEORDER(IN_DATE_INT);
    CREATEFACTORDERGOODSREVERSE(IN_DATE_INT);
    PROCESSUPDATEORDERREVERSE(IN_DATE_INT);
    YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT(IN_DATE_INT);
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

--***************************************************************************************
--1.
create table excel_product_tmp(�������� date,
                               ������������ varchar2(100),
                               ��Ʒ���� number,
                               ��Ч������� number,
                               ��Ч�������� number);
select * from excel_product_tmp for update;

--2.
select a.������������, sum(a.��Ч�������) ��Ч�������
  from excel_product_tmp a
 group by a.������������
 order by a.������������;

select a.sales_source_second_name,
       sum(a.effective_order_amount) effective_order_amount
  from oper_product_daily_report a
 where a.posting_date_key between 20180401 and 20180411
 group by a.sales_source_second_name
 order by a.sales_source_second_name;

--3.
select a.��������, sum(a.��Ч�������) ��Ч�������
  from excel_product_tmp a
 where a.������������ = '��ý��΢��(2.0)'
 group by a.��������
 order by a.��������;

select a.posting_date_key,
       sum(a.effective_order_amount) effective_order_amount
  from oper_product_daily_report a
 where a.posting_date_key between 20180401 and 20180411
   and a.sales_source_second_name = '��ý��΢�ţ�2.0��'
 group by a.posting_date_key
 order by a.posting_date_key;

--4.
select a.��Ʒ����,
       sum(a.��Ч��������) ��Ч��������,
       sum(a.��Ч�������) ��Ч�������
  from excel_product_tmp a
 where a.������������ = '��ý��΢��(2.0)'
   and a.�������� = date '2018-04-01'
 group by a.��Ʒ����
 order by a.��Ʒ����;

select a.item_code,
       sum(a.effective_order_qty) effective_order_qty,
       sum(a.effective_order_amount) effective_order_amount
  from oper_product_daily_report a
 where a.posting_date_key = 20180401
   and a.sales_source_second_name = '��ý��΢�ţ�2.0��'
 group by a.item_code
 order by a.item_code;

--5.
select *
  from oper_product_daily_report a
 where a.posting_date_key = 20180401
   and a.sales_source_second_name = '��ý��΢�ţ�2.0��'
   and a.item_code = 235260;

--6. 04.04-04.10�����ظ�
call yangjin_pkg.oper_product_daily_rpt(20180404);
call yangjin_pkg.oper_product_daily_rpt(20180405);
call yangjin_pkg.oper_product_daily_rpt(20180406);
call yangjin_pkg.oper_product_daily_rpt(20180407);
call yangjin_pkg.oper_product_daily_rpt(20180408);
call yangjin_pkg.oper_product_daily_rpt(20180409);
call yangjin_pkg.oper_product_daily_rpt(20180410);
