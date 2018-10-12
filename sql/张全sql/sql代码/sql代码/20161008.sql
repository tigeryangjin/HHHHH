select * from fact_goods_sales where   GOODS_COMMON_KEY=201278



select * from fact_page_view a  where  vid='iphonec3ec97f47abe46e80f223641bdfb6d77e9826d0f' and a.visit_date_key=20161009

select * from FACT_MEMBER_EC_GOODS_SALES_FQ 
 where MEMBER_KEY=1604667400
 
 
 
  select  count(1) from fact_page_view a where a.visit_date_key =20161009 and a.page_name='Good' and a.application_key in(50)
 
 and IP_GEO_KEY<0
 
 select * from fact_goods_sales where  ORDER_KEY in (
  select  ORDER_KEY from (
select ORDER_KEY,count(1) as chi from   fact_goods_sales  where  ORDER_KEY in(
 select ORDER_KEY from fact_goods_sales where  SALES_SOURCE_KEY=20  and  ORDER_DATE_KEY>20160920 and 
  SUPPLIER_KEY in (112244,110993,110917,110167,101782)  and  ORDER_STATE=1)
  
group by ORDER_KEY) where chi>1)
