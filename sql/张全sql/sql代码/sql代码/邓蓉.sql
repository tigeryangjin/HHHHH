---注册数(扫码标签)
select count(1),MEMBER_TIME from fact_ecmember where  MEMBER_TIME between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
and  MEMBER_CRMBP in(
select MEMBER_KEY from fact_session where 
 VID in  (select VID from dim_vid_scan where SCAN_DATE_KEY between to_char(sysdate-103,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd'))
and START_DATE_KEY  between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
)
group by MEMBER_TIME

--- 注册数
select count(1),MEMBER_TIME from fact_ecmember where  MEMBER_TIME between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
group by MEMBER_TIME

-----日活数
select * from (
select count(distinct(vid)) num1,START_DATE_KEY from fact_session where START_DATE_KEY 
  between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
and  APPLICATION_KEY in (10,20)
 and vid in (
select VID from dim_vid_scan where  SCAN_DATE_KEY between to_char(sysdate-103,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd'))
group by START_DATE_KEY) aa
left join 
(
select count(distinct(vid)) num2,START_DATE_KEY from fact_session where 
START_DATE_KEY   between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
and  APPLICATION_KEY in (10,20)  
group by START_DATE_KEY
) bb on aa.START_DATE_KEY=bb.START_DATE_KEY
----

select count(distinct(vid)),sum(GOODS_NUM),count(1),sum(ORDER_AMOUNT),ADD_TIME from factec_order where  ADD_TIME   
between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
and  vid in (
select VID from dim_vid_scan where  
SCAN_DATE_KEY between to_char(sysdate-103,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd'))
and order_state>10 group by  ADD_TIME

----
select count(distinct(vid)),sum(GOODS_NUM),count(1),sum(ORDER_AMOUNT),ADD_TIME from factec_order where  ADD_TIME   
between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
and order_state>10 group by  ADD_TIME
