----------

-----------------
select sum(num1)/count(distinct(visit_date_key)),page_name from (
select count(distinct(vid)) num1,visit_date_key,page_name from  fact_page_view where 
visit_date_key between 20170314 and 20170514
and APPLICATION_KEY in (10,20) and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key,page_name) group by page_name

----商品详情
select sum(num1)/count(distinct(visit_date_key)), sum(num2)/count(distinct(visit_date_key)) from (
select count(distinct(vid)) num1,count(1) num2,visit_date_key from  fact_page_view where 
 visit_date_key between 20170314 and 20170514
and APPLICATION_KEY in (10,20) 
and page_name='Good'
and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key)



---- 订单提交
select sum(num1)/count(distinct(visit_date_key)) from (
select count(distinct(vid)) num1,visit_date_key from  fact_page_view where
 visit_date_key between 20170314 and 20170514
and APPLICATION_KEY in (10,20) 
and page_name='OrderConfirm'
and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key)


---总订购
select sum(num1)/count(distinct(add_time)) from (
select  count(distinct(vid)) num1,add_time  from factec_order where
 add_time between 20170314 and 20170514
 and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by add_time)



----有效订购
select sum(num1)/count(distinct(add_time)),sum(num2)/count(distinct(add_time)) from (
select  count(distinct(vid)) num1,sum(order_amount) num2,add_time  from factec_order where
 add_time between 20170314 and 20170514
 and order_state>10
 and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by add_time)


----有效订购  ----338028
select sum(num1)/count(distinct(add_time)),sum(num2)/count(distinct(add_time))  from (
select  count(distinct(vid)) num1,sum(order_amount) num2,add_time  from factec_order where
 add_time between 20170314 and 20170514
 and order_state>10
 and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by add_time)


-----------
---
select sum(num1)/count(distinct(visit_date_key)),sum(num2)/count(distinct(visit_date_key)),
sum(num3)/count(distinct(visit_date_key)) from (
select count(distinct(vid)) num1,count(1) num2,sum(PAGE_STAYTIME)/count(distinct(vid)) num3,visit_date_key  from  fact_page_view where 
visit_date_key between  20170314 and 20170514
and APPLICATION_KEY in (10,20) and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by visit_date_key)


--------

select sum(num1)/count(distinct(add_time)),sum(num2)/count(distinct(add_time))  from (
select  count(distinct(vid)) num1,sum(order_amount) num2,count(1),sum(nums)  from factec_order where
 add_time between 20170314 and 20170514
 and order_state>10
 and vid in (
select  VID from  abpage_vidscore where VIDSCORE>0)
group by add_time)

select * from factec_order

