-------��Ƶ��

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
APPLICATION_KEY  ͨ��,
HMMD  ��������,
LCRATE  ����������,
PAYMOUNT  ���ѽ��,
HITCNT  �ع����,
VIEWCNT  �������  from FACT_LCRATE_MARKET where



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



-----��Ʒ�ع�
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
ITEM_CODE	crm��Ʒ���	,
GOODS_COMMON_KEY	ec��Ʒ���	,
GOODS_NAME	��Ʒ����	,
BRAND_ID	Ʒ��id	,
BRAND_NAME	Ʒ������	,
EC_CATE_ID	ecƷ��	,
MATDL	���ϴ���	,
MATDL_KEY	���ϴ���id	,
MATZL	��������	,
MATZL_KEY	��������id	,
MATXL	����С��	,
MATXL_KEY	����С��id	,
MATXXL	����ϸ��	,
MATXXL_KEY	����ϸ��id	,
GROUP_NAME	�ᱨ��	,
MD	MD���	,
SUPPLIER_ID	��Ӧ�̱��	,
SUPPLIER_NAME	��Ӧ������	,
DELIVERY_KEY	������ʽ 	,
ZJ_STATE	��Ʒ�Ƿ��ڼ�	,
STOCK_NUMS	��Ʒ���״̬	,
FIRST_SJ_TIME	��Ʒ��һ���ϼ�ʱ��	,
LAST_SJ_TIME	��Ʒ���һ���ڼ�ʱ��	,
COMMENT_TOTAL	�����۴���	,
COMMENT_BEST	�ܺ�������	,
COMMENT_BETTER	����������	,
COMMENT_GOOD	�ܲ�������	,
EFFECTIVE_TOTAL	��Ʒ��Ч��������	,
CANCEL_TOTAL	��Ʒ��ȡ������	,
SALE_TOTAL	��Ʒ�ܶ�������	,
REJECTION_TOTAL	��Ʒ�ܾ�������	,
REJECTION_CANCEL_TOTAL	��Ʒ�ܾ���ȡ������	,
EFFECTIVE_ORDER_TOTAL	��Ʒ��Ч���۶�����	,
CANCEL_ORDER_TOTAL	��Ʒ��ȡ��������	,
SALE_ORDER_TOTAL	��Ʒ�ܶ���������	,
REJECTION_ORDER_TOTAL	��Ʒ�ܾ��˶�����	,
REJECTION_ORDER_CANCEL_TOTAL	��Ʒ�ܾ���ȡ��������	,
EFFECTIVE_MEMBER_TOTAL	��Ʒ��Ч��������	,
CANCEL_MEMBER_TOTAL	��Ʒ��ȡ������	,
SALE_MEMBER_TOTAL	��Ʒ�ܶ�������	,
REJECTION_MEMBER_TOTAL	��Ʒ�ܾ�������	,
REJECTION_MEMBER_CANCEL_TOTAL	��Ʒ�ܾ���ȡ������	,
CART_TOTAL	���ﳵ����ܴ���	,
SC_TOTAL	���ղش���	,
PV_TOTAL	��PV	
 from FACT_GOODS_DIM_TOTAL







































































 
