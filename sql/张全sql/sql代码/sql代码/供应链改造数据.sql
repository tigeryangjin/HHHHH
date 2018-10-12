select  count(1)/count(distinct(a.order_key)),order_date_key from fact_goods_sales a where
 a.order_date_key between 20160901 and 20161016 and TRAN_TYPE=0
and a.SALES_SOURCE_KEY=20  and ORDER_STATE=1  group by order_date_key

select * from fact_goods_sales a where
 a.order_date_key between 20160920 and 20161016
and a.SALES_SOURCE_KEY=20  and ORDER_STATE=1 


select count(distinct(VID)),count(1),CREATE_DATE_KEY from  fact_shoppingcar  where CREATE_DATE_KEY  between 20160901 and 20161016
and SCGQ>=1 group by CREATE_DATE_KEY


SELECT  count(distinct(VID)),count(1),VISIT_DATE_KEY FROM FACT_PAGE_VIEW  S WHERE  S.VISIT_DATE_KEY  between 20160901 and 20161016 
AND S.PAGE_NAME='ShoppingCart'
and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 group by VISIT_DATE_KEY 
 
 --直配送占比(只买商家配送商品)  2030单  763020元
 select  count(1),ORDER_DATE_KEY,sum(ORDER_AMOUNT) from  
 
 (select ORDER_KEY,count(1) as shangpin ,avg(ORDER_DATE_KEY) as ORDER_DATE_KEY
 ,sum(IS_SHIPPING_SELF) as peishong,sum(ORDER_AMOUNT) as  ORDER_AMOUNT from(
 
 SELECT ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT FROM (
 
 select ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT from 
( select ORDER_KEY,GOODS_COMMON_KEY,order_date_key,ORDER_AMOUNT from fact_goods_sales a where
 a.order_date_key=20161020
and a.SALES_SOURCE_KEY=20  and ORDER_STATE=1  AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019) 
and TRAN_TYPE=0) a left join dim_ec_good b  on a.GOODS_COMMON_KEY=b.ITEM_CODE) WHERE IS_SHIPPING_SELF IS NOT NULL )
group  by  ORDER_KEY

)where  peishong=0
--and peishong!=0 
 and peishong is not null  
group by ORDER_DATE_KEY


----只买快乐购配送商品  (10933 单)  3006566
 select  count(1),ORDER_DATE_KEY,sum(ORDER_AMOUNT) from  
 
 (select ORDER_KEY,count(1) as shangpin ,avg(ORDER_DATE_KEY) as ORDER_DATE_KEY
 ,sum(IS_SHIPPING_SELF) as peishong,sum(ORDER_AMOUNT) as  ORDER_AMOUNT from(
 
 SELECT ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT FROM (
 
 select ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT from 
( select ORDER_KEY,GOODS_COMMON_KEY,order_date_key,ORDER_AMOUNT from fact_goods_sales a where
 a.order_date_key=20161020
and a.SALES_SOURCE_KEY=20  and ORDER_STATE=1  AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019) 
and TRAN_TYPE=0) a left join dim_ec_good b  on a.GOODS_COMMON_KEY=b.ITEM_CODE) WHERE IS_SHIPPING_SELF IS NOT NULL )
group  by  ORDER_KEY

)where  peishong=shangpin
--and peishong!=0 
 and peishong is not null  
group by ORDER_DATE_KEY



---商品混合购买  1229单  458606

select  count(1),ORDER_DATE_KEY,sum(ORDER_AMOUNT) from  
 
 (select ORDER_KEY,count(1) as shangpin ,avg(ORDER_DATE_KEY) as ORDER_DATE_KEY
 ,sum(IS_SHIPPING_SELF) as peishong,sum(ORDER_AMOUNT) as  ORDER_AMOUNT from(
 
 SELECT ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT FROM (
 
 select ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT from 
( select ORDER_KEY,GOODS_COMMON_KEY,order_date_key,ORDER_AMOUNT from fact_goods_sales a where
 a.order_date_key=20161020
and a.SALES_SOURCE_KEY=20  and ORDER_STATE=1 AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019) 

and TRAN_TYPE=0) a left join dim_ec_good b  on a.GOODS_COMMON_KEY=b.ITEM_CODE) WHERE IS_SHIPPING_SELF IS NOT NULL )
group  by  ORDER_KEY

)where  peishong<shangpin
and peishong!=0 
 and peishong is not null  
group by ORDER_DATE_KEY

