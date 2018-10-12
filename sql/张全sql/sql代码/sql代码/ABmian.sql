select count(distinct(vid)),visit_date_key,page_name from fact_page_view where visit_date_key between 20170316 and 20170320 
and   APPLICATION_KEY in (10,20)
and VER_NAME in('7.1.0','7.1.2')
and ( page_name like '%_TV_%' OR PAGE_NAME='Home_TVLive')
GROUP BY visit_date_key,page_name



select * from fact_order_reverse

----  庆生17-19号之间，来访未订购的会员中，将商品加入过购物车、商品提交订单未付款的会员，发180套券（199-30；339-50；599-100）和短信；
----9517 人
 
select distinct(MEMBER_KEY) from fact_session where  START_DATE_KEY between 20170317 and 20170319
and MEMBER_KEY
not in (select MEMBER_KEY from factec_order where add_time   between 20170317 and 20170319
and PAYMENT_TIME>0)
and MEMBER_KEY
in (
select MEMBER_KEY from fact_shoppingcar  where CREATE_DATE_KEY  between 20170317 and 20170319);

------  3月全月订购满2次，每次300以上的会员，发短信提示再订购一次得30元0门槛，4月可用；(电商渠道)

select MEMBER_KEY from (
select MEMBER_KEY,count(1) num from  factec_order where  ADD_TIME between 20170301 and 20170319 
and ORDER_AMOUNT>=300
and ORDER_STATE>10
group by MEMBER_KEY) where num>1


------  17-19订购的会员，在17-今非用户主观原因退货的，发180套券（199-30；339-50；599-100）和短信；


select * from (
select  MEMBER_KEY,ONE_REASON,TWO_REASON from fact_order_reverse where 
 ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY=20 
 and CANCEL_STATE=0
 and REJECT_RETURN !=20
 ) aq left join dim_re_reseaon_2
sw on aq.two_reason=sw.code
left join   dim_re_reseaon_1 de
on aq.ONE_REASON=de.code
 ---
 
 select count(1),ADD_TIME,sum(ORDER_AMOUNT) from factec_order where ADD_TIME between 20170301 and 20170320 
 and  vid in 
 (
 select VID from fact_visitor_register where  CREATE_DATE_KEY  between 20170201 and 20170320 
 and  HMSC in ( 'idvertyyq','idvertyyq2')
 )
 ---and order_state>10
--- and  CANCEL_BEFORE_STATE=1
 group by ADD_TIME


 select VID,CREATE_DATE_KEY from fact_visitor_register where  CREATE_DATE_KEY  between 20170201 and 20170320 
 and vid in ( 
 select distinct(vid) from factec_order where ADD_TIME between 20170301 and 20170320 
 and  vid in 
 (
 select VID from fact_visitor_register where  CREATE_DATE_KEY  between 20170201 and 20170320 
 and  HMSC in ( 'idvertyyq','idvertyyq2')
 )
 ---and order_state>10
--- and  CANCEL_BEFORE_STATE=1
)
 

 
select * from factec_order  where ADD_TIME=2017032

select count(1)/30 from (
select MEMBER_KEY,count(1) num1 from  fact_order  where  SALES_SOURCE_KEY=20 and
ORDER_DATE_KEY between 20170201 and 20170304  
and order_state=1 and ORDER_AMOUNT>199
group by MEMBER_KEY)
where  num1>=3


select sum(MAX1-min1)/count(1) from 
(select VALIDW_ORDERCOUNT,FIRSTW_ORDER_DATE_KEY,MEMBER_KEY,max1,min1 from(
select max(ORDER_DATE_KEY) as max1 ,min(ORDER_DATE_KEY) as min1,MEMBER_KEY from fact_order 
where ORDER_DATE_KEY between 20170101 and 20170301  
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from  fact_order  where  SALES_SOURCE_KEY=20 and
ORDER_DATE_KEY between 20170101 and 20170301  
and order_state=1 group by MEMBER_KEY)
where  num1=2)
group by MEMBER_KEY
)  a left join dim_member b on a.MEMBER_KEY=b.member_bp
) where VALIDW_ORDERCOUNT=2

----

select count(1),sum(order_amount) from (
select MEMBER_KEY,count(1) num1,sum(order_amount) order_amount  from  fact_order  where  SALES_SOURCE_KEY=20 and
ORDER_DATE_KEY between 20160101 and 20170101  
and order_state=1 group by MEMBER_KEY
) where num1>=13     or order_amount>8000 

--11325   93265783


