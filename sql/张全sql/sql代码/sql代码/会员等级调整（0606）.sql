select MEMBER_KEY,sum(order_amount) from factec_order where  ADD_TIME between 20170101 and 20171231 and order_state>10 and
STORE_ID =1 group by  MEMBER_KEY

---------------
select (
case  when  num1=1 AND order_amount<1000 then '快乐会员'
      when  num1>1 AND order_amount<1000 then '黄金会员'
     when order_amount BETWEEN 1000 AND 3000 then '白金会员' 
     when order_amount BETWEEN 3000 AND 8000 then '钻石会员'
        when order_amount>=8000 then 'VIP'  END ),COUNT(1) from (
select MEMBER_KEY,sum(order_amount) order_amount,count(1) num1 from fact_order where  ORDER_DATE_KEY   
between 20170101 and 20171231  and order_state=1
and member_key in( select MEMBER_CRMBP from fact_ecmember) 
and member_key in (select member_key from factec_order where add_time between 20170101 and 20171231  
and order_state>10   group by  member_key)  group by MEMBER_KEY) GROUP BY  (
case  when  num1=1 AND order_amount<1000 then '快乐会员'
      when  num1>1 AND order_amount<1000 then '黄金会员'
     when order_amount BETWEEN 1000 AND 3000 then '白金会员' 
     when order_amount BETWEEN 3000 AND 8000 then '钻石会员'
        when order_amount>=8000 then 'VIP'  END )

----------------
select VOUCHER_TITLE,sum(order_amount),sum(VOUCHER_PRICE),sum(num1),sum(num2) from(
select  VOUCHER_REF,sum(order_amount) order_amount,sum(VOUCHER_PRICE)   VOUCHER_PRICE,count(1)  num2 from factec_order where   order_state>10 and
 add_time between 20180101 and 20180531 and VOUCHER_REF in(
select distinct(VOUCHER_T_ID)  from fact_voucher where VOUCHER_ACTIVE_DATE between  20180101 and 20180531
and VOUCHER_TITLE like '%生日券%' )  group by VOUCHER_REF)
a join (
select VOUCHER_T_ID,VOUCHER_TITLE,count(1)  num1 from fact_voucher where VOUCHER_ACTIVE_DATE between  20180101 and 20180531
and VOUCHER_TITLE like '%生日券%' group by VOUCHER_T_ID,VOUCHER_TITLE )  b on 
a.VOUCHER_REF=b.VOUCHER_T_ID   group by  VOUCHER_TITLE

------------------
---------------
select lei,(case when ORDER_AMOUNT <129  then  '129以下'
                 when ORDER_AMOUNT between 129 AND 199  then '199以下'  else '199以上' end   ),count(1) from (
select (
case  when  num1=1 AND order_amount<1000 then '快乐会员'
      when  num1>1 AND order_amount<1000 then '黄金会员'
     when order_amount BETWEEN 1000 AND 3000 then '白金会员' 
     when order_amount BETWEEN 3000 AND 8000 then '钻石会员'
        when order_amount>=8000 then 'VIP'  END ) lei ,MEMBER_KEY  from (
select MEMBER_KEY,sum(order_amount) order_amount,count(1) num1 from fact_order where  ORDER_DATE_KEY   
between 20170101 and 20171231  and order_state=1
and member_key in( select MEMBER_CRMBP from fact_ecmember) group by MEMBER_KEY) GROUP BY  (
case  when  num1=1 AND order_amount<1000 then '快乐会员'
      when  num1>1 AND order_amount<1000 then '黄金会员'
     when order_amount BETWEEN 1000 AND 3000 then '白金会员' 
     when order_amount BETWEEN 3000 AND 8000 then '钻石会员'
        when order_amount>=8000 then 'VIP'  END ),MEMBER_KEY) a join (
          
        select MEMBER_KEY,ORDER_AMOUNT from factec_order where ADD_TIME  between 20170101 and 20171231  
        and order_state>10) b on a.MEMBER_KEY=b.MEMBER_KEY
        group by lei,(case when ORDER_AMOUNT <129  then  '129以下'
                 when ORDER_AMOUNT between 129 AND 199  then '199以下'  else '199以上' end   )
                   
