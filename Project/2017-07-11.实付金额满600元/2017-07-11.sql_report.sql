--6��29��0:00-6��30��23:59��APP��������΢�Ŷ���ʵ�������600Ԫ�Ļ�Աbp��(����ֱ�ʡ�bbc��������������)
select *
  from fact_goods_sales a
 where a.order_state = 1
   and a.sales_source_second_key in (20017, 20020, 20021)
   and exists
 (select 1
          from (select * from dim_ec_good c where c.store_id = 1) d
         where a.goods_common_key = d.item_code)
   and a.posting_date_key between 20170629 and 20170630;

select distinct a.member_key
  from fact_order a
 where a.order_state = 1
   and a.sales_source_second_key in (20017, 20020, 20021)
   and a.posting_date_key between 20170629 and 20170630
	 and a.order_amount>=600
	 order by 1;