-----A/B面的数据
--1上线以来总流量对比
 select VISIT_DATE_KEY,UVCNT from fact_daily_app where VISIT_DATE_KEY between 20170307 and 20170321 
 
 ---
 select page_name,VISIT_DATE_KEY,sum(PAGE_STAYTIME)/count(1),count(distinct(vid)),count(1) from 
 fact_page_view where  VISIT_DATE_KEY ss between 20170307 and 20170321 
 and page_name in ('Home','Home_TVLive')
 and APPLICATION_KEY in (10,20)
 group by page_name,VISIT_DATE_KEY
 
 
 ---转化漏斗  订单提交页页面分析
 
 select count(distinct(vid)) from fact_page_view where VISIT_DATE_KEY between 20170314 and 20170321 
 and VISIT_DATE_KEY !=20170317
 and  page_name='OrderConfirm'
 --and  vid not in (select VID from factec_order where add_time  between 20170314 and 20170321  and add_time !=20170317 and APP_NAME in('KLGAndroid','KLGiPhone'))
 and (VER_NAME='7.1.0' or VER_NAME='7.1.2')  
 
 group by VISIT_DATE_KEY
 
----- 18459  8195
 

-----

/*

针对以订购会员2P，分新老和注册来源（是否电商）划分为四个群体进行捞单，需要看到指标为：
1.以订购会员、四个群体过去一年ARPU值和注册天数（做散点图用）
2.大促期间2单以上会员订单的类目、价格带分布，人数占比，群体归属
3.四个群体的人数、订单数、件数、金额（用来算占比）
*/
----  1.四个群体过去一年ARPU值和注册天数（做散点图用）
select ORDER_AMOUNT,MEMBER_KEY ,CLV_TYPE_W,MEMBER_INSERT_DATE,FIRST_ACTIVE_DATE_KEY from (
select sum(ORDER_AMOUNT) as ORDER_AMOUNT,MEMBER_KEY from    fact_order where  ORDER_DATE_KEY between 20160316 and 20170316 
and SALES_SOURCE_KEY =20  
and MEMBER_KEY in(
(select MEMBER_KEY from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1 ))  --框定317订购会员)
 group by MEMBER_KEY) df   left join dim_member ds on df.MEMBER_KEY=ds.member_bp
 
 -----大促期间2单以上会员订单的类目、价格带分布，人数占比，群体归属
 select GOODS_NAME,MATDLT,dan,jian,ren,price from (
 select  GOODS_COMMON_KEY,count(1) as dan ,sum(NUMS) as jian ,count(distinct(MEMBER_KEY)) as ren ,avg(SALES_AMOUNT) as price from fact_goods_sales where   ORDER_DATE_KEY between 20170317 and 20170319 
 and SALES_SOURCE_KEY =20 
 and TRAN_DESC='TAN'
and   ORDER_STATE>=1  and  MEMBER_KEY in 
 (select MEMBER_KEY from 
 (select MEMBER_KEY,count(1) num1 from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1  group by MEMBER_KEY) where num1>1) --框定317订购2次以上会员
group by GOODS_COMMON_KEY) da left join  dim_ec_good ds  on da.GOODS_COMMON_KEY=ds.ITEM_CODE

----- 四个群体的人数、订单数、件数、金额（用来算占比）
select MEMBER_KEY ,CLV_TYPE_W,ORDER_AMOUNT,num1,dan from (
select MEMBER_KEY,count(1) dan,sum(ORDER_NUMS) num1 ,sum(ORDER_AMOUNT) ORDER_AMOUNT
 from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1  group by MEMBER_KEY)
df   left join dim_member ds on df.MEMBER_KEY=ds.member_bp

/*

商品部分需求指标：（时间维度：3.17-19日，渠道：APP端）
1、热搜表现 搜索关键词，搜索次数，人数
2、商品详情页访问表现（列出所有这三天在架的商品，UV为0的也要包含）物料大类，商品编码  ，商品名称，提报组，快乐价， UV， PV ，订购件数 ，订购金额 
3、“到货通知"的商品点击次数

*/

---- 1、热搜表现 搜索关键词，搜索次数，人数
select SKW 搜索关键词,count(distinct(vid)) 人数 ,count(1) 搜索次数 from fact_search  where 
 CREATE_DATE_KEY  between 20170317 and 20170319  
and APPLICATION_KEY in(10,20)
group by SKW

---  2、商品详情页访问表现（列出所有这三天在架的商品，UV为0的也要包含）物料大类，商品编码  ，商品名称，提报组，快乐价， UV， PV ，订购件数 ，订购金额 

