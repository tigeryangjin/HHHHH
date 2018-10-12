

---------扫码人数(新扫码人数)

select count(distinct(vid)), visit_date_key from fact_page_view ss where ss.visit_date_key between 20161105 and 20161124 and ss.page_name='TV_QRC'
 and vid in (select vid from fact_visitor_register where CREATE_DATE_KEY=ss.visit_date_key and APPLICATION_KEY=30)
 group by visit_date_key
 
 
 
 ---------扫码人数(总扫码人数)

select count(distinct(vid)), visit_date_key from fact_page_view ss where ss.visit_date_key between 20161125 and 20161201 and ss.page_name='TV_QRC'
group by visit_date_key
 
 ------注册人数 
  select count(1)from fact_member_register where REGISTER_DATE_KEY=20161125 and APPLICATION_KEY in (40,50)
 and DEVICE_KEY iN (
 select distinct(DEVICE_KEY) from fact_page_view ss where ss.visit_date_key = 20161125 and ss.application_key in (40,50) 
 and IP in (select distinct(IP) from fact_page_view  where visit_date_key=ss.visit_date_key  and page_name='TV_QRC')
 ) 

 
 
 ---快乐购第一单
 select count(1),ADD_TIME from ( 
 select member1,ADD_TIME,MEMBER_BP from 
  (select member_key as member1,add_time from factec_order where add_time between 20161124 and 20161201 
 and  order_from=76 and  ORDER_STATE>0  
 group by add_time,member_key)  a  left join  dim_member b on a.member1=b.MEMBER_BP and  FIRST_ORDER_DATE_KEY= add_time
 ) where  MEMBER_BP is not null  group by ADD_TIME
 
 
 
 
 
 ---电商第一单
 select * from dim_member
  select count(1),ADD_TIME from ( 
 select member1,ADD_TIME,MEMBER_BP from 
  (select member_key as member1,add_time from factec_order where add_time between 20161124 and 20161201 
 and  order_from=76 and  ORDER_STATE>0  
 group by add_time,member_key)  a  left join  dim_member b on a.member1=b.MEMBER_BP and  FIRSTW_ORDER_DATE_KEY= add_time
 ) where  MEMBER_BP is not null  group by ADD_TIME
 
 
 
 
 --净订购订单
 
 select count(distinct(member_key)),sum(ORDER_AMOUNT),add_time from factec_order where add_time between 20161105 and 20161201 
 and  order_from=76 and  ORDER_STATE>0  
 group by add_time
 
 
 
 
 
 
 
----内部来源新会员

select * from fact_page_view 
 
-----clv 模型

select * from 
(select MEMBER_BP,REGISTER_RESOURCE,VALIDW_ORDERAMOUNT,VALIDW_ORDERCOUNT from dim_member 
where  END_ACTIVE_DATE_KEY  >20160000) 
a left join 
(select sum(ORDER_AMOUNT) as a1,MEMBER_KEY,count(1)  as b1 from fact_order where  SALES_SOURCE_KEY=20 and 
ORDER_DATE_KEY between 20161001 and 20161128
and ORDER_STATE=1 group by MEMBER_KEY)b
on a.MEMBER_BP=b.MEMBER_KEY
 
left join
(select sum(ORDER_AMOUNT) as a2,MEMBER_KEY,count(1) as b2 from fact_order where  SALES_SOURCE_KEY=20 and 
ORDER_DATE_KEY between 20160701 and 20161128
and ORDER_STATE=1 group by MEMBER_KEY) c
on a.MEMBER_BP=c.MEMBER_KEY
left join
(select sum(ORDER_AMOUNT) as a3,MEMBER_KEY,count(1) as b3 from fact_order where  SALES_SOURCE_KEY=20 and 
ORDER_DATE_KEY between 20160401 and 20161128
and ORDER_STATE=1 group by MEMBER_KEY)d
on a.MEMBER_BP=d.MEMBER_KEY
left join
(select sum(ORDER_AMOUNT) as a4,MEMBER_KEY,count(1) as b4 from fact_order where  SALES_SOURCE_KEY=20 and 
ORDER_DATE_KEY between 20160101 and 20161128
and ORDER_STATE=1 group by MEMBER_KEY)e
 on a.MEMBER_BP=e.MEMBER_KEY
 
 
 
 
 ---- 内部流量 
 select * from  fact_page_view ww where ww.page_name='appdownload'
 
 
 select sum(ORDER_AMOUNT),count(distinct(MEMBER_KEY)) from fact_order where  SALES_SOURCE_KEY=20 and 
