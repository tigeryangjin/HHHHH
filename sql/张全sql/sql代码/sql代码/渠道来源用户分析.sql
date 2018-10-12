------新客分析(定义新客)
truncate table ls_test3;
create global temporary table ls_test3 (col1 varchar(200),col2 NUMBER(20),col3 NUMBER(20),col4 varchar(200)) On Commit Preserve Rows;
insert into  ls_test3 
(
select M_LABEL_DESC as col1,MEMBER_BP as col2,FIRST_ACTIVE_DATE_KEY as col3,FIRST_ACTIVE_VID  as col4  from (
select M_LABEL_DESC,MEMBER_BP,FIRST_ACTIVE_DATE_KEY,FIRST_ACTIVE_VID  from(
select MEMBER_KEY,M_LABEL_DESC from MEMBER_LABEL_LINK_V where  M_LABEL_DESC in ('扫码','自然','推广')
)a  left join 
(select MEMBER_BP,FIRST_ACTIVE_DATE_KEY,FIRST_ACTIVE_VID from dim_member 
where FIRST_ACTIVE_DATE_KEY between 20170701 and 20171231)  b 
on a.MEMBER_KEY=b.MEMBER_BP) where FIRST_ACTIVE_DATE_KEY is not null )

-----新客行为分析 
select APPLICATION_KEY,PAGE_NAME,count(1),count(distinct vid) from fact_page_view where  visit_date_key between 20170701 and 20171231 
and SESSION_KEY in (
select min(SESSION_KEY) from  fact_session where START_DATE_KEY between 20170701 and 20171231
and vid in (
select COL4  from ls_test3 where col3 between 20170701 and 20171231)
group by vid) 
group by  APPLICATION_KEY,PAGE_NAME
----------------------------------------------------------------------------------------------------------------------------
----新客订购分析 
----(播出非播出)【整体】
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),LIVE_STATE,REPLAY_STATE,SALES_SOURCE_SECOND_KEY
 from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY FROM  FACT_GOODS_SALES WHERE ORDER_KEY IN (
select min(CRM_ORDER_NO) from factec_order where MEMBER_KEY in(
select COL2  from ls_test3) AND  ORDER_STATE>10 
GROUP BY MEMBER_KEY
) and TRAN_TYPE=0) a left join 
(
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE)   group by LIVE_STATE,REPLAY_STATE,SALES_SOURCE_SECOND_KEY;
----(播出非播出)【推广】
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),LIVE_STATE,REPLAY_STATE,SALES_SOURCE_SECOND_KEY
 from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY FROM  FACT_GOODS_SALES WHERE ORDER_KEY IN (
select min(CRM_ORDER_NO) from factec_order where MEMBER_KEY in(
select COL2  from ls_test3 where COL1='推广' ) AND  ORDER_STATE>10 
GROUP BY MEMBER_KEY
) and TRAN_TYPE=0) a left join 
(
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE)   group by LIVE_STATE,REPLAY_STATE,SALES_SOURCE_SECOND_KEY;

----(播出非播出)【扫码】
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),LIVE_STATE,REPLAY_STATE,SALES_SOURCE_SECOND_KEY
 from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY FROM  FACT_GOODS_SALES WHERE ORDER_KEY IN (
select min(CRM_ORDER_NO) from factec_order where MEMBER_KEY in(
select COL2  from ls_test3 where COL1='扫码' ) AND  ORDER_STATE>10 
GROUP BY MEMBER_KEY
) and TRAN_TYPE=0) a left join 
(
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE)   group by LIVE_STATE,REPLAY_STATE,SALES_SOURCE_SECOND_KEY;


