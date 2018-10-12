---总订购金额
select sum(ORDER_AMOUNT),sum(GOODS_NUM)  from factec_order  where ADD_TIME=20161021 and vid in(

SELECT distinct(vid) from fact_page_view s where s.visit_date_key=20161021 and ip in(

select  distinct(IP) from  fact_page_view s where s.visit_date_key=20161021  and s.page_name='TV_QRC')  );
---取消订购
select sum(ORDER_AMOUNT),sum(GOODS_NUM)  from factec_order  where ADD_TIME=20161021 and CANCEL_BEFORE_STATE=1 and ORDER_STATE<=0
and vid in(SELECT distinct(vid) from fact_page_view s where s.visit_date_key=20161021 and ip in(

select  distinct(IP) from  fact_page_view s where s.visit_date_key=20161021  and s.page_name='TV_QRC')  );

--- 净订购件单价

---拒退
select sum(ORDER_AMOUNT)  from factec_order  where ADD_TIME between 20161015 and 20161020 and LAST_TIME>1476979200
and CANCEL_BEFORE_STATE=0 and ORDER_STATE<=0
and vid in(SELECT distinct(vid) from fact_page_view s where s.visit_date_key=ADD_TIME and ip in(

select  distinct(IP) from  fact_page_view s where s.visit_date_key=ADD_TIME  and s.page_name='TV_QRC')  );
