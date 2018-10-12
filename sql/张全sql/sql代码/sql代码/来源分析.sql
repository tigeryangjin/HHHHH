
select M_LABEL_DESC,M_LABEL_ID,count(1)   from  MEMBER_LABEL_LINK_V where  MEMBER_Key in (
select distinct(MEMBER_KEY) from fact_goods_sales where GOODS_COMMON_KEY in(
select ITEM_CODE   from dim_good where  GOODS_NAME like '%严选%') and order_state=1)
group by M_LABEL_DESC,M_LABEL_ID

select *  from member_label_head
------整体会员
select M_LABEL_DESC1,M_LABEL_DESC2,count(1) from (
select a.MEMBER_Key,M_LABEL_DESC1,M_LABEL_DESC2 from (
select MEMBER_Key,M_LABEL_DESC M_LABEL_DESC1   from  MEMBER_LABEL_LINK_V where  MEMBER_Key in (
select  MEMBER_CRMBP from fact_ecmember where MEMBER_TIME >=20170101
) 
and M_LABEL_ID in (22,23,24,25,26)
) a left join 
(
select MEMBER_Key,M_LABEL_DESC M_LABEL_DESC2  from  MEMBER_LABEL_LINK_V where  MEMBER_Key in (
select  MEMBER_CRMBP from fact_ecmember where MEMBER_TIME >=20170101
) 
and M_LABEL_ID in (162,163,164,165,167)
) b on a.MEMBER_Key=b.MEMBER_Key
) group by  M_LABEL_DESC1,M_LABEL_DESC2


-------
select M_LABEL_DESC,M_LABEL_ID,count(1)   from  MEMBER_LABEL_LINK_V where  MEMBER_Key in (
select  MEMBER_CRMBP from fact_ecmember where MEMBER_TIME >=20170101
AND MEMBER_CRMBP IN 
(SELECT MEMBER_KEY from  MEMBER_LABEL_LINK_V where M_LABEL_DESC='推广' )
and MEMBER_CRMBP  not IN 
(SELECT MEMBER_KEY from  MEMBER_LABEL_LINK_V where M_LABEL_DESC='扫码' )
)
group by M_LABEL_DESC,M_LABEL_ID


--------

select M_LABEL_DESC,M_LABEL_ID,count(1)  from  MEMBER_LABEL_LINK_V where  MEMBER_Key in (
select  MEMBER_CRMBP from fact_ecmember where MEMBER_TIME >=20170101
AND MEMBER_CRMBP IN 
(SELECT MEMBER_KEY from  MEMBER_LABEL_LINK_V where M_LABEL_DESC='自然' )
and MEMBER_CRMBP IN 
(SELECT MEMBER_KEY from  MEMBER_LABEL_LINK_V where M_LABEL_DESC='首单为新人礼' )
)
group by M_LABEL_DESC,M_LABEL_ID


-----推广用户首单为新人礼后的转化率

select num1,count(1),sum(GOODS_AMOUNT) from (
select MEMBER_KEY,count(1) num1,sum(GOODS_AMOUNT) GOODS_AMOUNT  from  factec_order where  MEMBER_KEY in  (
select  MEMBER_CRMBP from fact_ecmember where MEMBER_TIME >=20170101
  -----调整部分
) and order_state>10 group by MEMBER_KEY
) group by num1

-------
select count(1),MEMBER_TIME from fact_ecmember where  MEMBER_TIME between 20170201 and 20170228
group by MEMBER_TIME
---
select count(1) from fact_visitor_register where APPLICATION_KEY in (10,20,50)
and CREATE_DATE_KEY>20170101  ---1704608  566427

select count(1) from fact_ecmember where MEMBER_TIME>20170101


----- 自然用户第一单下单地址
select APP_NAME,count(1) from factec_order where ORDER_ID in(
select min(ORDER_ID) from  factec_order where  MEMBER_Key in (
select  MEMBER_CRMBP from fact_ecmember where MEMBER_TIME >=20170101)
and order_state>10  group by MEMBER_Key)
and MEMBER_Key IN 
(SELECT MEMBER_KEY from  MEMBER_LABEL_LINK_V where M_LABEL_DESC='自然' )
group by APP_NAME

----- 扫码用户第一单下单地址
select APP_NAME,count(1) from factec_order where ORDER_ID in(
select min(ORDER_ID) from  factec_order where  MEMBER_Key in (
select  MEMBER_CRMBP from fact_ecmember where MEMBER_TIME >=20170101)
and order_state>10  group by MEMBER_Key)
and MEMBER_Key IN 
(SELECT MEMBER_KEY from  MEMBER_LABEL_LINK_V where M_LABEL_DESC='扫码' )
group by APP_NAME


----- 推广用户第一单下单地址
select APP_NAME,count(1) from factec_order where ORDER_ID in(
select min(ORDER_ID) from  factec_order where  MEMBER_Key in (
select  MEMBER_CRMBP from fact_ecmember where MEMBER_TIME >=20170101)
and order_state>10  group by MEMBER_Key)
and MEMBER_Key IN 
(SELECT MEMBER_KEY from  MEMBER_LABEL_LINK_V where M_LABEL_DESC='推广' )
group by APP_NAME
