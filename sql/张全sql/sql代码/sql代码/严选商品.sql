
 select M_LABEL_DESC,M_LABEL_ID,count(1)   from  MEMBER_LABEL_LINK_V where  MEMBER_Key in (
select distinct(MEMBER_KEY) from fact_goods_sales where GOODS_COMMON_KEY in(
select ITEM_CODE   from dim_good where  GOODS_NAME like '%严选%') and order_state=1)
group by M_LABEL_DESC,M_LABEL_ID


---- 567人
select count(distinct(MEMBER_KEY)) from factec_order where order_id in  (
select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171001 and order_state>10
 group by  CUST_NO) and ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(
select ITEM_CODE from dim_good where   GOODS_NAME like '%严选%'))

----- 6291

select count(distinct(MEMBER_KEY)) from factec_order where
 ---order_id in  (select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171001 and order_state>10 group by  CUST_NO) and 
 ORDER_ID in (select ORDER_ID from factec_order_goods where ITEM_CODE in(select ITEM_CODE from dim_good where  GOODS_NAME like '%严选%'))



------
select count(distinct vid),count(distinct ip),count(1) from fact_page_view where visit_date_key between 20171016 and 20171016
and url like '%http://game.happigo.com/App/Onekq1020%'


select * from  factec_order_goods where ITEM_CODE=


select * from factec_order where add_time>20171015
and


