
 -----扫码分析
 select a.VISIT_DATE_KEY,num1,num2,num3,num4,num5 from 
 (select count(distinct(vid)) num1 ,visit_date_key  from  fact_page_view 
 where visit_date_key=20170605 
and page_name='TV_QRC'
group by visit_date_key) a left join 

(SELECT  round(count(distinct(vid)))  num2,visit_date_key  from fact_page_view   s where 
visit_date_key=20170605  
and page_name='Good'
and APPLICATION_key in (30,50)
and  ip in (
 select ip from fact_page_view   where  
 VISIT_DATE_KEY=20170605  
 AND page_name='TV_QRC')
group by visit_date_key )  b on a.visit_date_key=b.visit_date_key  left join 
(SELECT  round(count(distinct(vid))) num3,visit_date_key  from fact_page_view s where 
visit_date_key=20170605  
and page_name='OrderConfirm'
and APPLICATION_key in (30,50)
and ip in (
 select ip from fact_page_view   where  
 VISIT_DATE_KEY=20170605  
 AND page_name='TV_QRC')
group by visit_date_key ) c  on a.visit_date_key=c.visit_date_key  left join 
(
select count(distinct(vid)) num4,add_time from factec_order where 
add_time=20170605   
and order_from=76
group by add_time
)  d on a.visit_date_key=d.add_time  left join 
(
select count(distinct(vid)) num5,add_time from factec_order where 
add_time=20170605  
and order_state>10
and order_from=76
group by add_time
)  e on a.visit_date_key=e.add_time 


------  扫码购新会员订购 
select count(1),add_time from factec_order where add_time  between 20170410 and 20170617 
and order_from=76
and order_state>10
and MEMBER_KEY in(
select MEMBER_KEY from (
select min(add_time) add_time,MEMBER_KEY from factec_order  where   MEMBER_KEY in (
select MEMBER_KEY from factec_order where add_time  between 20170410 and 20170617 
and order_from=76
and order_state>10) 
group by MEMBER_KEY) where add_time between 20170410 and 20170617 
)
group by add_time

 
----扫码购新会员访问


select count(distinct(vid)) num1 ,visit_date_key  from  fact_page_view 
 where visit_date_key=201706018 
and page_name='TV_QRC'
and vid in  (select VID from fact_visitor_register where  APPLICATION_KEY=30 and  CREATE_DATE_KEY=201701608   )
group by visit_date_key

















------商品销售、订购人数、订购件数、库存
select ITEM_CODE 商品编号,GOODS_NAME 商品名称,MATDLT 物料大类
,GROUP_NAME 提报组,MEMBER_TIME 用户类型
,sum(GOODS_PAY_PRICE) 销售金额,sum(GOODS_NUM) 销售件数,count(distinct(member_key))
 订购人数,avg(GOODS_STOCK) 库存
 from (
select bss.ITEM_CODE  ITEM_CODE,bss.GOODS_NAME  GOODS_NAME,MATDLT ,GROUP_NAME ,
GOODS_NUM ,GOODS_PAY_PRICE ,(case
                   when MEMBER_TIME = 20170317  then  '新用户'
                   else '老用户'end) MEMBER_TIME ,member_key,GOODS_STOCK   from 
(select ORDER_ID,MEMBER_KEY,ADD_TIME,ORDER_AMOUNT,APP_NAME,ORDER_STATE from factec_order 
where ORDER_STATE>10 and ADD_TIME=20170317) ass
left join 
(select ITEM_CODE,GOODS_NAME,ORDER_ID,GOODS_NUM,GOODS_PAY_PRICE from factec_order_goods where 
GOODS_TYPE!=5 and GOODS_TYPE!=6) bss
on ass.order_id=bss.order_id  
left join   fact_ecgoods_stock cdd on bss.item_code=cdd.item_code
left join   dim_good  sdd on bss.item_code=sdd.item_code
left join   fact_ecmember sds on ass.member_key=sds.member_crmbp)
group by ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,MEMBER_TIME;



select * from fact_page_view where  visit_date_key between 20170619 and 20170623
and MEMBER_KEY in 
(
select SSID from ls_test) 

