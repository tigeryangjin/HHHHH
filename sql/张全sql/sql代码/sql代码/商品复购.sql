-------视频购

select count(1),count(distinct(vid))  from fact_page_view s where  s.visit_date_key=20161111 and s.page_name='Good'
and vid in(

select vid from fact_page_view s where  s.visit_date_key=20161111 and s.page_name='WZT2' and s.application_key>20

and s.page_value='lQdpN5i6r8TLjW9')  and  s.application_key>20 and


-----

select * from  factec_order  where  add_time=20161111 and ORDER_FROM=67

call createfactscancode(20161110)


select * from dim_scan_code_day where DAY_KEY=20161110

select * from fact_page_view s where  s.visit_date_key=20161111 and url like'%restapi.happigo.com%'


select 
CREATE_DATE_KEY,
APPLICATION_KEY  通道,
HMMD  渠道名称,
LCRATE  次日留存率,
PAYMOUNT  花费金额,
HITCNT  曝光次数,
VIEWCNT  点击次数  from FACT_LCRATE_MARKET where



select * from fact_page_view s where  s.visit_date_key=20161113 and s.page_name='NewGood'



select COUNT(1),COUNT(DISTINCT(VID)),APPLICATION_KEY,LEVEL2,ACTIVE_DATE_KEY
 from fact_visitor_active t where t.ACTIVE_DATE_KEY>=20161110 and LEVEL1='SEM' and APPLICATION_KEY=40
 GROUP BY APPLICATION_KEY,LEVEL2,ACTIVE_DATE_KEY
 
 
 select count(1),count(distinct(vid)),visit_date_key from fact_page_view where visit_date_key>20161110 and APPLICATION_KEY=40
 
 group by visit_date_key
 
 
 
 select count(1) from  FACT_MEMBER_PAGE_ORDER









;
 select *from FACT_LCRATE_MARKET

select * from dim_member


select count(1),count(distinct(ip)),visit_date_key from fact_page_view s where s.visit_date_key between 20161008  and 20161108
  and  s.page_name='ZT_Detail2'  and s.page_value='2909'  group by visit_date_key

select * from (
select SKW,count(1) as chi from fact_search where CREATE_DATE_KEY>=20160101  group by SKW
) where chi>1000
select count(1) from fact_search where CREATE_DATE_KEY>=20160101

select max(STATDATE) from STATS_ONLINE_GOOD_MINUTE


select * from fact_visitor_active  where ACTIVE_DATE_KEY=20161117 and LEVEL1='SEM'

select * from fact_daily_goodpage where PAGE_NAME='Video_replay' and VISIT_DATE_KEY<20160901



-----商品重购
select * from (
select count(distinct(m1)),count(distinct(m2)),count(distinct(m3)),g1 from(
select a.MEMBER_KEY as m1,b.MEMBER_KEY as m2,c.MEMBER_KEY as m3,a.GOODS_COMMON_KEY as g1,
b.GOODS_COMMON_KEY as g2,c.GOODS_COMMON_KEY as g3 from 

(select MEMBER_KEY,GOODS_COMMON_KEY,'09' from fact_goods_sales  where  ORDER_DATE_KEY between 20160901 and 20160931 and SALES_SOURCE_KEY=20
and order_state>0  and GOODS_COMMON_KEY in(

select distinct(ITEM_CODE) from dim_good  where MATDL=31 or MATDL=30)
group by MEMBER_KEY,GOODS_COMMON_KEY) a

left join

(select MEMBER_KEY,GOODS_COMMON_KEY,'10' from fact_goods_sales  where  ORDER_DATE_KEY between 20161001 and 20161031 and SALES_SOURCE_KEY=20
and order_state>0  and GOODS_COMMON_KEY in(

select distinct(ITEM_CODE) from dim_good  where MATDL=31 or MATDL=30)
group by MEMBER_KEY,GOODS_COMMON_KEY) b on a.MEMBER_KEY=b.MEMBER_KEY and a.GOODS_COMMON_KEY=b.GOODS_COMMON_KEY
left join 
(select MEMBER_KEY,GOODS_COMMON_KEY,'11' from fact_goods_sales  where  ORDER_DATE_KEY between 20161101 and 20161131 and SALES_SOURCE_KEY=20
and order_state>0  and GOODS_COMMON_KEY in(

select distinct(ITEM_CODE) from dim_good  where MATDL=31 or MATDL=30)
group by MEMBER_KEY,GOODS_COMMON_KEY)  c on a.MEMBER_KEY=c.MEMBER_KEY and a.GOODS_COMMON_KEY=c.GOODS_COMMON_KEY

) group by  g1) a left join  dim_good b on a.g1=b.item_code

select * from FACT_GOODS_DIM_TOTAL



select 
ITEM_CODE	crm商品编号	,
GOODS_COMMON_KEY	ec商品编号	,
GOODS_NAME	商品名称	,
BRAND_ID	品牌id	,
BRAND_NAME	品牌名称	,
EC_CATE_ID	ec品类	,
MATDL	物料大类	,
MATDL_KEY	物料大类id	,
MATZL	物料中类	,
MATZL_KEY	物料中类id	,
MATXL	物料小类	,
MATXL_KEY	物料小类id	,
MATXXL	物料细类	,
MATXXL_KEY	物料细类id	,
GROUP_NAME	提报组	,
MD	MD编号	,
SUPPLIER_ID	供应商编号	,
SUPPLIER_NAME	供应商名称	,
DELIVERY_KEY	发货方式 	,
ZJ_STATE	商品是否在架	,
STOCK_NUMS	商品库存状态	,
FIRST_SJ_TIME	商品第一次上架时间	,
LAST_SJ_TIME	商品最后一次在架时间	,
COMMENT_TOTAL	总评价次数	,
COMMENT_BEST	总好评次数	,
COMMENT_BETTER	总中评次数	,
COMMENT_GOOD	总差评次数	,
EFFECTIVE_TOTAL	商品有效销售数量	,
CANCEL_TOTAL	商品总取消数量	,
SALE_TOTAL	商品总订购数量	,
REJECTION_TOTAL	商品总拒退数量	,
REJECTION_CANCEL_TOTAL	商品总拒退取消数量	,
EFFECTIVE_ORDER_TOTAL	商品有效销售订单数	,
CANCEL_ORDER_TOTAL	商品总取消订单数	,
SALE_ORDER_TOTAL	商品总订购订单数	,
REJECTION_ORDER_TOTAL	商品总拒退订单数	,
REJECTION_ORDER_CANCEL_TOTAL	商品总拒退取消订单数	,
EFFECTIVE_MEMBER_TOTAL	商品有效订购人数	,
CANCEL_MEMBER_TOTAL	商品总取消人数	,
SALE_MEMBER_TOTAL	商品总订购人数	,
REJECTION_MEMBER_TOTAL	商品总拒退人数	,
REJECTION_MEMBER_CANCEL_TOTAL	商品总拒退取消人数	,
CART_TOTAL	购物车存放总次数	,
SC_TOTAL	总收藏次数	,
PV_TOTAL	总PV	
 from FACT_GOODS_DIM_TOTAL







































































 
