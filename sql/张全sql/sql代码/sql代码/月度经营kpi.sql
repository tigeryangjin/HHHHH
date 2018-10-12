
-----APP月活  
select  count(distinct(vid)) from fact_session  where  START_DATE_KEY between 20161101 and 20161131
and APPLICATION_KEY in (10,20)

-----次月留存率   
select  ( 
select  count(distinct(vid)) from fact_session  where  START_DATE_KEY between 20161101 and 20161131
and APPLICATION_KEY in (10,20)
and vid in (select  vid  from fact_visitor_register  where  CREATE_DATE_KEY between 20161001 and 20161031
and APPLICATION_KEY in (10,20)))/(
select  count(distinct(vid)) from fact_visitor_register  where  CREATE_DATE_KEY between 20161001 and 20161031
and APPLICATION_KEY in (10,20)) from dual

----- 沉睡唤醒数（日均）
select  count(distinct(MEMBER_KEY))/count(distinct(START_DATE_KEY)) from fact_session where  
START_DATE_KEY   between 20161101 and 20161131  
and  APPLICATION_KEY in (10,20)
and member_key in
(select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME<=20160831  ) and member_key not in 
(select distinct(MEMBER_KEY) from  fact_session where  
START_DATE_KEY   between 20160901 and 20161031 
and  APPLICATION_KEY in (10,20)
)