select * from 
(select page_value,count(1),count(distinct(vid)) from fact_page_view where visit_date_key between 20170317 and 20170319
and page_name='Good' and page_value like '1%' and  page_value not like '%.%'
group by page_value) ds left join  DIM_EC_GOOD df on to_number(ds.PAGE_VALUE)=df.GOODS_COMMONID
left join (
 select  GOODS_COMMON_KEY,count(distinct(MEMBER_KEY)) as ren ,sum(SALES_AMOUNT) as price from fact_goods_sales
  where   ORDER_DATE_KEY between 20170317 and 20170319 
 and SALES_SOURCE_KEY =20 
 and TRAN_DESC='TAN'  group BY GOODS_COMMON_KEY) da on  df.ITEM_CODE=DA.GOODS_COMMON_KEY
 
 
 ----3 

select * from dim_ec_good where GOODS_COMMONID in( 
 select SSID  from ls_test )
 
/*
针对未订购但已访问会员，从两个层面捞单：
1.分为过去一年未订购和有订购，其中，有订购的会员在过去一年的价格带，类目，折扣金额分布；
2.未订购会员访问得最多的商品(含商品价格)、频道、专题
3.此类会员UV、PV按照新老和注册来源（是否电商）划分
*/
---  分为过去一年未订购和有订购，其中，有订购的会员在过去一年的价格带，类目，折扣金额分布；
select * from (
select MEMBER_KEY,MEMBER_bp1,NUMS,BARGAIN_PRICE,COUPONS_PRICE,PURCHASE_PRICE,GOODS_NAME,IS_TV,MATDLT from (
select MEMBER_KEY,GOODS_COMMON_KEY,sum(NUMS) NUMS,sum(BARGAIN_PRICE) BARGAIN_PRICE ,sum(COUPONS_PRICE)  COUPONS_PRICE,
sum(PURCHASE_PRICE)  PURCHASE_PRICE
 from fact_goods_sales  where   ORDER_DATE_KEY between 20160317 and 20170316 
 and SALES_SOURCE_KEY =20 
 and TRAN_DESC='TAN'
and   ORDER_STATE=1     
group by  MEMBER_KEY,GOODS_COMMON_KEY
) sd
left join  
(
select distinct(MEMBER_KEY)  MEMBER_bp1 from fact_session where  START_DATE_KEY  between 20170317 and 20170319
and MEMBER_KEY not in(
select MEMBER_KEY from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1 
)) sf  on sd.MEMBER_KEY=sf.MEMBER_bp1

left join 
(
dim_ec_good
)  sg on sd.GOODS_COMMON_KEY=sg.item_code
) where MEMBER_bp1 is not null and GOODS_NAME is not null

-----2-1.未订购会员访问得最多的商品(含商品价格)、频道、专题  ,'Channel','KFZT','WZT2','ZT_Detail2')
select * from (
select PAGE_NAME,PAGE_VALUE,COUNT(1),COUNT(DISTINCT(VID)) 
from fact_page_view where visit_date_key between  20170317 and 20170319 
and page_name='Good' and page_value like '1%' and  page_value not like '%.%'
AND MEMBER_KEY IN 
(
select distinct(MEMBER_KEY)  MEMBER_bp1 from fact_session where  START_DATE_KEY  between 20170317 and 20170319
and MEMBER_KEY not in(
select MEMBER_KEY from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1 
))  group by PAGE_NAME,PAGE_VALUE) sd
left join dim_ec_good sf on sd.PAGE_VALUE=sf.GOODS_COMMONID


----
select * from (
select PAGE_NAME,PAGE_VALUE,COUNT(1),COUNT(DISTINCT(VID)) 
from fact_page_view where visit_date_key between  20170317 and 20170319 
and page_name in ('Channel','KFZT','WZT2','ZT_Detail2') and  page_value not like '%.%'
AND MEMBER_KEY IN 
(
select distinct(MEMBER_KEY)  MEMBER_bp1 from fact_session where  START_DATE_KEY  between 20170317 and 20170319
and MEMBER_KEY not in(
select MEMBER_KEY from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1 
))  group by PAGE_NAME,PAGE_VALUE) 





----3.此类会员UV、PV按照新老和注册来源（是否电商）划分

select MEMBER_KEY,REGISTER_RESOURCE,CREATE_DATE_KEY,PV,UV from (select MEMBER_KEY,COUNT(1) PV,COUNT(DISTINCT(VID))  UV
 from fact_page_view where visit_date_key between  20170317 and 20170319 
---and page_name in('Good','Channel','KFZT','WZT2','ZT_Detail2')
AND MEMBER_KEY IN 
(
select distinct(MEMBER_KEY)  MEMBER_bp1 from fact_session where  START_DATE_KEY  between 20170317 and 20170319
and MEMBER_KEY not in(
select MEMBER_KEY from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1 
))
group by MEMBER_KEY) fd
left join dim_member fg on  fd.MEMBER_KEY=fg.member_bp


------
select * from  DIM_EC_APP_CMS_HOMEGROUP