----(播出非播出)【自然】
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),LIVE_STATE,REPLAY_STATE,SALES_SOURCE_SECOND_KEY
 from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY FROM  FACT_GOODS_SALES WHERE ORDER_KEY IN (
select min(CRM_ORDER_NO) from factec_order where MEMBER_KEY in(
select COL2  from ls_test3 where COL1='自然' ) AND  ORDER_STATE>10 
GROUP BY MEMBER_KEY
) and TRAN_TYPE=0) a left join 
(
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE)   group by LIVE_STATE,REPLAY_STATE,SALES_SOURCE_SECOND_KEY;
------------------------------------------------------------------------------------------------------------------------------------
---(类目分析)【整体】
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),GROUP_NAME,MATDLT
 from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY FROM  FACT_GOODS_SALES WHERE ORDER_KEY IN (
select min(CRM_ORDER_NO) from factec_order where MEMBER_KEY in(
select COL2  from ls_test3) AND  ORDER_STATE>10 
and add_time  between 20170701 and 20171231
GROUP BY MEMBER_KEY
) and TRAN_TYPE=0) a left join 
(
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE)   group by GROUP_NAME,MATDLT;
---(类目分析)【推广】
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),GROUP_NAME,MATDLT
 from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY FROM  FACT_GOODS_SALES WHERE ORDER_KEY IN (
select min(CRM_ORDER_NO) from factec_order where MEMBER_KEY in(
select COL2  from ls_test3  where COL1='推广') AND  ORDER_STATE>10 
and add_time  between 20170701 and 20171231
GROUP BY MEMBER_KEY
) and TRAN_TYPE=0) a left join 
(
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE)   group by GROUP_NAME,MATDLT;
---(类目分析)【扫码】
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),GROUP_NAME,MATDLT
 from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY FROM  FACT_GOODS_SALES WHERE ORDER_KEY IN (
select min(CRM_ORDER_NO) from factec_order where MEMBER_KEY in(
select COL2  from ls_test3 where COL1='扫码') AND  ORDER_STATE>10 
and add_time  between 20170701 and 20171231
GROUP BY MEMBER_KEY
) and TRAN_TYPE=0) a left join 
(
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE)   group by GROUP_NAME,MATDLT;
---(类目分析)【自然】
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),GROUP_NAME,MATDLT
 from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY FROM  FACT_GOODS_SALES WHERE ORDER_KEY IN (
select min(CRM_ORDER_NO) from factec_order where MEMBER_KEY in(
select COL2  from ls_test3  where COL1='自然') AND  ORDER_STATE>10 
and add_time  between 20170701 and 20171231
GROUP BY MEMBER_KEY
) and TRAN_TYPE=0) a left join 
(
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE)   group by GROUP_NAME,MATDLT;



----新客搜索分析
----整体
select SKW,count(1) from fact_search where  id in (
select min(ID) from fact_search where VID in 
(
select COL4   from ls_test3 )
and CREATE_DATE_KEY between 20170701 and 20171231 
and APPLICATION_KEY in(10,20) group by VID)
group by SKW
---推广
select SKW,count(1) from fact_search where  id in (
select min(ID) from fact_search where VID in 
(
select COL4   from ls_test3 where COL1='推广' )
and CREATE_DATE_KEY between 20170701 and 20171231 
and APPLICATION_KEY in(10,20) group by VID)
group by SKW
---扫码
select SKW,count(1) from fact_search where  id in (
select min(ID) from fact_search where VID in 
(
select COL4   from ls_test3 where COL1='扫码' )
and CREATE_DATE_KEY between 20170701 and 20171231 
and APPLICATION_KEY in(10,20) group by VID)
group by SKW
---自然
select SKW,count(1) from fact_search where  id in (
select min(ID) from fact_search where VID in 
(
select COL4   from ls_test3 where COL1='自然' )
and CREATE_DATE_KEY between 20170701 and 20171231 
and APPLICATION_KEY in(10,20) group by VID)
group by SKW


------老客分析(定义老客)

create global temporary table ls_test4 (col1 varchar(200),col2 NUMBER(20),col3 NUMBER(20),col4 varchar(200)) On Commit Preserve Rows;
insert into  ls_test4 
(
select M_LABEL_DESC as col1,MEMBER_BP as col2,FIRSTW_ORDER_DATE_KEY as col3,FIRST_ACTIVE_VID  as col4  from (
select M_LABEL_DESC,MEMBER_BP,FIRSTW_ORDER_DATE_KEY,FIRST_ACTIVE_VID  from(
select MEMBER_KEY,M_LABEL_DESC from MEMBER_LABEL_LINK_V where  M_LABEL_DESC in ('扫码','自然','推广')
)a  left join 
(select MEMBER_BP,FIRSTW_ORDER_DATE_KEY,FIRST_ACTIVE_VID  from dim_member 
where FIRSTW_ORDER_DATE_KEY <20170701 and FIRSTW_ORDER_DATE_KEY >0)  b 
on a.MEMBER_KEY=b.MEMBER_BP) where FIRST_ACTIVE_VID !='unknown' );
select * from ls_test4

