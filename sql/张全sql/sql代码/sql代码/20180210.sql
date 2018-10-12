-------会员唤醒

select  count(distinct(MEMBER_KEY)) from fact_session where  
START_DATE_KEY   between 20180101 and 20180131  
and  APPLICATION_KEY in (10,20)
and member_key in

(select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME<=20171031  ) and member_key not in 
(select distinct(MEMBER_KEY) from  fact_session where  
START_DATE_KEY   between 20171101 and 20171231 
and  APPLICATION_KEY in (10,20)
)


---- 次月留存率
select  (
select count(distinct vid) from  fact_session where START_DATE_KEY between 20180101 and 20180131
and  APPLICATION_KEY in (10,20)
and  vid in (select VID from fact_visitor_register where CREATE_DATE_KEY
 between 20171201 and 20171231 and  APPLICATION_KEY in (10,20)))/(select count(VID) from fact_visitor_register where CREATE_DATE_KEY
 between 20171201 and 20171231 and  APPLICATION_KEY in (10,20)) from dual
 
 
 ----APP重购
 select 
 
 (select count(distinct MEMBER_KEY) from factec_order where add_time between 20180101 and 20180131
 and order_state>10
 and APP_NAME in ('KLGiPhone','KLGAndroid')
 and MEMBER_KEY in (
  
 select distinct MEMBER_KEY from factec_order where add_time between 20171201 and 20171231
 and order_state>10
 and APP_NAME in ('KLGiPhone','KLGAndroid')
 ))/(
  
 select count(distinct MEMBER_KEY) from factec_order where add_time between 20171201 and 20171231
 and order_state>10
 and APP_NAME in ('KLGiPhone','KLGAndroid')
 ) from dual
 
 
 -----运营专题问题查找
 
 select * from fact_daily_zhuangti where ---ZT_START_DATE=20180208  and
 ZT_NAME='御泥坊上市红利日'
 
 ----COUNT(distinct vid),count(1),APPLICATION_KEY 
 select  * from  fact_page_view where visit_date_key=20180208
 and page_name='WZT2' AND PAGE_VALUE='xLI77PC6HmUP1U6' 
 and APPLICATION_KEY=50 group by APPLICATION_KEY
 
 
 
 ----- 双屏互动流量测算 1020 
 select to_char(VISIT_DATE,'mi'),count(distinct vid),count(1) 
 from fact_page_view where  visit_date_key=20171020
 and page_name='KFZT' AND (PAGE_VALUE='Hbrain1020wechat ' OR PAGE_VALUE='Hbrain1020wechat')
 and VISIT_HOUR =16
 group by to_char(VISIT_DATE,'mi')
 
 
 
 -----双屏互动流量测算 猜拳
 
  select VISIT_HOUR,count(distinct vid),count(1)  from fact_page_view where  visit_date_key=20180121
 and page_name='KFZT'  AND PAGE_VALUE='aiQuan0116wechat' 
 group by VISIT_HOUR
 
 -------双11
 
   select VISIT_HOUR,count(distinct vid),count(1)  from fact_page_view where  visit_date_key=20171106
 and page_name='KFZT'  AND PAGE_VALUE='bqqd1111apppc' 
 group by VISIT_HOUR
 
 
 ------百万答题数据拆解
 
 
    select *  from fact_page_view where  visit_date_key=20180209
 and (( page_name='KFZT'  AND PAGE_VALUE LIKE '%DT_%' ) or (page_name='Share' ))
 and vid='wx'
 group by VISIT_HOUR
 
 
 -----
 select * from dim_wechat
 
 
 select * from fact_daily_wx where VISIT_DATE_KEY between 20171010 and 20171022

----10983  9723

select count(distinct vid) from  fact_page_view where visit_date_key=20180211
and page_name='HappigoSign'
and LAST_PAGE_KEY in(
select distinct PAGE_KEY from fact_page_view where visit_date_key=20180211
and page_name='MemberRights_Home')


select count(distinct vid),APPLICATION_KEY,visit_date_key from  fact_page_view where 
visit_date_key between 20170126  and 20170130 and APPLICATION_KEY=50
group by APPLICATION_KEY,visit_date_key


select count(1) from dim_wechat where CREAT_TIME=20180210