-------------
select count(1) from fact_ecmember where MEMBER_TIME<20171231
---------------
select lei,sum(order_amount),count(distinct a.MEMBER_KEY ) from 
 (
select (
case  when  num1=1 AND order_amount<1000 then '快乐会员'
      when  num1>1 AND order_amount<1000 then '黄金会员'
     when order_amount BETWEEN 1000 AND 3000 then '白金会员' 
     when order_amount BETWEEN 3000 AND 8000 then '钻石会员'
        when order_amount>=8000 then 'VIP'  END ) lei ,MEMBER_KEY  from (
select MEMBER_KEY,sum(order_amount) order_amount,count(1) num1 from fact_order where  ORDER_DATE_KEY   
between 20170101 and 20171231  and order_state=1
and member_key in( select MEMBER_CRMBP from fact_ecmember) group by MEMBER_KEY) GROUP BY  (
case  when  num1=1 AND order_amount<1000 then '快乐会员'
      when  num1>1 AND order_amount<1000 then '黄金会员'
     when order_amount BETWEEN 1000 AND 3000 then '白金会员' 
     when order_amount BETWEEN 3000 AND 8000 then '钻石会员'
        when order_amount>=8000 then 'VIP'  END ),MEMBER_KEY) a join (
          
        select MEMBER_KEY,ORDER_AMOUNT from factec_order where ADD_TIME  between 20170101 and 20171231  
        and order_state>10) b on a.MEMBER_KEY=b.MEMBER_KEY
        group by lei
        
        ---------
        
        
        
select (
case  when   order_amount<1000 then '1000'
     when order_amount BETWEEN 1000 AND 3000 then '3000' 
     when order_amount BETWEEN 3000 AND 8000 then '8000'
        when order_amount BETWEEN 8000 AND 10000 then '10000'
            when order_amount BETWEEN 10000 AND 15000 then '15000'  else '15000以上'  END ) lei ,count( distinct MEMBER_KEY)  from (
select MEMBER_KEY,sum(order_amount) order_amount,count(1) num1 from fact_order where  ORDER_DATE_KEY   
between 20170101 and 20171231  and order_state=1 AND  SALES_SOURCE_KEY IN (20)
and member_key in( select MEMBER_CRMBP from fact_ecmember) group by MEMBER_KEY) GROUP BY (
case  when   order_amount<1000 then '1000'
     when order_amount BETWEEN 1000 AND 3000 then '3000' 
     when order_amount BETWEEN 3000 AND 8000 then '8000'
        when order_amount BETWEEN 8000 AND 10000 then '10000'
            when order_amount BETWEEN 10000 AND 15000 then '15000'  else '15000以上'  END )
-------
select dengji,maoli,sum(order_amount) from (
select (
case  when  num1=1 AND order_amount<1000 then '快乐会员'
      when  num1>1 AND order_amount<1000 then '黄金会员'
     when order_amount BETWEEN 1000 AND 3000 then '白金会员' 
     when order_amount BETWEEN 3000 AND 8000 then '钻石会员'
        when order_amount>=8000 then 'VIP'  END ) dengji,MEMBER_KEY from (
select MEMBER_KEY,sum(order_amount) order_amount,count(1) num1 from fact_order where  ORDER_DATE_KEY   
between 20170101 and 20171231 and order_state=1
and member_key in( select MEMBER_CRMBP from fact_ecmember) 
and member_key in (select member_key from factec_order where add_time between 20170101 and 20171231
and order_state>10   group by  member_key)  group by MEMBER_KEY) GROUP BY  MEMBER_KEY,(
case  when  num1=1 AND order_amount<1000 then '快乐会员'
      when  num1>1 AND order_amount<1000 then '黄金会员'
     when order_amount BETWEEN 1000 AND 3000 then '白金会员' 
     when order_amount BETWEEN 3000 AND 8000 then '钻石会员'
        when order_amount>=8000 then 'VIP'  END )
          ) ss join (
---------
select 
( case when  num1 between 0.15 and 0.3 then   '15-30%以下毛利'
  when  num1 <0.15 then   '15%以下毛利段'
    else  '30%以上毛利段' end
) maoli,sum(order_amount) order_amount,member_key

 from (

select  (UNIT_PRICE-COST_PRICE)/(UNIT_PRICE) num1 ,order_amount,member_key   from fact_goods_sales where  order_state=1
and ORDER_DATE_KEY between 20170101 and 20171231
and SALES_SOURCE_KEY=20 and TRAN_TYPe=0
and UNIT_PRICE>0
and SALES_SOURCE_SECOND_KEY in (20017,20020,20021,20022,20023)   )   group by 
( case when  num1 between 0.15 and 0.3 then   '15-30%以下毛利'
  when  num1 <0.15 then   '15%以下毛利段'
    else  '30%以上毛利段' end
) ,member_key) sss on ss.member_key=sss.member_key
        
        group by dengji,maoli
          
 