ORDER_DATE_KEY between 20160101 and 20161128
and ORDER_STATE=1 and MEMBER_KEY in (
 
 select MEMBER_BP from dim_member where   REGISTER_RESOURCE!='B2C' and FIRST_ORDER_DATE_KEY<FIRSTW_ORDER_DATE_KEY
 and FIRSTW_ORDER_DATE_KEY>20160100)
 
-----------PC/WAP 
SELECT * FROM 
(select * from (
select FIRST_ACTIVE_VID,VALIDW_ORDERAMOUNT,VALIDW_ORDERCOUNT,VID,HMSC,FIRST_IP,CREATE_DATE_KEY,APPLICATION_KEY
 from (
select   FIRST_ACTIVE_VID,VALIDW_ORDERAMOUNT,VALIDW_ORDERCOUNT from dim_member  where  FIRSTW_ORDER_DATE_KEY>=20160101  and FIRSTW_ORDER_DATE_KEY<=20161031 
and  VALIDW_ORDERAMOUNT>0  and FIRST_ACTIVE_DATE_KEY>=20160101 ) a left join 
(
select VID,HMSC,FIRST_IP,CREATE_DATE_KEY,APPLICATION_KEY from fact_visitor_register  where  CREATE_DATE_KEY>=20160101 
) b  on a.FIRST_ACTIVE_VID=b.vid
) where APPLICATION_KEY >20  AND APPLICATION_KEY!=50) a  
left join (
select DISTINCT(VID) as vid from fact_visitor_active where  LEVEL1 in('DSP','SEM','CPS'))b  on a.vid=b.vid


-------微信
select * from(
select VID,ORDER_IP,ADD_TIME from  fact_ec_order  where   ORDER_STATE>0 and ADD_TIME>20160101 and  order_from=64
 ) a left join (
select ip,VISIT_DATE_KEY from  fact_page_view www where   VISIT_MONTH>=201601 and
 www.application_key=30 and www.page_name in('appdownload','TV_QRC','ScanGoods','ScanTvlist','Tv_download') 
 )b  on a.ORDER_IP=b.ip and a.ADD_TIME=b.VISIT_DATE_KEY


select * from DIM_SCAN_CODE_DAY


-----------


select * from (
select FIRST_ACTIVE_VID,VALIDW_ORDERAMOUNT,VALIDW_ORDERCOUNT,VID,HMSC,FIRST_IP,CREATE_DATE_KEY,APPLICATION_KEY
 from (
select   FIRST_ACTIVE_VID,VALIDW_ORDERAMOUNT,VALIDW_ORDERCOUNT from dim_member  where  FIRSTW_ORDER_DATE_KEY>=20160101  and FIRSTW_ORDER_DATE_KEY<=20161031 
and  VALIDW_ORDERAMOUNT>0  and FIRST_ACTIVE_DATE_KEY>=20160101  and FIRST_ACTIVE_VID like '%wxoeNKjj%') a left join 
(
select VID,HMSC,FIRST_IP,CREATE_DATE_KEY,APPLICATION_KEY from fact_visitor_register  where  CREATE_DATE_KEY>=20160101 
) b  on a.FIRST_ACTIVE_VID=b.vid
) where  APPLICATION_KEY=50

------------
select GOODS_NAME,GOODS_COMMON_KEY,nums,COST_PRICE,ORDER_AMOUNT from 

(select GOODS_COMMON_KEY,sum(NUMS) as nums,sum(COST_PRICE) as COST_PRICE ,sum(ORDER_AMOUNT) as ORDER_AMOUNT from fact_goods_sales  where 
 POSTING_DATE_KEY between 20161101 and 20161131
  and  SALES_SOURCE_SECOND_KEY=20018  and ORDER_STATE=1
  
  group by GOODS_COMMON_KEY) a left join dim_good b  on a.GOODS_COMMON_KEY=b.ITEM_CODE
  

  


select  * from fact_page_view ss where url like '%http://m.happigo.com/GoodsClass/showSubClass/pid/%'
 and ss.visit_date_key=20161130 



select count(1),sum(ORDER_AMOUNT),ADD_TIME from factec_order  tt where tt.order_from=76  and  tt.APP_NAME='KLGWX' and
ADD_TIME between 20161201 and 20161201 and tt.order_state>0  group by  ADD_TIME;

select count(1),sum(ORDER_AMOUNT),ADD_TIME from factec_order  tt where tt.APP_NAME='KLGWX'  and  
ADD_TIME between 20161201 and 20161201 and tt.order_state>0  group by  ADD_TIME;


select * from factec_order


