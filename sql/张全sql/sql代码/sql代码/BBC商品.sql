 select M_LABEL_DESC,M_LABEL_ID,count(1)   from  MEMBER_LABEL_LINK_V where  MEMBER_Key in (
select MEMBER_KEY from factec_order  where STORE_ID >1 and order_state>10)
group by M_LABEL_DESC,M_LABEL_ID


----- 956

select count(distinct(MEMBER_KEY)) from factec_order where
 order_id in  (select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171001 and order_state>10 group by  CUST_NO) and 
 STORE_ID >1 

----  9880
 select count(distinct(MEMBER_KEY)) from factec_order where
 ---order_id in  (select min(order_id) from fact_ec_order   where add_time between 20160101 and 20171001 and order_state>10 group by  CUST_NO) and 
 STORE_ID >1 