select sum(UVCNT)/31,sum(LITEUVCNT)/31 from fact_daily_wx where visit_date_key between 20180501 and 20180531;

select avg(num1) from (
select count(distinct vid)  num1,visit_date_key from fact_page_view where  visit_date_key  between 20180601 and 20180610
and APPLICATION_KEY in(70) group by visit_date_key);
select avg(num1) from (
select count(distinct vid)  num1,START_DATE_KEY  from fact_session where  START_DATE_KEY  between 20180601 and 20180610
and APPLICATION_KEY in(50,70) group by START_DATE_KEY);


select count(distinct vid),count(1) from  fact_page_view where visit_date_key between 20180610 and 20180611
and page_value='packageCashwechat'


select count(distinct vid),count(1),visit_date_key from fact_page_view where 
visit_date_key between 20180601 and 20180611
and page_name='MGTV_QRC' group by visit_date_key

select  * from factec_order where 
add_time  between 20180601 and 20180611
and order_from=990 and order_state>10


----------------

 (
---------
select 
( case when  num1 between 0.2 and 0.3 then   '20-30%以下毛利'
  when  num1 <0.2 then   '20%以下毛利段'
    else  '30%以上毛利段' end
) maoli,sum(order_amount) order_amount,MEMBER_GRADE_DESC

 from (

select  (UNIT_PRICE-COST_PRICE)/(UNIT_PRICE) num1 ,order_amount,MEMBER_GRADE_DESC  from fact_goods_sales where  order_state=1
and ORDER_DATE_KEY between 20170101 and 20171231
and SALES_SOURCE_KEY=20 and TRAN_TYPe=0
and UNIT_PRICE>0
and SALES_SOURCE_SECOND_KEY in (20017,20020,20021,20022,20023)   )   group by ( case when  num1 between 0.2 and 0.3 then   '20-30%以下毛利'
  when  num1 <0.2 then   '20%以下毛利段'
    else  '30%以上毛利段' end
) ,MEMBER_GRADE_DESC)


-------------
(
select  sum(TV_DISCOUNT_AMOUNT) from fact_ec_order_goods where  TV_DISCOUNT_AMOUNT>0
and order_id in(
select ORDER_ID from factec_order where add_time between 20170101 and 20171231
and order_from!=76 and order_state>10) and order_id in(
select  ORDER_ID from fact_ec_order_goods where  TV_DISCOUNT_AMOUNT>0)


select * from (
select (GOODS_AMOUNT-ORDER_AMOUNT-VOUCHER_PRICE) num1, GOODS_AMOUNT,ORDER_AMOUNT,VOUCHER_PRICE from factec_order where add_time between 20170101 and 20171231
and order_from=76 and order_state>10) where num1 in(20,30)

-----------
select MEMBER_GRADE_DESC,count(distinct MEMBER_KEY)  from fact_order
 where   ORDER_DATE_KEY between 20170101 and 20171231
and order_state=1
and SALES_SOURCE_KEY=20  group by MEMBER_GRADE_DESC


-------------
select max(visit_date) from fact_page_view where visit_date_key =20180615
