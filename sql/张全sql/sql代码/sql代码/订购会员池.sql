

------ 月度总体订购会员池
(select count(distinct member_key),count(1),sum(order_amount),'整体' from factec_order where 
substr(add_time,1,6)=201805
and  order_state>10 and STORE_ID=1 and order_from !=76)

union 

-------月度纳新订购会员
(
select count(distinct member_key),count(1),sum(order_amount),'纳新' from factec_order where 
substr(add_time,1,6)=201805
and  order_state>10 and STORE_ID=1 and order_from !=76
and member_key in (select MEMBER_CRMBP from fact_ecmember where substr(MEMBER_TIME,1,6)=201805)
and  order_state>10  )
union 
-------月度唤醒订购会员
(
select count(distinct member_key),count(1),sum(order_amount),'唤醒' from factec_order where 
substr(add_time,1,6)=201805
and  order_state>10 and STORE_ID=1 and order_from !=76
and member_key not in (select MEMBER_CRMBP from fact_ecmember where  substr(MEMBER_TIME,1,6)=201805)
and member_key not in (select distinct member_key from factec_order where 
substr(add_time,1,6) in (201803,201804)
and  order_state>10  ))

union 
-------月度复购会员
(
select count(distinct member_key),count(1),sum(order_amount),'留存' from factec_order where
substr(add_time,1,6)=201805
and  order_state>10 and STORE_ID=1 and order_from !=76
and member_key not in (select MEMBER_CRMBP from fact_ecmember where 
substr(MEMBER_TIME,1,6)=201805)
and member_key in (select distinct member_key from factec_order where
substr(add_time,1,6) in (201803,201804)
and  order_state>10  ))


---- 流失会员数

select count(distinct member_key) from factec_order where substr(add_time,1,6)=201803
and  order_state>10 and STORE_ID=1 and order_from !=76
and  member_key not in(

select member_key from factec_order where substr(add_time,1,6) in (201804,201805)
and  order_state>10 and STORE_ID=1 and order_from !=76
);


