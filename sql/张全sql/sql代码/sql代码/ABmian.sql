select count(distinct(vid)),visit_date_key,page_name from fact_page_view where visit_date_key between 20170316 and 20170320 
and   APPLICATION_KEY in (10,20)
and VER_NAME in('7.1.0','7.1.2')
and ( page_name like '%_TV_%' OR PAGE_NAME='Home_TVLive')
GROUP BY visit_date_key,page_name



select * from fact_order_reverse

----  ����17-19��֮�䣬����δ�����Ļ�Ա�У�����Ʒ��������ﳵ����Ʒ�ύ����δ����Ļ�Ա����180��ȯ��199-30��339-50��599-100���Ͷ��ţ�
----9517 ��
 
select distinct(MEMBER_KEY) from fact_session where  START_DATE_KEY between 20170317 and 20170319
and MEMBER_KEY
not in (select MEMBER_KEY from factec_order where add_time   between 20170317 and 20170319
and PAYMENT_TIME>0)
and MEMBER_KEY
in (
select MEMBER_KEY from fact_shoppingcar  where CREATE_DATE_KEY  between 20170317 and 20170319);

------  3��ȫ�¶�����2�Σ�ÿ��300���ϵĻ�Ա����������ʾ�ٶ���һ�ε�30Ԫ0�ż���4�¿��ã�(��������)

select MEMBER_KEY from (
select MEMBER_KEY,count(1) num from  factec_order where  ADD_TIME between 20170301 and 20170319 
and ORDER_AMOUNT>=300
and ORDER_STATE>10
group by MEMBER_KEY) where num>1


------  17-19�����Ļ�Ա����17-����û�����ԭ���˻��ģ���180��ȯ��199-30��339-50��599-100���Ͷ��ţ�


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


-----A/B�������
--1���������������Ա�
 select VISIT_DATE_KEY,UVCNT from fact_daily_app where VISIT_DATE_KEY between 20170307 and 20170321 
 
 ---
 select page_name,VISIT_DATE_KEY,sum(PAGE_STAYTIME)/count(1),count(distinct(vid)),count(1) from 
 fact_page_view where  VISIT_DATE_KEY ss between 20170307 and 20170321 
 and page_name in ('Home','Home_TVLive')
 and APPLICATION_KEY in (10,20)
 group by page_name,VISIT_DATE_KEY
 
 
 ---ת��©��  �����ύҳҳ�����
 
 select count(distinct(vid)) from fact_page_view where VISIT_DATE_KEY between 20170314 and 20170321 
 and VISIT_DATE_KEY !=20170317
 and  page_name='OrderConfirm'
 --and  vid not in (select VID from factec_order where add_time  between 20170314 and 20170321  and add_time !=20170317 and APP_NAME in('KLGAndroid','KLGiPhone'))
 and (VER_NAME='7.1.0' or VER_NAME='7.1.2')  
 
 group by VISIT_DATE_KEY
 
----- 18459  8195
 

-----

