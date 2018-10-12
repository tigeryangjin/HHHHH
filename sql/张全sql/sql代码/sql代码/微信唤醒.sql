select * from fact_ec_order where add_time=20170912 
and VID in (
select OPEN_ID from dim_wechat  where OPEN_ID in ( 
select vid from  dim_vid_mem
where MEMBER_KEY in(
select MEMBER_KEY  from  fact_goods_sales where POSTING_DATE_KEY between 20170501 and 20170731
and GOODS_COMMON_KEY  in  (
select ITEM_CODE  from dim_ec_good where  GOODS_NAME like '%纽仕兰%' )
))  and STATUS=0)

----------
select * from fact_session where sta

select * from fact_ec_ordergoods where ORDER_ID in (
select * from fact_ec_order where add_time=20170912   and  CUST_NO in (
select MEMBER_KEY from  dim_vid_mem where vid in (
select SNAME from  ls_test)) and ORDER_ID>10)


 for update

-------


select OPEN_ID from dim_wechat  where OPEN_ID in ( 
select VID from dim_vid_mem where MEMBER_KEY in(
select DISTINCT MEMBER_KEY from fact_page_view where 
visit_date_key between 20170701 and 20170831
and page_name='Good'
and page_value in 
(
select TO_CHAR(GOODS_COMMONID) from dim_ec_good where  GOODS_NAME like '%电视%' AND  GC_NAME like '%大家电%'
)) and  MEMBER_KEY not in(
select MEMBER_KEY  from  fact_goods_sales where POSTING_DATE_KEY between 20170501 and 20170731
and GOODS_COMMON_KEY  in  (
select ITEM_CODE  from dim_ec_good where  GOODS_NAME like '%电视%' )
))  and STATUS=0


----
select sum(ORDER_AMOUNT),sum(nums), GOODS_COMMON_KEY  from fact_goods_sales where POSTING_DATE_KEY between 20160901 and 20161231
and SALES_SOURCE_KEY=20 and  ORDER_STATE=1
and  GOODS_COMMON_KEY  in  (
select ITEM_CODE  from dim_ec_good where  MATKLT='保暖内衣')
group by GOODS_COMMON_KEY



-----浏览人数
select COUNT(DISTINCT(VID)) from fact_session  where  START_DATE_KEY between 20170912 AND 20170913
AND APPLICATION_KEY=50 and ( MEMBER_KEY in (
(select distinct MEMBER_KEY  from  dim_vid_mem where
 VID IN (
select S2 from ls_test1 )))

or VID IN (
select S2 from ls_test1 ))


----  订购人数

select count(distinct(CUST_NO)),sum(order_amount),count(1)    from fact_ec_order  where  add_time between 20170912 AND 20170912
and ORDER_STATE>10
 and ( CUST_NO in (
(select distinct MEMBER_KEY  from  dim_vid_mem where
 VID IN (
select S2 from ls_test1 )))

or VID IN (
select S2 from ls_test1 ))

----取关人数

select STATUS,count(1),CANCEL_SUBSCRIBE_TIME  from dim_wechat 
where  OPEN_ID
IN (
select S2 from ls_test1 ) group by STATUS,CANCEL_SUBSCRIBE_TIME


select S2 from ls_test1



-----目标商品
select * from  fact_ec_order_goods where ORDER_ID in (
select distinct(order_id)  from fact_ec_order  where  add_time between 20170912 AND 20170912
and ORDER_STATE>10
 and ( CUST_NO in (
(select distinct MEMBER_KEY  from  dim_vid_mem where
 VID IN (
select S2 from ls_test1 )))

or VID IN (
select S2 from ls_test1 )))


-----
select * from dim_member where MEMBER_BP in (
select CUST_NO from  fact_ec_order where ORDER_ID in (
select ORDER_ID from  fact_ec_order_goods  where GOODS_ID=245212)) 


-----
select count(distinct vid ) from fact_ec_order where vid in (
select SNAME from  ls_test )
and ORDER_STATE>10 and ADD_TIME>20170901