---- 用户混合加购物车次数 
select MEMBER_KEY  from (
select count(1) as chi,sum(IS_SHIPPING_SELF) gou,MEMBER_KEY from(
select sum(SCGQ),IS_SHIPPING_SELF,MEMBER_KEY from (
select APPLICATION_KEY,VID,MEMBER_KEY,SCGID,SCGQ from  fact_shoppingcar   where CREATE_DATE_KEY=20161020 and   SCGQ>0
) a
left join   

(select GOODS_COMMONID,ITEM_CODE,GOODS_NAME,GOODS_PRICE,MATDLT,IS_SHIPPING_SELF from  dim_ec_good)
b on (a.SCGID=b.ITEM_CODE  or a.SCGID=b.GOODS_COMMONID) 
group by IS_SHIPPING_SELF,MEMBER_KEY) where IS_SHIPPING_SELF is not null group by MEMBER_KEY)
where  gou=0
---只加直配送商品人数4535    只加商家配送商品人数 299   混合加购物车人数 2879 

select count(distinct(VID)) from fact_shoppingcar  where CREATE_DATE_KEY=20161020 and   SCGQ>0


select * from fact_shoppingcar where  CREATE_DATE_KEY=20161020 and   SCGQ>0 and MEMBER_KEY=1501029974

select * from  fact_shoppingcar   where CREATE_DATE_KEY=20161020 and   SCGQ>0 and MEMBER_KEY=1500952221
---- 用户混合订购次数   1604979589  1501146111 1604978674 803491614

select * from dim_ec_good where GOODS_COMMONID=143947

select * from dim_ec_good 


----- s
select * sum(ORDER_AMOUNT) from fact_goods_sales a where
 a.order_date_key=20161020
and a.SALES_SOURCE_KEY=20  and ORDER_STATE=1 AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019)
 
select * from  fact_page_view  where  VISIT_DATE_KEY=20161020 and vid like '%ndroid346c0d2%'  



------- 加供应商配送商品 ( )

select  count(1),ORDER_DATE_KEY,sum(ORDER_AMOUNT),count(distinct(MEMBER_KEY)) from  
 
 (select MEMBER_KEY,ORDER_KEY,count(1) as shangpin ,avg(ORDER_DATE_KEY) as ORDER_DATE_KEY
 ,sum(IS_SHIPPING_SELF) as peishong,sum(ORDER_AMOUNT) as  ORDER_AMOUNT from(
 
 SELECT ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT,MEMBER_KEY FROM (
 
 select ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT,MEMBER_KEY from 
( select ORDER_KEY,GOODS_COMMON_KEY,order_date_key,ORDER_AMOUNT,MEMBER_KEY from fact_goods_sales a where
 a.order_date_key=20161020
and a.SALES_SOURCE_KEY=20 -- and ORDER_STATE=1 
AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019) 

and TRAN_TYPE=0) a left join dim_ec_good b  on a.GOODS_COMMON_KEY=b.ITEM_CODE
and MEMBER_KEY in (select MEMBER_KEY  from (
select count(1) as chi,sum(IS_SHIPPING_SELF) gou,MEMBER_KEY from(
select sum(SCGQ),IS_SHIPPING_SELF,MEMBER_KEY from (
select APPLICATION_KEY,VID,MEMBER_KEY,SCGID,SCGQ from  fact_shoppingcar   where CREATE_DATE_KEY=20161020 and   SCGQ>0
) a
left join   

(select GOODS_COMMONID,ITEM_CODE,GOODS_NAME,GOODS_PRICE,MATDLT,IS_SHIPPING_SELF from  dim_ec_good)
b on (a.SCGID=b.ITEM_CODE  or a.SCGID=b.GOODS_COMMONID) 
group by IS_SHIPPING_SELF,MEMBER_KEY) where IS_SHIPPING_SELF is not null group by MEMBER_KEY)
where  gou=0


 )

) WHERE IS_SHIPPING_SELF IS NOT NULL )
group  by  ORDER_KEY,MEMBER_KEY

)where  --peishong<shangpin and 
     peishong=0 
 and peishong is not null  
group by ORDER_DATE_KEY

----只加自营商品


