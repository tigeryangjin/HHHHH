-----------------
select sum(num1)/count(distinct(visit_date_key)),page_name from (
select count(distinct(vid)) num1,visit_date_key,page_name from  fact_page_view where 
visit_date_key between 20170515 and 20170714
and APPLICATION_KEY in (10,20) and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key,page_name) group by page_name


---
select sum(num1)/count(distinct(visit_date_key)),sum(num2)/count(distinct(visit_date_key)),
sum(num3)/count(distinct(visit_date_key)) from (
select count(distinct(vid)) num1,count(1) num2,sum(PAGE_STAYTIME)/count(distinct(vid)) num3,visit_date_key  from  fact_page_view where 
visit_date_key between 20170515 and 20170524
and APPLICATION_KEY in (10,20) and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key)



select * from fact_page_view WHERE PAGE_NAME='SL_B2C_Bigad' and visit_date_key between 20170515 and 20170714

----商品详情
select sum(num1)/count(distinct(visit_date_key)), sum(num2)/count(distinct(visit_date_key)) from (
select count(distinct(vid)) num1,count(1) num2,visit_date_key from  fact_page_view where 
visit_date_key between 20170515 and 20170714
and APPLICATION_KEY in (10,20) 
and page_name='Good'
and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key)

----商品详情
select sum(num1)/count(distinct(visit_date_key)), sum(num2)/count(distinct(visit_date_key)) from (
select count(distinct(vid)) num1,count(1) num2,visit_date_key from  fact_page_view where 
visit_date_key between 20170315 and 20170514
and APPLICATION_KEY in (10,20) 
and page_name='ShoppingCart'
and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key)

---- 订单提交
select sum(num1)/count(distinct(visit_date_key)) from (
select count(distinct(vid)) num1,visit_date_key from  fact_page_view where
visit_date_key between 20170515 and 20170714
and APPLICATION_KEY in (10,20) 
and page_name='OrderConfirm'
and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key)


---总订购
select sum(num1)/count(distinct(add_time)) from (
select  count(distinct(vid)) num1,add_time  from factec_order where
 add_time between 20170515 and 20170714
 and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by add_time)



----有效订购
select sum(num1)/count(distinct(add_time)) from (
select  count(distinct(vid)) num1,add_time  from factec_order where
 add_time between 20170515 and 20170714
 and order_state>10
 and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by add_time)


----

--------

 (
select  count(distinct(vid)) num1,sum(order_amount) num2,count(1),sum(GOODS_NUM)  from factec_order where
 add_time between  20170515 and 20170714
 and order_state>10
 and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
)


----
select  count(1) from
 (
select vid,sum(order_amount) num2,count(1) num3,count(distinct(add_time)) num4  from factec_order where
 add_time between 20170515 and 20170714
 and order_state>10
 and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group BY vid
) where   num3>1
