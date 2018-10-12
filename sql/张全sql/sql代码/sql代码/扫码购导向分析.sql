---------- ɨ�빺

select MEMBER_KEY,CREATE_DATE_KEY from dim_vid_mem where   vid in(
select VID  from dim_vid_scan  where SCAN_DATE_KEY between 20170401 and 20170530
and IS_NEW=1)

--------------

select num3,count(distinct MEMBER_KEY),count(1),sum(num2) from (
select MEMBER_KEY,count(1) as num3,sum(order_amount) as num2,to_date(max(ADD_TIME))- to_date(min(SCAN_DATE_KEY)) as num1 from (
select a.MEMBER_KEY,ADD_TIME,ORDER_AMOUNT,SCAN_DATE_KEY from (
select MEMBER_KEY,add_time,ORDER_AMOUNT from factec_order where add_time between 20170401 and 20171131
and order_state>10) a  join 
(
select MEMBER_KEY,min(SCAN_DATE_KEY) SCAN_DATE_KEY from dim_vid_mem  s join (
select VID,SCAN_DATE_KEY  from dim_vid_scan  where SCAN_DATE_KEY between 20170401 and 20170530
and IS_NEW=1)  ss on s.vid=ss.vid  group by  MEMBER_KEY
) b  on a.member_key=b.MEMBER_KEY 
) where to_date(ADD_TIME)-to_date(SCAN_DATE_KEY) between 0 and 180
  group by MEMBER_KEY) group by num3


---------



select num3,count(distinct MEMBER_KEY),count(1),sum(num2) from (
select MEMBER_KEY,count(1) as num3,sum(order_amount) as num2,to_date(max(ADD_TIME))- to_date(min(SCAN_DATE_KEY)) as num1 from (
select a.MEMBER_KEY,ADD_TIME,ORDER_AMOUNT,SCAN_DATE_KEY from (
select MEMBER_KEY,add_time,ORDER_AMOUNT from factec_order where add_time between 20170701 and 20180331
and order_state>10) a  join 
(
select MEMBER_KEY,min(SCAN_DATE_KEY) SCAN_DATE_KEY from dim_vid_mem  s join (
select VID,SCAN_DATE_KEY  from dim_vid_scan  where SCAN_DATE_KEY between 20170701 and 20170830
and IS_NEW=1)  ss on s.vid=ss.vid  group by  MEMBER_KEY
) b  on a.member_key=b.MEMBER_KEY 
) where to_date(ADD_TIME)-to_date(SCAN_DATE_KEY) between 0 and 180
  group by MEMBER_KEY) group by num3

---------
select G_ID,count(1) from dim_wechat
group by G_ID