/*

����Զ�����Ա2P�������Ϻ�ע����Դ���Ƿ���̣�����Ϊ�ĸ�Ⱥ������̵�����Ҫ����ָ��Ϊ��
1.�Զ�����Ա���ĸ�Ⱥ���ȥһ��ARPUֵ��ע����������ɢ��ͼ�ã�
2.����ڼ�2�����ϻ�Ա��������Ŀ���۸���ֲ�������ռ�ȣ�Ⱥ�����
3.�ĸ�Ⱥ�������������������������������ռ�ȣ�
*/
----  1.�ĸ�Ⱥ���ȥһ��ARPUֵ��ע����������ɢ��ͼ�ã�
select ORDER_AMOUNT,MEMBER_KEY ,CLV_TYPE_W,MEMBER_INSERT_DATE,FIRST_ACTIVE_DATE_KEY from (
select sum(ORDER_AMOUNT) as ORDER_AMOUNT,MEMBER_KEY from    fact_order where  ORDER_DATE_KEY between 20160316 and 20170316 
and SALES_SOURCE_KEY =20  
and MEMBER_KEY in(
(select MEMBER_KEY from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1 ))  --��317������Ա)
 group by MEMBER_KEY) df   left join dim_member ds on df.MEMBER_KEY=ds.member_bp
 
 -----����ڼ�2�����ϻ�Ա��������Ŀ���۸���ֲ�������ռ�ȣ�Ⱥ�����
 select GOODS_NAME,MATDLT,dan,jian,ren,price from (
 select  GOODS_COMMON_KEY,count(1) as dan ,sum(NUMS) as jian ,count(distinct(MEMBER_KEY)) as ren ,avg(SALES_AMOUNT) as price from fact_goods_sales where   ORDER_DATE_KEY between 20170317 and 20170319 
 and SALES_SOURCE_KEY =20 
 and TRAN_DESC='TAN'
and   ORDER_STATE>=1  and  MEMBER_KEY in 
 (select MEMBER_KEY from 
 (select MEMBER_KEY,count(1) num1 from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1  group by MEMBER_KEY) where num1>1) --��317����2�����ϻ�Ա
group by GOODS_COMMON_KEY) da left join  dim_ec_good ds  on da.GOODS_COMMON_KEY=ds.ITEM_CODE

----- �ĸ�Ⱥ�������������������������������ռ�ȣ�
select MEMBER_KEY ,CLV_TYPE_W,ORDER_AMOUNT,num1,dan from (
select MEMBER_KEY,count(1) dan,sum(ORDER_NUMS) num1 ,sum(ORDER_AMOUNT) ORDER_AMOUNT
 from  fact_order where  ORDER_DATE_KEY between 20170317 and 20170319 
and SALES_SOURCE_KEY =20 
and   ORDER_STATE>=1  group by MEMBER_KEY)
df   left join dim_member ds on df.MEMBER_KEY=ds.member_bp

/*

��Ʒ��������ָ�꣺��ʱ��ά�ȣ�3.17-19�գ�������APP�ˣ�
1�����ѱ��� �����ؼ��ʣ���������������
2����Ʒ����ҳ���ʱ��֣��г������������ڼܵ���Ʒ��UVΪ0��ҲҪ���������ϴ��࣬��Ʒ����  ����Ʒ���ƣ��ᱨ�飬���ּۣ� UV�� PV ���������� ��������� 
3��������֪ͨ"����Ʒ�������

*/

---- 1�����ѱ��� �����ؼ��ʣ���������������
select SKW �����ؼ���,count(distinct(vid)) ���� ,count(1) �������� from fact_search  where 
 CREATE_DATE_KEY  between 20170317 and 20170319  
and APPLICATION_KEY in(10,20)
group by SKW

---  2����Ʒ����ҳ���ʱ��֣��г������������ڼܵ���Ʒ��UVΪ0��ҲҪ���������ϴ��࣬��Ʒ����  ����Ʒ���ƣ��ᱨ�飬���ּۣ� UV�� PV ���������� ��������� 

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
���δ�������ѷ��ʻ�Ա�������������̵���
1.��Ϊ��ȥһ��δ�������ж��������У��ж����Ļ�Ա�ڹ�ȥһ��ļ۸������Ŀ���ۿ۽��ֲ���
2.δ������Ա���ʵ�������Ʒ(����Ʒ�۸�)��Ƶ����ר��
3.�����ԱUV��PV�������Ϻ�ע����Դ���Ƿ���̣�����
*/
---  ��Ϊ��ȥһ��δ�������ж��������У��ж����Ļ�Ա�ڹ�ȥһ��ļ۸������Ŀ���ۿ۽��ֲ���
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

-----2-1.δ������Ա���ʵ�������Ʒ(����Ʒ�۸�)��Ƶ����ר��  ,'Channel','KFZT','WZT2','ZT_Detail2')
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





----3.�����ԱUV��PV�������Ϻ�ע����Դ���Ƿ���̣�����

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



