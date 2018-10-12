-----------微信社群分析  社群会员数、总的有效订单数、有效订购额，会员等级占比情况、订购商品件数、订单优惠差额；
select MEMBER_GRADE_DESC,MEMBER_KEY,count(distinct ORDER_KEY),sum(NUMS),sum(UNIT_PRICE),sum(BARGAIN_PRICE) from  fact_goods_sales where  ORDER_DATE_KEY between  20170901 and 20180228
and order_state=1  and  SALES_SOURCE_KEY=10 and  TRAN_TYPE=0 and
MEMBER_KEY in(
select distinct MEMBER_KEY from dim_vid_mem where   VID in (
select SNAME from ls_test  )) group by MEMBER_GRADE_DESC,MEMBER_KEY


-------
select * from (
select   GOODS_COMMON_KEY ,count(distinct MEMBER_KEY),count(distinct ORDER_KEY),sum(NUMS),sum(UNIT_PRICE),sum(BARGAIN_PRICE)  from  fact_goods_sales where  ORDER_DATE_KEY between  20170901 and 20180228
and order_state=1  and  SALES_SOURCE_KEY=20 and  TRAN_TYPE=0 and
MEMBER_KEY in(
select distinct MEMBER_KEY from dim_vid_mem where   VID in (
select SNAME from ls_test  )) group by GOODS_COMMON_KEY) a
left join dim_ec_good b on  a.GOODS_COMMON_KEY=b.item_code
------

select * from dim_vid_mem where   VID in (
select SNAME from ls_test  )
