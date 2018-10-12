--1.来源流量分析
--a TV 摇一摇数据

SELECT count(DISTINCT(ip)),count(1),visit_date_key FROM   fact_page_view 
 s where s.page_name='ShakeTv_sucai' and s.visit_date_key  between 20160915  and  20160922  
 group by visit_date_key;


SELECT count(DISTINCT(ip)),count(1) FROM   FACT_PAGE_VIEW  S where s.page_name='TV_QRC' and s.visit_date_key =20160922
 
AND IP IN (SELECT DISTINCT(IP) FROM   fact_page_view  s where s.page_name='ShakeTv_sucai' and s.visit_date_key=20160922
)

SELECT count(DISTINCT(vid)),count(1)  FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and s.page_value not like '%list%' and s.visit_date_key  between 20160915  and  20160922  
;


select count(distinct(vid)) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key between 20160915 and 20160922  and ip in

(
SELECT DISTINCT(ip) FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and
 s.page_value not like '%list%' and s.visit_date_key=b.visit_date_key  

)  

----商品详情
select * from fact_ec_order 
select count(distinct(vid)) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key between 20160915 and 20160922  and ip in

(
SELECT DISTINCT(ip) FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and
 s.page_value not like '%list%' and s.visit_date_key=b.visit_date_key  

)  
and page_name='OrderConfirm'




----微信其他  6844    30033

select count(distinct(vid)) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key between 20160915 and 20160922   
and page_name='Good'


---订购

select count(distinct(d.vid)) from fact_ec_order d where d.ADD_TIME between 20160915 and 20160922 and vid in (
select distinct(vid) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key=d.ADD_TIME  and ip in

(
SELECT DISTINCT(ip) FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and
 s.page_value not like '%list%' and s.visit_date_key=b.visit_date_key  

)  
and page_name='Good')  and d.order_state>10

--2.带来用户分析

select count(1) from fact_visitor_register  where  CREATE_DATE_KEY between 20160915 and 20160922  and VID in(
select distinct(vid) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key=CREATE_DATE_KEY  and ip in

(
SELECT DISTINCT(ip) FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and
 s.page_value not like '%list%' and s.visit_date_key=b.visit_date_key  
 
 
 select  count(distinct(member_key)) from fact_member_ec_goods_sales  where  ITEM_CODE is null
)  )

--- 电商新会员
select sum(ORDER_AMOUNT) from   fact_ec_order d where d.ADD_TIME between 20160915 and 20160922 and d.CUST_NO in(
select MEMBER_BP from dim_member where  FIRST_ACTIVE_DATE_KEY between 20160915 and 20160922  and CREATE_DATE_KEY <20160915 and  MEMBER_BP  in(

select distinct(b.member_key) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key=FIRST_ACTIVE_DATE_KEY  and ip in

(
SELECT DISTINCT(ip) FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and
 s.page_value not like '%list%' and s.visit_date_key=b.visit_date_key  

)
)
) and d.order_state>0
-----
select * from fact_member_register where  DEVICE_KEY in 

(

select distinct(b.DEVICE_KEY) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key between 20160915 and 20160922  and ip in

(
SELECT DISTINCT(ip) FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and
 s.page_value not like '%list%' and s.visit_date_key=b.visit_date_key  

)
)
----快乐购新会员

select sum(ORDER_AMOUNT) from   fact_ec_order d where d.ADD_TIME between 20160915 and 20160922 and d.CUST_NO in(
select MEMBER_BP from dim_member where  CREATE_DATE_KEY between 20160915 and 20160922   and  MEMBER_BP  in(

select distinct(b.member_key) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key=CREATE_DATE_KEY  and ip in

(
SELECT DISTINCT(ip) FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and
 s.page_value not like '%list%' and s.visit_date_key=b.visit_date_key  

)
)
) and d.order_state>0

--3.带来订购分析

select sum(ORDER_AMOUNT) from fact_ec_order d where d.ADD_TIME between 20160915 and 20160922 and vid in (
select distinct(vid) from fact_page_view b  where b.application_key=50 
and  b.visit_date_key=d.ADD_TIME  and ip in

(
SELECT DISTINCT(ip) FROM   fact_page_view 
 s where (s.page_name='TV_QRC' or s.page_name='Tvdwonload') and
 s.page_value not like '%list%' and s.visit_date_key=b.visit_date_key  

)  
and page_name='Good')  and d.order_state>0

select  sum(ORDER_AMOUNT) from fact_ec_order d where d.ADD_TIME between 20160915 and 20160922 and  ORDER_FROM=64 and d.order_state>0
--4.扫码热度分析  972041.66  181945  417387.06  599332.06


select sum(NEWVTCOUNT),sum(MCNT) from fact_daily_wx where VISIT_DATE_KEY  between 20160915 and 20160922



SELECT * FROM table1 ORDER BY rand() 
