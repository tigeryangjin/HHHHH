------  120427    162240
select distinct(MEMBER_KEY) from factec_order where order_id in  (
select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171021 and order_state>10
 group by  CUST_NO) 
 and ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(select ITEM_CODE from dim_good where  GROUP_ID=2000)) 
 and order_state>10
and add_time between 20170101 and 20171021

------183389
select count(distinct(MEMBER_KEY)) from factec_order where 
--ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in (select ITEM_CODE from dim_good where  GROUP_ID=1000))  
--and 
order_state>10
and add_time between 20170101 and 20171021

-----
select num1,count(1) from(
 select MEMBER_KEY,count(distinct order_id ) num1 from factec_order where order_state>10 
 and add_time between 20170101 and 20171021 
 and MEMBER_KEY in (
select SSID from ls_test1
 )
  and MEMBER_KEY in (select CUST_NO from fact_ec_order   where add_time between 20160101 and 20171021 and order_state>10group by  CUST_NO) 
 group by MEMBER_KEY)   group  by num1
 
 
 
 insert into ls_test1 (SSID)

 select distinct(MEMBER_KEY) from factec_order where order_id in  (
select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171021 and order_state>10
 group by  CUST_NO) 
 and ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(select ITEM_CODE from dim_good where  GROUP_ID=2000)) 
 and order_state>10
and add_time between 20170101 and 20171021;

select min(order_id) from factec_order where order_id in  (
select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171021 and order_state>10
 group by  CUST_NO) and ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(
select ITEM_CODE from dim_good where  GROUP_ID=2000))  and order_state>10
and add_time between 20170101 and 20171021   group by MEMBER_KEY;
select * from ls_test1;
 
 ---- 一单喜好(品类)
select GC_NAME,sum(GOODS_NUM),sum(GOODS_PAY_PRICE1),median(GOODS_PAY_PRICE) from (
select a.ITEM_CODE,a.GOODS_NUM,a.GOODS_PAY_PRICE,GOODS_PAY_PRICE1,b.GOODS_NAME,substr(b.GC_NAME,0,4) GC_NAME,BRAND_NAME,STORE_NAME from (
select ITEM_CODE,sum(GOODS_NUM) GOODS_NUM,avg(GOODS_PAY_PRICE)  GOODS_PAY_PRICE,sum(GOODS_PAY_PRICE) GOODS_PAY_PRICE1 from factec_order_goods where  
 order_id in ( select order_id from factec_order where add_time between 20170101 and 20171022 and order_state>10  )
 and ITEM_CODE in(select ITEM_CODE from dim_good where  GROUP_ID=2000)
group by ITEM_CODE) a
left join dim_ec_good b on a.ITEM_CODE=b.ITEM_CODE
)where  GOODS_PAY_PRICE >9.9 group by GC_NAME;

----- 一单喜好(价格)
select GOODS_PAY_PRICE,sum(GOODS_NUM),sum(GOODS_PAY_PRICE) from (
select a.ITEM_CODE,a.GOODS_NUM,a.GOODS_PAY_PRICE,b.GOODS_NAME,substr(b.GC_NAME,0,4) GC_NAME,BRAND_NAME,STORE_NAME from (
select ITEM_CODE,sum(GOODS_NUM) GOODS_NUM,avg(GOODS_PRICE)  GOODS_PAY_PRICE from factec_order_goods where 
 order_id in ( select order_id from factec_order where add_time between 20170101 and 20171022 and order_state>10  )
 and ITEM_CODE in(select ITEM_CODE from dim_good where  GROUP_ID=2000)
 group by ITEM_CODE) a
left join dim_ec_good b on a.ITEM_CODE=b.ITEM_CODE
)  where  GOODS_PAY_PRICE >9.9 group by GOODS_PAY_PRICE;
