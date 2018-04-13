create table oper_product_daily_report_bak as
select *
  from oper_product_daily_report a
 where a.posting_date_key between 20180309 and 20180328;

create table fact_goods_sales_bak_201803 as
select *
  from fact_goods_sales a
 where a.posting_date_key between 20180310 and 20180328;

create table fact_goods_sales_reverse_bak as
select * from fact_goods_sales_reverse
 
select a.sales_source_name,
       count(1),
       sum(a.total_order_amount),
       sum(a.effective_order_amount)
  from oper_product_daily_report a
 where a.posting_date_key = 20180309
 group by a.sales_source_name;
select a.sales_source_name,
       count(1),
       sum(a.total_order_amount),
       sum(a.effective_order_amount)
  from oper_product_daily_report_bak a
 where a.posting_date_key = 20180309
 group by a.sales_source_name;

select *
  from oper_product_daily_report a
 where a.posting_date_key = 20180309
   and a.sales_source_name = 'TV'
   and a.item_code = 232367;
select *
  from oper_product_daily_report_bak a
 where a.posting_date_key = 20180309
   and a.sales_source_name = 'TV'
   and a.item_code = 232367;
	 
select * from odshappigo.ods_order a where a.crmpostdat=20180309 and a.zmater2='000000000000232367';
select * from ods_order@biods_link a where a.crmpostdat=20180309 and a.zmater2='000000000000232367';


select * from odshappigo.ods_order_cancel a where a.crmpostdat=20180309 and a.zmater2='000000000000232367';

select * from fact_goods_sales a where a.posting_date_key=20180309 and a.goods_common_key=232367 and a.order_state=0;
