select  MEMBER_LEVEL,count(1)  from  dim_member
where--- END_ACTIVE_DATE_KEY>0  and
 LAST_ORDER_DATE_KEY between 20170710 and 20170910
 group by MEMBER_LEVEL
 
 --------  会员复购
 select (
 select count(distinct(MEMBER_KEY)) from factec_order where add_time between  20170101 and 20170131 
and order_state>10 and MEMBER_KEY in (
select distinct(MEMBER_KEY) from factec_order where add_time between 20161201 and 20161231 
and order_state>10))/(
select count(distinct(MEMBER_KEY)) from factec_order where add_time between  20161201 and 20161231 
and order_state>10) from dual
 
-----  会员再购 
select (select  count(1) from 
(
select MEMBER_KEY,count(1) num1 from factec_order where add_time between  20170101 and 20170131 
and order_state>10 group by MEMBER_KEY) where num1>1)/
(
select count(distinct(MEMBER_KEY)) from factec_order where add_time between  20170101 and 20170131 
and order_state>10) from dual

----新会员
select 
(select count(distinct MEMBER_BP) from dim_member where FIRSTW_ORDER_DATE_KEY between  20170101 and 20170131)
/(select count(distinct MEMBER_CRMBP) from fact_ecmember where MEMBER_TIME between  20170101 and 20170131)  
from dual



------
select num1,count(1) from (
select MEMBER_KEY,count(1) num1 from factec_order where ADD_TIME between 20170101 and 20170831
and ORDER_STATE>10
and MEMBER_KEY in (
select MEMBER_CRMBP from  fact_ecmember where  MEMBER_TIME  between 20170101 and 20170831
)
group by MEMBER_KEY) group  by num1

-----   用户客单价
select avg(order_amount) from factec_order where aDD_TIME between 20170101 and 20170831
and ORDER_STATE>10 and ORDER_ID in (
select max(ORDER_ID) ORDER_ID from factec_order where aDD_TIME between 20170101 and 20170831
and ORDER_STATE>10 and MEMBER_KEY in (

select MEMBER_KEY from (

(
select MEMBER_KEY,count(1) num1 from factec_order where ADD_TIME between 20170101 and 20170831
and ORDER_STATE>10
and MEMBER_KEY in (
select MEMBER_CRMBP from  fact_ecmember where  MEMBER_TIME  between 20170101 and 20170831
)
group by MEMBER_KEY)
) where num1=5)
group by MEMBER_KEY)


---订购时长
select avg(to_char(to_date(NUM1)-to_date(NUM2)))  from 
(select NUM2,NUM1 from (
select MEMBER_KEY, median(ADD_TIME) num2 from factec_order where ADD_TIME between 20170101 and 20170831
and ORDER_STATE>10
and MEMBER_KEY in (

select MEMBER_KEY from (

(
select MEMBER_KEY,count(1) num1 from factec_order where ADD_TIME between 20170101 and 20170831
and ORDER_STATE>10
and MEMBER_KEY in (
select MEMBER_CRMBP from  fact_ecmember where  MEMBER_TIME  between 20170101 and 20170831
)
group by MEMBER_KEY)
) where num1=4)  group by MEMBER_KEY
) a left join 
(
select MEMBER_KEY,max(ADD_TIME) num1 from factec_order where ADD_TIME between 20170101 and 20170831
and ORDER_STATE>10
and MEMBER_KEY in (

select MEMBER_KEY from (

(
select MEMBER_KEY,count(1) num1 from factec_order where ADD_TIME between 20170101 and 20170831
and ORDER_STATE>10
and MEMBER_KEY in (
select MEMBER_CRMBP from  fact_ecmember where  MEMBER_TIME  between 20170101 and 20170831
)
group by MEMBER_KEY)
) where num1=4)  group by MEMBER_KEY
) b  on a.MEMBER_KEY=b.MEMBER_KEY) where NUM1>0
