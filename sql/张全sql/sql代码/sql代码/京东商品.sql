
select M_LABEL_DESC,M_LABEL_ID,count(1)   from  MEMBER_LABEL_LINK_V where  MEMBER_Key in (
select distinct(MEMBER_KEY) from fact_goods_sales where GOODS_COMMON_KEY in(
select ITEM_CODE from dim_good where  GROUP_ID=2100) and order_state=1)
group by M_LABEL_DESC,M_LABEL_ID


---- 87ÈË
select count(distinct(MEMBER_KEY)) from factec_order where order_id in  (
select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171021 and order_state>10
 group by  CUST_NO) and ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(
select ITEM_CODE from dim_good where  GROUP_ID=2100))  and order_state>10

----- 721

select count(distinct(MEMBER_KEY)) from factec_order where
 ---order_id in  (select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171001 and order_state>10 group by  CUST_NO) and 
 ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(select ITEM_CODE from dim_good where  GROUP_ID=2100))

and  add_time between 20160101 and 20171021   and order_state>10
----
select num1,count(1) from(
 select MEMBER_KEY,count(distinct order_id ) num1 from factec_order where order_state>10 and 
 
  ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(select ITEM_CODE from dim_good where  GROUP_ID=2100)
 )group by MEMBER_KEY)   group  by num1
 
 
 
 --------
 
 select num1,count(1) from(
 select MEMBER_KEY,count(distinct order_id ) num1 from factec_order where order_state>10 
 and add_time between 20170101 and 20171021 
and MEMBER_KEY in (select SSID from ls_test1 )
  and MEMBER_KEY in (select CUST_NO from fact_ec_order   where add_time between 20160101 and 20171021 and order_state>10 group by  CUST_NO)  
  group by MEMBER_KEY)   group  by num1
 
 
 
 insert into ls_test1 (SSID)

 select distinct(MEMBER_KEY) from factec_order where order_id in  (
select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171021 and order_state>10
 group by  CUST_NO) 
 and ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(select ITEM_CODE from dim_good where  GROUP_ID=1000)) 
 and order_state>10
and add_time between 20170101 and 20171021;
