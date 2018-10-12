
------类目商品详情转化
------ 商品访问
 select * from 
 (select GC_NAME,VISIT_DATE_KEY,count(distinct(vid)) as 访问 from 
 (select vid,to_char(PAGE_VALUE) PAGE_VALUE,VISIT_DATE_KEY from fact_page_view  where  VISIT_DATE_KEY between 20180601 and 20180631
 and APPLICATION_KEY in (10,20)
 and page_name='Good')  a  left join 
  (select  GC_NAME,to_char(GOODS_COMMONID)  GOODS_COMMONID from(
 select  GOODS_COMMONID,MATDL  from  dim_ec_good) aa join 
 
 (select MATDL,GC_NAME from DIM_GOOD_CLASS) bb on aa.MATDL=bb.MATDL  group by GC_NAME,GOODS_COMMONID) b 
 on a.PAGE_VALUE=b.GOODS_COMMONID
 group  by GC_NAME,VISIT_DATE_KEY)  a left  join 
 
 -------  加购物车 or 订购 
(  select GC_NAME,VISIT_DATE_KEY,count(distinct(vid)) as 订购 from 
 (select vid,to_char(PAGE_VALUE) PAGE_VALUE,VISIT_DATE_KEY from fact_page_view_hit  where  VISIT_DATE_KEY between 20180601 and 20180631
 and APPLICATION_KEY in (10,20)
and page_name in ('SL_Good_Order','SL_Good_Shoppcar') )  a  left join 
  (select  GC_NAME,to_char(GOODS_COMMONID)  GOODS_COMMONID from(
 select  GOODS_COMMONID,MATDL  from  dim_ec_good) aa join 
 
 (select MATDL,GC_NAME from DIM_GOOD_CLASS) bb on aa.MATDL=bb.MATDL  group by GC_NAME,GOODS_COMMONID) b 
 on a.PAGE_VALUE=b.GOODS_COMMONID
 group  by GC_NAME,VISIT_DATE_KEY) b   on   a.GC_NAME=b.GC_NAME and a.VISIT_DATE_KEY=b.VISIT_DATE_KEY
 
 
 
 ------非扫码购净订购转化率
 select (
 select count(distinct MEMBER_KEY) from factec_order where  APP_NAME='KLGWX' and ORDER_FROM !=76 and  STORE_ID=1
 and add_time=20180221
 and CANCEL_BEFORE_STATE=0 and  CRM_ORDER_NO>0)/
 (select count(distinct vid) from fact_session where START_DATE_KEY=20180221 and  APPLICATION_KEY=50
 and vid not in (select VID from dim_vid_scan where SCAN_DATE_KEY=20180221) )
  from dual
 ------ 当月新注册会员净订购转化率
 select 
(select count(distinct MEMBER_KEY)  from factec_order where add_time between  20171101 and 20180631 and ORDER_STATE>10 and MEMBER_KEY
in (select distinct MEMBER_CRMBP from fact_ecmember where MEMBER_TIME between  20171101 and 20180631)  )
/(select count(distinct MEMBER_CRMBP) from fact_ecmember where MEMBER_TIME between  20171101 and 20180631)  
from dual
 

------- 当月老会员复购人数

(
select count(distinct(MEMBER_KEY))  from factec_order where add_time between  20171101 and 20180631 
and order_state>10 and MEMBER_KEY in (
select distinct(MEMBER_KEY) from factec_order where add_time between  20171001 and 20171031 
and order_state>10  ))



-----当月老会员复购率

select (
select count(distinct(MEMBER_KEY))  from factec_order where add_time between  20171101 and 20180631 
and order_state>10 and MEMBER_KEY in (
select distinct(MEMBER_KEY) from factec_order where add_time between  20171001 and 20171031 
and order_state>10  ))/
(
select count(distinct(MEMBER_KEY)) from factec_order where add_time between  20171001 and 20171031 
and order_state>10  ) from dual