-----------------
SELECT A.VISIT_DATE_KEY 日期,A.APPLICATION_NAME 渠道名称,NUM1 日活1,NUM2 商品详情,num4,NUM3 订单提交页 FROM 
(select count(distinct(vid)) num1,visit_date_key,
(case
  when APPLICATION_NAME = 'KLGPortal'  then 'KLGPortal'
  when APPLICATION_NAME = 'KLGMPortal'  then 'KLGMPortal'
  when APPLICATION_NAME = 'KLGWX' OR  APPLICATION_NAME = 'klgwx' then 'KLGWX'
  else 'KLGAPP' end ) APPLICATION_NAME

from fact_page_view where visit_date_key  between  to_char(sysdate-9,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')  
and page_name not like '%download%' and page_name!='TV_QRC'
group by visit_date_key,(case
  when APPLICATION_NAME = 'KLGPortal'  then 'KLGPortal'
  when APPLICATION_NAME = 'KLGMPortal'  then 'KLGMPortal'
  when APPLICATION_NAME = 'KLGWX' OR  APPLICATION_NAME = 'klgwx' then 'KLGWX'
  else 'KLGAPP' end ) ) A
LEFT JOIN 
(select count(distinct(vid)) num2,visit_date_key ,(case
  when APPLICATION_NAME = 'KLGPortal'  then 'KLGPortal'
  when APPLICATION_NAME = 'KLGMPortal'  then 'KLGMPortal'
  when APPLICATION_NAME = 'KLGWX' OR  APPLICATION_NAME = 'klgwx' then 'KLGWX'
  else 'KLGAPP' end ) APPLICATION_NAME
from fact_page_view where visit_date_key between  to_char(sysdate-9,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd') 
and page_name='Good'
group by visit_date_key,(case
  when APPLICATION_NAME = 'KLGPortal'  then 'KLGPortal'
  when APPLICATION_NAME = 'KLGMPortal'  then 'KLGMPortal'
  when APPLICATION_NAME = 'KLGWX' OR  APPLICATION_NAME = 'klgwx' then 'KLGWX'
  else 'KLGAPP' end ) ) B 
 ON A.visit_date_key=B.visit_date_key AND A.APPLICATION_NAME=B.APPLICATION_NAME
LEFT JOIN 

(select count(distinct(vid)) num3,visit_date_key ,(case
  when APPLICATION_NAME = 'KLGPortal'  then 'KLGPortal'
  when APPLICATION_NAME = 'KLGMPortal'  then 'KLGMPortal'
  when APPLICATION_NAME = 'KLGWX' OR  APPLICATION_NAME = 'klgwx' then 'KLGWX'
  else 'KLGAPP' end ) APPLICATION_NAME
from fact_page_view where visit_date_key between  to_char(sysdate-9,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd') 
and page_name='OrderConfirm'
group by visit_date_key,(case
  when APPLICATION_NAME = 'KLGPortal'  then 'KLGPortal'
  when APPLICATION_NAME = 'KLGMPortal'  then 'KLGMPortal'
  when APPLICATION_NAME = 'KLGWX' OR  APPLICATION_NAME = 'klgwx' then 'KLGWX'
  else 'KLGAPP' end ) ) C 
 ON A.visit_date_key=C.visit_date_key AND A.APPLICATION_NAME=C.APPLICATION_NAME
 
 LEFT JOIN 

(select count(distinct(vid)) num4,visit_date_key ,(case
  when APPLICATION_NAME = 'KLGPortal'  then 'KLGPortal'
  when APPLICATION_NAME = 'KLGMPortal'  then 'KLGMPortal'
  when APPLICATION_NAME = 'KLGWX' OR  APPLICATION_NAME = 'klgwx' then 'KLGWX'
  else 'KLGAPP' end ) APPLICATION_NAME
from fact_page_view where visit_date_key between  to_char(sysdate-9,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd') 
and (page_name='ShoppingCart' or page_name='ShoppingCar')
group by visit_date_key,(case
  when APPLICATION_NAME = 'KLGPortal'  then 'KLGPortal'
  when APPLICATION_NAME = 'KLGMPortal'  then 'KLGMPortal'
  when APPLICATION_NAME = 'KLGWX' OR  APPLICATION_NAME = 'klgwx' then 'KLGWX'
  else 'KLGAPP' end ) ) D 
 ON A.visit_date_key=D.visit_date_key AND A.APPLICATION_NAME=D.APPLICATION_NAME
 
 
 -----热力图
 select  round(sum(nums)/count(distinct(visit_date_key))),page_name from (
 select count(distinct(vid)) nums,page_name,visit_date_key  from fact_page_view_hit sd where 
 visit_date_key between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
 and  sd.application_key in(10,20) and  sd.page_name like '%SL_B2C%'
 group by page_name,visit_date_key)
 group by page_name;
 ---TV
  select  round(sum(nums)/count(distinct(visit_date_key))),page_name from (
 select count(distinct(vid)) nums,page_name,visit_date_key  from fact_page_view_hit sd 
 where visit_date_key between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
 and  sd.application_key in(10,20) and  sd.page_name like '%SL_TV_%'
 group by page_name,visit_date_key)
 group by page_name
 

 ---- B2C_icon
   select  round(sum(nums)/count(distinct(visit_date_key))),page_value from (
 select count(distinct(vid)) nums,page_value,visit_date_key  from fact_page_view_hit sd 
 where visit_date_key between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
 and  sd.application_key in(10,20) and  sd.page_name like '%LS_B2C_%'
 group by page_value,visit_date_key)
 group by page_value
 
 ------TV_ICON
    select  round(sum(nums)/count(distinct(visit_date_key))),page_value from (
 select count(distinct(vid)) nums,page_value,visit_date_key  from fact_page_view_hit sd 
 where visit_date_key between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
 and  sd.application_key in(10,20) and  sd.page_name like '%LS_TV_%'
 group by page_value,visit_date_key)

 group by page_value
 
  
 
 



