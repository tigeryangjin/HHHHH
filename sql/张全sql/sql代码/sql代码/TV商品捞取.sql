--------------TV订购用户 （非TOP3）

select distinct MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  MEMBER_KEY  not in ( 



select MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  GOODS_COMMON_KEY IN(

select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY,sum(NUMS) num1   from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0 group by GOODS_COMMON_KEY ) order by NUM1 desc ) where   rownum<=3));


--------------TV订购用户 （TOP3）


select distinct MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  MEMBER_KEY  in ( 



select MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  GOODS_COMMON_KEY IN(

select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY,sum(NUMS) num1   from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0 group by GOODS_COMMON_KEY ) order by NUM1 desc ) where   rownum<=3))
and MEMBER_KEY not in ( 



select MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  GOODS_COMMON_KEY IN(

select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY,sum(NUMS) num1   from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0 group by GOODS_COMMON_KEY ) order by NUM1 desc ) where   rownum<=2));

--------------TV订购用户 （TOP2）


select distinct MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  MEMBER_KEY  in ( 



select MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  GOODS_COMMON_KEY IN(

select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY,sum(NUMS) num1   from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0 group by GOODS_COMMON_KEY ) order by NUM1 desc ) where   rownum<=2))
and MEMBER_KEY not in ( 



select MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  GOODS_COMMON_KEY IN(

select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY,sum(NUMS) num1   from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0 group by GOODS_COMMON_KEY ) order by NUM1 desc ) where   rownum<=1));


--------------TV订购用户 （TOP3）


select distinct MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  MEMBER_KEY  in ( 



select MEMBER_KEY from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0  and  GOODS_COMMON_KEY IN(

select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY from (
select GOODS_COMMON_KEY,sum(NUMS) num1   from fact_goods_sales where  ORDER_DATE_KEY=20171224 
and order_state=1
and SALES_SOURCE_KEY=10
and TRAN_TYPE=0 group by GOODS_COMMON_KEY ) order by NUM1 desc ) where   rownum<=1));


select distinct MEMBER_KEY  from factec_order where add_time between 20171201 and 20171224 and order_state>10
and order_amount>=2000
and PAYMENT_CODE='online'



-------------
select MATDLT,sum(num1),sum(num2) from (
select ITEM_CODE,sum(GOODS_NUM) num1,sum(GOODS_PAY_PRICE) num2 from factec_order_goods where order_id in (
select  ORDER_ID from  factec_order where 
 add_time between 20170101 and 20171224 and order_state>10 and   APP_NAME='KLGWX'
 and order_from !=76) and  GOODS_TYPE not in (5,6) group by ITEM_CODE)
 a left join dim_ec_good b on   a.ITEM_CODE=b.ITEM_CODE
 group by MATDLT
 
 
 ----  非扫码分类
 
 select MATDLT,sum(num1),sum(num2) from (
select ITEM_CODE,sum(GOODS_NUM) num1,sum(GOODS_PAY_PRICE*GOODS_NUM) num2   from factec_order_goods where order_id in (
select  ORDER_ID from  factec_order where 
 add_time between 20170101 and 20171224 and order_state>10 and   APP_NAME='KLGWX'
 and order_from !=76) and  GOODS_TYPE not in (5,6)
  group by ITEM_CODE)
 a left join dim_ec_good b on   a.ITEM_CODE=b.ITEM_CODE
 group by MATDLT
 
 
 ------------
 (
select sum(GOODS_NUM) num1,sum(GOODS_PAY_PRICE*GOODS_NUM) num2   from factec_order_goods where order_id in (
select  ORDER_ID from  factec_order where 
 add_time between 20170101 and 20171224 and order_state>10 and   APP_NAME='KLGWX'
 and order_from !=76) and  GOODS_TYPE not in (5,6)
 and GOODS_PRICE between 2000 and 5000
) 
 
 select count(distinct ORDER_ID ) from  factec_order where  add_time between 20170101 and 20171131 and order_state>10 
 and STORE_ID>5
 
 
 select * from  kpi_ec_tbl
 
 
 -------------------
 
 select AGENT,count(distinct MEMBER_KEY)   from  fact_visitor_register  where  CREATE_DATE_KEY between 20170101 and 20171231
 and APPLICATION_KEY in(10,20) group by  AGENT
