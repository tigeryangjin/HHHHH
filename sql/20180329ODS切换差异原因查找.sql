--1.
create table oper_product_daily_report_bak as
select *
  from oper_product_daily_report a
 where a.posting_date_key between 20180309 and 20180328;

create table fact_goods_sales_bak_201803 as
select *
  from fact_goods_sales a
 where a.posting_date_key between 20180310 and 20180328;

create table fact_goods_sales_reverse_bak as
select *
  from fact_goods_sales_reverse a
 where a.posting_date_key between 20180310 and 20180328;

create table ods_order_20180310_new as
select * from odshappigo.ods_order_2 a where a.crmpostdat = 20180310;

create table ods_order_20180310_old as
select * from odshappigo.ods_order a where a.crmpostdat = 20180310;

--2. 
select a.sales_source_name,
       count(1),
       sum(a.total_order_amount),
       sum(a.effective_order_amount)
  from oper_product_daily_report a
 where a.posting_date_key = 20180310
 group by a.sales_source_name;
select a.sales_source_name,
       count(1),
       sum(a.total_order_amount),
       sum(a.effective_order_amount)
  from oper_product_daily_report_bak a
 where a.posting_date_key = 20180310
 group by a.sales_source_name;

--3.
select *
  from oper_product_daily_report a
 where a.posting_date_key = 20180310
   and a.sales_source_name = 'TV'
 order by a.effective_order_amount desc;
select *
  from oper_product_daily_report_bak a
 where a.posting_date_key = 20180310
   and a.sales_source_name = 'TV'
 order by a.effective_order_amount desc;

--4.	 
select *
  from oper_product_daily_report a
 where a.posting_date_key = 20180310
   and a.sales_source_second_name = 'TV全国'
   and a.item_code = 234324;
select *
  from oper_product_daily_report_bak a
 where a.posting_date_key = 20180310
   and a.sales_source_second_name = 'TV全国'
   and a.item_code = 234324;


--5.
select a.sales_source_second_desc, count(1), sum(a.order_amount)
  from fact_goods_sales a
 where a.posting_date_key = 20180310
   and a.goods_common_key = 234324
 group by a.sales_source_second_desc;
select a.sales_source_second_desc, count(1), sum(a.order_amount)
  from fact_goods_sales_bak_201803 a
 where a.posting_date_key = 20180310
   and a.goods_common_key = 234324
 group by a.sales_source_second_desc;
 

--6.
select *
  from fact_goods_sales a
 where a.posting_date_key = 20180310
   and a.goods_common_key = 234324
   and a.sales_source_second_desc = 'A10001';
select *
  from fact_goods_sales_bak_201803 a
 where a.posting_date_key = 20180310
   and a.goods_common_key = 234324
   and a.sales_source_second_desc = 'A10001';
	 
--7.
select *
  from fact_goods_sales a
 where a.posting_date_key = 20180310
   and a.goods_common_key = 234324
   and a.sales_source_second_desc = 'A10001'
   and a.order_key in (5207208635, 5207207528, 5207207904);
select *
  from fact_goods_sales_bak_201803 a
 where /*a.posting_date_key = 20180310
   and a.goods_common_key = 234324
   and a.sales_source_second_desc = 'A10001'
   and*/ a.order_key in (5207208635, 5207207528, 5207207904);

--8.
select * from ods_order_20180310_old a where a.ztcrmc04 in (5207208635, 5207207528, 5207207904) order by a.ztcrmc04;
select * from ods_order_20180310_new a where a.ztcrmc04 in (5207208635, 5207207528, 5207207904) order by a.ztcrmc04;

--tmp
select * from odshappigo.ods_order a where a.crmpostdat=20180330 and a.crmpostdat<>a.crm_crd_at;
select * from ods_order_20180310_new a where a.crmpostdat<>a.crm_crd_at; 
select * from ods_order_20180310_old a where a.crmpostdat<>a.crm_crd_at; 
select a.crmpostdat, count(1)
  from odshappigo.ods_order_2 a
 where a.crmpostdat between '20180301' and '20180331'
 group by a.crmpostdat
 order by a.crmpostdat desc;
select to_number(z.ZTCRMC04)
  from odshappigo.ods_order z
 where ((z.zcr_on >= to_char(&crmpostdates * 1000000) and
       z.zcr_on < to_char((&crmpostdates + 1) * 1000000) and
       z.crmpostdat < to_char(&crmpostdates)) or
       z.crmpostdat = to_char(&crmpostdates))
   and z.CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
	 and z.crm_obj_id in (5207208635, 5207207528, 5207207904)
 group by z.ZTCRMC04;
select * from fact_goods_sales_reverse a where a.order_key in (5207208635, 5207207528, 5207207904);
select * from fact_goods_sales a where a.posting_date_key=20180315 and a.order_state=0;
select * from odshappigo.ods_order_cancel a where a.crm_obj_id in (5207208635, 5207207528, 5207207904);
select a.order_key,count(1)
  from fact_goods_sales_bak_201803 a
 where a.posting_date_key = 20180310
   and a.goods_common_key = 234324
   and a.sales_source_second_desc = 'A10001'
	 group by a.order_key;
select *
  from odshappigo.ods_order a
 where a.crmpostdat = 20180310
   and a.crm_obj_id in (5207208635, 5207207528, 5207207904);
select *
  from ods_order@biods_link a
 where a.crmpostdat = 20180310
   and a.crm_obj_id in (5207208635, 5207207528, 5207207904);

select *
  from ods_order@biods_link a where a.crmpostdat=20180308;
select * from odshappigo.ods_order a where a.crmpostdat = 20180308;
