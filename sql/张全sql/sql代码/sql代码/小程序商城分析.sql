------ 
select * from (
select  count(distinct vid),visit_date_key,count(1)  from fact_page_view where visit_date_key
 between 20180501 and 20180704 and APPLICATION_KEY=70
and (HMSC !='Bargain'  or HMSC is null ) group by visit_date_key)
a join 
(
select count(distinct vid),sum(order_amount),add_time from factec_order where  add_time between   20180501 and 20180704 
and vid like '%wxlitemall%'
and order_state>10  group by add_time
) b on a.visit_date_key=b.add_time 


---------授权用户数
insert into ls_test
(
select  distinct member_key,1,1 from  fact_page_view where visit_date_key
 between 20180501 and 20180704 and APPLICATION_KEY=70
and (HMSC !='Bargain'  or HMSC is null )

)
insert into ls_test
(
select  1,VID,1 from  fact_page_view where visit_date_key
 between 20180601 and 20180704 and APPLICATION_KEY=50
and PAGE_NAME like '%QRC%'
)



select   count(distinct MEMBER_KEY),START_DATE_KEY from fact_session where  START_DATE_KEY 
 between   20180625 and 20180704 
and APPLICATION_KEY=50 
and vid  not in 

(select SNAME from ls_test)
--and member_key in (select  SSID from ls_test)
group by START_DATE_KEY
------------
select  count(distinct vid),START_DATE_KEY from fact_session where  START_DATE_KEY 
 between   20180625 and 20180704 
 and APPLICATION_KEY=50 
 and vid  not in (select SNAME from ls_test)
---and vid like '%wxoeNK%' 
group by START_DATE_KEY

(
select count(distinct vid),sum(order_amount),add_time from factec_order where 
 add_time between    20180625 and 20180704 
and vid like '%wxoeNK%'
and ORDER_FROM =64
and order_state>10  group by add_time
) 

-------
(
select count(distinct member_key) from factec_order where 
 add_time between    20180625 and 20180704 
and vid like '%wxoeNK%'
and ORDER_FROM =64
and order_state>10 
) 

----------
SELECT PAGE_NAME,PAGE_VALUE,AVG(NUM1),AVG(NUM2) FROM (
select PAGE_NAME,PAGE_VALUE,COUNT(DISTINCT ip) NUM1,COUNT(1) NUM2,visit_date_key  from fact_page_view_hit where visit_date_key
 between 20180601 and 20180631 and APPLICATION_KEY=70
and page_name='SL_B2C_ICON'
and (HMSC !='Bargain'  or HMSC is null )  GROUP BY visit_date_key,PAGE_NAME,PAGE_VALUE)
GROUP BY PAGE_NAME,PAGE_VALUE
