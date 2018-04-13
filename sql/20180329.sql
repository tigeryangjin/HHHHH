--1.
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

--2.
select a1.posting_date_key,
       a1.sales_source_second_name,
       a1.item_code,
       a1.effective_order_amount,
       a2.effective_order_amount,
       a2.effective_order_amount - a1.effective_order_amount diff
  from (select a.posting_date_key,
               a.sales_source_second_name,
               a.item_code,
               sum(a.effective_order_amount) effective_order_amount
          from oper_product_daily_report a
         where a.posting_date_key = 20180310
           and a.sales_source_name = 'TV'
         group by a.posting_date_key,
                  a.sales_source_second_name,
                  a.item_code) a1,
       (select a.posting_date_key,
               a.sales_source_second_name,
               a.item_code,
               sum(a.effective_order_amount) effective_order_amount
          from oper_product_daily_report_bak a
         where a.posting_date_key = 20180310
           and a.sales_source_name = 'TV'
         group by a.posting_date_key,
                  a.sales_source_second_name,
                  a.item_code) a2
 where a1.posting_date_key = a2.posting_date_key
   and a1.sales_source_second_name = a2.sales_source_second_name
   and a1.item_code = a2.item_code;

--3.
select *
  from oper_product_daily_report a
 where a.posting_date_key = 20180310
   and a.sales_source_second_name = 'TVȫ��'
   and a.item_code = 208877;
select *
  from oper_product_daily_report_bak a
 where a.posting_date_key = 20180310
   and a.sales_source_second_name = 'TVȫ��'
   and a.item_code = 208877;


--4.
select *
  from fact_goods_sales_reverse a
 where a.posting_date_key = 20180310
   and a.goods_common_key = 208877
   and a.sales_source_second_desc = 'A10001'
	 order by a.order_key;
select *
  from fact_goods_sales_reverse_bak a
 where a.posting_date_key = 20180310
   and a.goods_common_key = 208877
   and a.sales_source_second_desc = 'A10001'
	 order by a.order_key;
	 
--5.
select * from odshappigo.ods_order a where a.crm_obj_id=5207200128;
select * from odshappigo.ods_order a where a.ztcrmc04=5207172651;