-----视频购商品详情页转化率
select  (select count(distinct ORDER_ID) from factec_order_goods where ORDER_ID
in (select ORDER_ID from factec_order where add_time = 20171117 and  order_state>10)
and EC_GOODS_COMMON in (
select  GOODS_COMMONID from dim_ec_good where IS_VEDIO=1
) )/(
select count(distinct(vid)) from fact_page_view where  VISIT_DATE_KEY=20171117
 and APPLICATION_KEY in (10,20)
 and page_name='Good'
 and page_value  in (
select  to_char(GOODS_COMMONID) from dim_ec_good where IS_VEDIO=1
) group by VISIT_DATE_KEY
)  from dual

 ----------- BBC商品浏览转化率
 select * from (
 select count(distinct(vid)) 浏览人数,VISIT_DATE_KEY from fact_page_view where  VISIT_DATE_KEY between 20171101 and 20180631
 and APPLICATION_KEY in (10,20)
 and page_name='Good'
 and page_value  in (
 select to_char(GOODS_COMMONID) from dim_ec_good where STORE_ID>1
 ) group by VISIT_DATE_KEY) a left join (
 
 select  count(distinct(vid))  订购人数,ADD_TIME from fact_ec_order where ADD_TIME  between 20171101 and 20180631
 and APP_NAME in ('KLGiPhone','KLGAndroid')
 and STORE_ID>1 and order_state>10  group by ADD_TIME
 ) b on a.VISIT_DATE_KEY=b.ADD_TIME
 
 
 ---9110 （8月老会员复购人数）   36640（7月会员订购人数）
 select (
select count(distinct(MEMBER_KEY))  from factec_order where add_time between  20171101 and 20180631 
and (order_state>10  or (order_state=0 and CANCEL_BEFORE_STATE=0))and MEMBER_KEY in (
select distinct(MEMBER_KEY) from factec_order where add_time between  20171101 and 20180631 
and (order_state>10  or (order_state=0 and CANCEL_BEFORE_STATE=0))))/(
select count(distinct(MEMBER_KEY)) from factec_order where add_time between  20171101 and 20180631 
and (order_state>10  or (order_state=0 and CANCEL_BEFORE_STATE=0))) from dual

---12638（8月订购新会员数）   54534（8月注册会员数）
select 
(select count(distinct MEMBER_BP) from dim_member where FIRSTW_ORDER_DATE_KEY between  20171101 and 20180631)
/(select count(distinct MEMBER_CRMBP) from fact_ecmember where MEMBER_TIME between  20171101 and 20180631)  
from dual

---
select 
(SELECT count(1) num1 from (
SELECT MEMBER_KEY,COUNT(1) NUM1 FROM   factec_order where add_time between  20161101 and 20161131
and order_state>10   GROUP BY MEMBER_KEY)
where NUM1>1)/(SELECT COUNT(distinct MEMBER_KEY) NUM1 FROM   factec_order where add_time between  20161101 and 20161131
and order_state>10 ) from dual
 
---------
select * from (
select   count(distinct(vid))  视频购首页,visit_date_key  from   fact_page_view where visit_date_key  between 20171101 and 20180631
 and APPLICATION_KEY in (10,20)
 and page_name='Video_home'
 GROUP BY visit_date_key ) a left join ( 
select   count(distinct(vid))  视频购视频页,visit_date_key  from   fact_page_view where visit_date_key  between 20171101 and 20180631
 and APPLICATION_KEY in (10,20)
 and (page_name='Video_replay' OR page_name='Video_live')
 GROUP BY visit_date_key) b on  a.visit_date_key=b.visit_date_key
 
 
 
 ---------
  
 select  POSTING_DATE_KEY,count(1) from fact_goods_sales  where POSTING_DATE_KEY between 20160101 and 20171201 
 and ORDER_STATE=1 and TRAN_TYPE=0 and  (REPLAY_STATE=1 or LIVE_STATE=1)
 group by POSTING_DATE_KEY
 
 
 ----
 
 select count(distinct member_key) from  factec_order where add_time between 20160101 and 20161131
 and order_state>10
