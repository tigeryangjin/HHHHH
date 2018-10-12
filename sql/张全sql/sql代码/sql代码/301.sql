------- 新老用户


-----  3.1-3.13均值
 select * from 
 (select count(distinct(vid)) num1,visit_date_key  from  fact_page_view 
 where visit_date_key between 20170301 and 20170313  
and application_key in(10,20)
group by visit_date_key) a left join 

(SELECT  count(distinct(vid)) num2,visit_date_key  from fact_page_view   s where visit_date_key  between  20170301 and 20170313  
and page_name='Good'
and application_key in(10,20)
group by visit_date_key )  b on a.visit_date_key=b.visit_date_key  left join 

(SELECT  count(distinct(vid)) num3,visit_date_key  from fact_page_view s where visit_date_key  between  20170301 and 20170313  
and page_name='OrderConfirm'
and application_key in(10,20)
group by visit_date_key ) c  on a.visit_date_key=c.visit_date_key  left join 


(
select count(distinct(vid)) num4,add_time 

 from factec_order where add_time between  20170301 and 20170313  
and   APP_NAME in ('KLGiPhone','KLGAndroid')
group by add_time
)  d on a.visit_date_key=d.add_time  left join 


(
select count(distinct(vid)) num5,add_time from factec_order where add_time between  20170301 and 20170313   
and   APP_NAME in ('KLGiPhone','KLGAndroid')
and order_state>10
group by add_time
)  e on a.visit_date_key=e.add_time


------   3.1-3.13均值  新

select * from 
 (select count(distinct(vid)) num1,visit_date_key  from  fact_page_view 
 where visit_date_key between 20170301 and 20170313  
and application_key in(10,20)
and vid in (select vid from fact_visitor_register where CREATE_DATE_KEY between 20170301 and 20170313
and APPLICATION_KEY in(10,20))
group by visit_date_key) a left join 

(SELECT  count(distinct(vid)) num2,visit_date_key  from fact_page_view   s where visit_date_key  between  20170301 and 20170313  
and page_name='Good'
and application_key in(10,20)
and vid in (select vid from fact_visitor_register where CREATE_DATE_KEY between 20170301 and 20170313
and APPLICATION_KEY in(10,20))
group by visit_date_key )  b on a.visit_date_key=b.visit_date_key  left join 

(SELECT  count(distinct(vid)) num3,visit_date_key  from fact_page_view s where visit_date_key  between  20170301 and 20170313  
and page_name='OrderConfirm'
and application_key in(10,20)
and vid in (select vid from fact_visitor_register where CREATE_DATE_KEY between 20170301 and 20170313
and APPLICATION_KEY in(10,20))
group by visit_date_key ) c  on a.visit_date_key=c.visit_date_key  left join 


(
select count(distinct(vid)) num4,add_time 
from factec_order where add_time between  20170301 and 20170313  
and   APP_NAME in ('KLGiPhone','KLGAndroid')
and vid in (select vid from fact_visitor_register where CREATE_DATE_KEY between 20170301 and 20170313
and APPLICATION_KEY in(10,20))
group by add_time
)  d on a.visit_date_key=d.add_time  left join 


(
select count(distinct(vid)) num5,add_time from factec_order where add_time between  20170301 and 20170313   
and   APP_NAME in ('KLGiPhone','KLGAndroid')
and order_state>10
and vid in (select vid from fact_visitor_register where CREATE_DATE_KEY between 20170301 and 20170313
and APPLICATION_KEY in(10,20))
group by add_time
)  e on a.visit_date_key=e.add_time

----zhengti 
SELECT sum(uv)/count(distinct(visit_date_key)),PAGE_NAME FROM (
select PAGE_NAME,COUNT(DISTINCT(VID)) uv,visit_date_key from   fact_page_view 
 where visit_date_key between 20170301 and 20170313  
and application_key in(10,20)
and page_name not like '%SL_%' 
GROUP BY visit_date_key,PAGE_NAME)
group by PAGE_NAME
----

SELECT sum(uv)/count(distinct(visit_date_key)),PAGE_NAME FROM (
select PAGE_NAME,COUNT(DISTINCT(VID)) uv,visit_date_key from   fact_page_view 
 where visit_date_key between 20170301 and 20170313  
and application_key in(10,20)
and vid in (select vid from fact_visitor_register where CREATE_DATE_KEY between 20170301 and 20170313)
and page_name not like '%SL_%' 
GROUP BY visit_date_key,PAGE_NAME)
group by PAGE_NAME


----
select page_name,sum(uv) from (
SELECT page_name,uv FROM (
select SUM(UV)/count(distinct(START_DATE_KEY)) uv,LEFT_PAGE_KEY from (
select  LEFT_PAGE_KEY,count(distinct(vid)) UV,START_DATE_KEY from fact_session where 
START_DATE_KEY between 20170301 and 20170313 
and application_key in(10,20)
group by START_DATE_KEY,LEFT_PAGE_KEY)
GROUP BY LEFT_PAGE_KEY) AD LEFT JOIN DIM_PAGE DF ON AD.LEFT_PAGE_KEY=DF.PAGE_KEY
) group by page_name
------- 
select page_name,sum(uv) from (
SELECT page_name,uv FROM (
select SUM(UV)/count(distinct(START_DATE_KEY)) uv,LEFT_PAGE_KEY from (
select  LEFT_PAGE_KEY,count(distinct(vid)) UV,START_DATE_KEY from fact_session where 
START_DATE_KEY between 20170301 and 20170313 
and application_key in(10,20)
and vid in (select vid from fact_visitor_register where CREATE_DATE_KEY between 20170301 and 20170313)
group by START_DATE_KEY,LEFT_PAGE_KEY)
GROUP BY LEFT_PAGE_KEY) AD LEFT JOIN DIM_PAGE DF ON AD.LEFT_PAGE_KEY=DF.PAGE_KEY
) group by page_name