----老客复购分析

select * from (
select * from (
SELECT GOODS_COMMON_KEY,LIVE_STATE,REPLAY_STATE,ORDER_AMOUNT,NUMS,MEMBER_KEY,SALES_SOURCE_SECOND_KEY 
 FROM  FACT_GOODS_SALES WHERE  MEMBER_KEY in(
select COL2  from ls_test4)  AND POSTING_DATE_KEY between 20170701 and 20171231 
and ORDER_STATE=1 
and TRAN_TYPE=0 
) a  left join (
select ITEM_CODE,GOODS_NAME,MATDLT,GROUP_NAME,GOOD_PRICE_LEVEL from dim_good
) b on a.GOODS_COMMON_KEY=b.ITEM_CODE
) 
---

select count(1) from fact_visitor_register where CREATE_DATE_KEY between 20170901 and 20171231
and  APPLICATION_KEY in (10,20) 
and  MEMBER_KEY in (select MEMBER_BP from dim_member where FIRST_ACTIVE_VID like 'wxoeNK%' )
and member_key in (
select MEMBER_KEY from MEMBER_LABEL_LINK_V where  M_LABEL_DESC='扫码'
)
and MEMBER_KEY in (select MEMBER_KEY from MEMBER_LABEL_LINK_V where  M_LABEL_DESC in ('扫码'))


select count(1),hmsc from fact_visitor_register where CREATE_DATE_KEY between 20170901 and 20171231
and  APPLICATION_KEY in (10,20) 
group by hmsc


select ITEM_CODE,GOODS_NAME,MATDLT,GOODS_PRICE,sum(num1),sum(num2) from (
select * from (
select ITEM_CODE,GOODS_NAME,FIRSTONSELLTIME,MATDLT,GOODS_PRICE   from DIM_EC_GOOD where FIRSTONSELLTIME between 20170101 and 20171231 and IS_TV=0
 and STORE_ID=1) a left join (select GOODS_COMMON_KEY,ORDER_DATE_KEY,sum(NUMS) num1,sum(ORDER_AMOUNT) num2 from  fact_goods_sales where ORDER_DATE_KEY between 20170101 and 20171231  and SALES_SOURCE_KEY=20
and  GOODS_COMMON_KEY  in (
select ITEM_CODE from DIM_EC_GOOD where FIRSTONSELLTIME between 20170101 and 20171231 and IS_TV=0
)
and ORDER_STATE=1 and TRAN_TYPE=0 group by GOODS_COMMON_KEY,ORDER_DATE_KEY) b
on a.ITEM_CODE=b.GOODS_COMMON_KEY and  b.ORDER_DATE_KEY between a.FIRSTONSELLTIME 
and to_char(to_date(a.FIRSTONSELLTIME)+30,'yyyymmdd')) group by ITEM_CODE,GOODS_NAME,MATDLT,GOODS_PRICE




select avg(order_amount),sum(order_amount) from factec_order where add_time  between 20170701 and 20171231
and order_state>10 
and order_from=76


select ORDER_KEY,MEMBER_KEY,REJECT_RETURN,UPDATE_TIME from fact_goods_sales_reverse where ORDER_DATE_KEY between 20170101 and 20171231
and  GOODS_COMMON_KEY in(210214,210215) and CANCEL_STATE=0 and REJECT_RETURN!=20

select sum(PAY_AMOUNT-COST_AMOUNT),count(1) from  fact_order where   ORDER_OBJ_ID in   (
select CRM_ORDER_NO from factec_order where  ADD_TIME between 20170101 and 20171231 and order_from=76 
and order_state>10 )  