select  count(1),ORDER_DATE_KEY,sum(ORDER_AMOUNT),count(distinct(MEMBER_KEY)) from  
 
 (select MEMBER_KEY,ORDER_KEY,count(1) as shangpin ,avg(ORDER_DATE_KEY) as ORDER_DATE_KEY
 ,sum(IS_SHIPPING_SELF) as peishong,sum(ORDER_AMOUNT) as  ORDER_AMOUNT from(
 
 SELECT ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT,MEMBER_KEY FROM (
 
 select ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT,MEMBER_KEY from 
( select ORDER_KEY,GOODS_COMMON_KEY,order_date_key,ORDER_AMOUNT,MEMBER_KEY from fact_goods_sales a where
 a.order_date_key=20161020
and a.SALES_SOURCE_KEY=20  and ORDER_STATE=1 
AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019) 

and TRAN_TYPE=0) a left join dim_ec_good b  on a.GOODS_COMMON_KEY=b.ITEM_CODE
and MEMBER_KEY in (select MEMBER_KEY  from (
select count(1) as chi,sum(IS_SHIPPING_SELF) gou,MEMBER_KEY from(
select sum(SCGQ),IS_SHIPPING_SELF,MEMBER_KEY from (
select APPLICATION_KEY,VID,MEMBER_KEY,SCGID,SCGQ from  fact_shoppingcar   where CREATE_DATE_KEY=20161020 and   SCGQ>0
) a
left join   

(select GOODS_COMMONID,ITEM_CODE,GOODS_NAME,GOODS_PRICE,MATDLT,IS_SHIPPING_SELF from  dim_ec_good)
b on (a.SCGID=b.ITEM_CODE  or a.SCGID=b.GOODS_COMMONID) 
group by IS_SHIPPING_SELF,MEMBER_KEY) where IS_SHIPPING_SELF is not null group by MEMBER_KEY)
where  gou=chi


 )

) WHERE IS_SHIPPING_SELF IS NOT NULL )
group  by  ORDER_KEY,MEMBER_KEY

)where  --peishong<shangpin and 
     peishong=shangpin 
 and peishong is not null  
group by ORDER_DATE_KEY



--混合加购物车


select  count(1),ORDER_DATE_KEY,sum(ORDER_AMOUNT),count(distinct(MEMBER_KEY)) from  
 
 (select MEMBER_KEY,ORDER_KEY,count(1) as shangpin ,avg(ORDER_DATE_KEY) as ORDER_DATE_KEY
 ,sum(IS_SHIPPING_SELF) as peishong,sum(ORDER_AMOUNT) as  ORDER_AMOUNT from(
 
 SELECT ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT,MEMBER_KEY FROM (
 
 select ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT,MEMBER_KEY from 
( select ORDER_KEY,GOODS_COMMON_KEY,order_date_key,ORDER_AMOUNT,MEMBER_KEY from fact_goods_sales a where
 a.order_date_key=20161020
and a.SALES_SOURCE_KEY=20  --and ORDER_STATE=1 
AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019) 

and TRAN_TYPE=0) a left join dim_ec_good b  on a.GOODS_COMMON_KEY=b.ITEM_CODE

) WHERE IS_SHIPPING_SELF IS NOT NULL )
group  by  ORDER_KEY,MEMBER_KEY

)where  peishong<shangpin and 
     peishong!=0 
 and peishong is not null  
group by ORDER_DATE_KEY
----只买快乐配送
select  count(1),ORDER_DATE_KEY,sum(ORDER_AMOUNT),count(distinct(MEMBER_KEY)) from  
 
 (select MEMBER_KEY,ORDER_KEY,count(1) as shangpin ,avg(ORDER_DATE_KEY) as ORDER_DATE_KEY
 ,sum(IS_SHIPPING_SELF) as peishong,sum(ORDER_AMOUNT) as  ORDER_AMOUNT from(
 
 SELECT ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT,MEMBER_KEY FROM (
 
 select ORDER_KEY,GOODS_COMMON_KEY,ORDER_DATE_KEY,ITEM_CODE,IS_SHIPPING_SELF,ORDER_AMOUNT,MEMBER_KEY from 
( select ORDER_KEY,GOODS_COMMON_KEY,order_date_key,ORDER_AMOUNT,MEMBER_KEY from fact_goods_sales a where
 a.order_date_key=20161020
and a.SALES_SOURCE_KEY=20 -- and ORDER_STATE=1 
AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019) 

and TRAN_TYPE=0) a left join dim_ec_good b  on a.GOODS_COMMON_KEY=b.ITEM_CODE

) WHERE IS_SHIPPING_SELF IS NOT NULL )
group  by  ORDER_KEY,MEMBER_KEY

)where  --peishong<shangpin and 
     peishong=0 
 and peishong is not null  
group by ORDER_DATE_KEY


select count(distinct(member_key)) from fact_goods_sales a where order_date_key=20161020
and a.SALES_SOURCE_KEY=20  and ORDER_STATE=1 
AND SALES_SOURCE_SECOND_KEY NOT IN (20013, 20016, 20018, 20019) 

and TRAN_TYPE=0



