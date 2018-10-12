-----激活
select count(distinct(vid)),SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY between 20170421 and 20170427
and  SCAN_DATE_KEY=ACTIVE_DATE_KEY 
and  (vid like '%android%'  or  vid like '%iphone%') group by SCAN_DATE_KEY

---
select ADD_TIME,count(distinct(vid1)),sum(ORDER_AMOUNT),sum(num1) from (
select * from 
(select VID,SCAN_DATE_KEY from  dim_vid_scan  where SCAN_DATE_KEY between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
and  (vid like '%android%'  or  vid like '%iphone%'))  aa left join 
(select vid vid1,sum(ORDER_AMOUNT) ORDER_AMOUNT,count(1) num1,ADD_TIME from factec_order where 
 ADD_TIME between  to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
--- and order_state>10 
  group by ADD_TIME,vid  ) bb on aa.VID=bb.VID1 and aa.SCAN_DATE_KEY=bb.ADD_TIME)
 where  NUM1 is not null  group by  ADD_TIME
 
 select count(distinct(vid)) UV ,sum(ORDER_AMOUNT) ORDER_AMOUNT,count(1) num1,ADD_TIME from factec_order where  ADD_TIME between  to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
 and order_state>10 
 --and order_from=76
  group by ADD_TIME
  ---
  
  select COUNT(DISTINCT(VID1)),SCAN_DATE_KEY from (
select * from 
(select VID,SCAN_DATE_KEY from  dim_vid_scan  where SCAN_DATE_KEY between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
and  (vid like '%android%'  or  vid like '%iphone%'))  aa left join 
(select VID VID1,VISIT_DATE_KEY FROM FACT_PAGE_VIEW WHERE VISIT_DATE_KEY between to_char(sysdate-7,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
AND PAGE_NAME='OrderConfirm'  GROUP BY  VID,VISIT_DATE_KEY
 ) bb on aa.VID=bb.VID1 and aa.SCAN_DATE_KEY=bb.VISIT_DATE_KEY)
 where  VID1 is not null  group by  SCAN_DATE_KEY
 
 
 -------浏览TOP10专题(新)
 select page_name,PAGE_VALUE,count(distinct(vid)) from (
 select * from 
 (select page_name,PAGE_VALUE,VID from fact_page_view where VISIT_DATE_KEY between 20170421 and 20170427
 and page_name in ('KFZT','ZT_Detail2','WZT2') AND  APPLICATION_KEY IN (10,20)) aa left join 
  (
 select distinct(vid)  VID1 from dim_vid_scan where SCAN_DATE_KEY between 20170421 and 20170427
and  SCAN_DATE_KEY=ACTIVE_DATE_KEY 
and  (vid like '%android%'  or  vid like '%iphone%')  ) bb on aa.VID=bb.VID1)
 where vid1 is not null
GROUP BY  page_name,PAGE_VALUE;
--------浏览TOP10专题(标签)
 select page_name,PAGE_VALUE,COUNT(DISTINCT(VID)) from fact_page_view where VISIT_DATE_KEY between 20170421 and 20170427  
  and page_name in ('KFZT','ZT_Detail2','WZT2') AND  APPLICATION_KEY IN (10,20)
 AND VID IN (
 select vid  from dim_vid_scan where SCAN_DATE_KEY BETWEEN 20170121 AND 20170427
and  (vid like '%android%'  or  vid like '%iphone%') )
GROUP BY  page_name,PAGE_VALUE;

-------浏览TOP10商品(新)
 select page_name,PAGE_VALUE,COUNT(DISTINCT(VID)) from fact_page_view where VISIT_DATE_KEY between 20170421 and 20170427
  and page_name='Good' AND  APPLICATION_KEY IN (10,20)
 AND VID IN (
 select vid  from dim_vvid_scan where SCAN_DATE_KEY  between 20170421 and 20170427
and  SCAN_DATE_KEY=ACTIVE_DATE_KEY 
and  (vid like '%android%'  or  vid like '%iphone%') )
GROUP BY  page_name,PAGE_VALUE;
--------浏览TOP10商品标签)
 select page_name,PAGE_VALUE,COUNT(DISTINCT(VID)) from fact_page_view where VISIT_DATE_KEY between 20170421 and 20170427 and 
 page_name='Good' AND  APPLICATION_KEY IN (10,20)
 AND VID IN (
 select vid  from dim_vid_scan where SCAN_DATE_KEY BETWEEN 20170121 AND 20170427
and  (vid like '%android%'  or  vid like '%iphone%') )
GROUP BY  page_name,PAGE_VALUE;


----
select sum(ORDER_AMOUNT),count(distinct(vid)),SCAN_DATE_KEY from (
select SCAN_DATE_KEY,bb.vid,ORDER_AMOUNT from (
select vid,SCAN_DATE_KEY from dim_vid_scan where  SCAN_DATE_KEY   between 20170311 and 20170501
and SCAN_DATE_KEY=ACTIVE_DATE_KEY
and( VID like '%android%'  or  vid like '%iphone%')    group by vid,SCAN_DATE_KEY
) aa left join (
select VID,add_time,sum(ORDER_AMOUNT)  ORDER_AMOUNT from factec_order where   add_time between 20170311 and 20170501
and  ORDER_STATE>10 and PAYMENT_CODE='online' 
 group by  VID,add_time) bb on aa.VID=bb.VID and aa.SCAN_DATE_KEY=bb.add_time
) where  vid is not null  group by SCAN_DATE_KEY


---

select count(distinct(vid)),START_DATE_KEY from fact_session where  APPLICATION_KEY In (10,20) and START_DATE_KEY between 20170311 and 20170501
and  vid in 
(

select vid from dim_vid_scan where  SCAN_DATE_KEY=START_DATE_KEY
and SCAN_DATE_KEY!=ACTIVE_DATE_KEY
and( VID like '%android%'  or  vid like '%iphone%')    
)
and MEMBER_KEY in (
select MEMBER_CRMBP from fact_ecmember where  MEMBER_TIME=START_DATE_KEY
) group by START_DATE_KEY


----
select MEMBER_BP,CREATE_DATE_KEY,END_ACTIVE_DATE_KEY from dim_member  where
   CREATE_DATE_KEY between 20170301 and 20170425
and  MEMBER_BP not in (
select MEMBER_KEY from factec_order where add_time between  20170301 and 20170503
and order_state>10
)
and  MEMBER_BP  in( select MEMBER_CRMBP from fact_ecmember where  MEMBER_TIME between 20170301 and 20170425 )
 
 select MEMBER_KEY from dim_ec_black_list where CREATE_TIME between  1488297600 and 1493049600
 
 
 
 select * from fact_page_view where visit_date_key between 20170322 and 20170322 
 and MEMBER_KEY=1611847059


---
 ----订购
select sum(ORDER_AMOUNT),count(distinct(vid)),SCAN_DATE_KEY from (
select SCAN_DATE_KEY,bb.vid,ORDER_AMOUNT from (
select vid,SCAN_DATE_KEY from dim_vid_scan where  SCAN_DATE_KEY   between 20170311 and 20170501
and SCAN_DATE_KEY!=ACTIVE_DATE_KEY
and ( VID like '%android%'  or  vid like '%iphone%')    group by vid,SCAN_DATE_KEY
) aa left join (
select VID,add_time,sum(ORDER_AMOUNT)  ORDER_AMOUNT  from factec_order where   add_time between 20170311 and 20170501
--and  ORDER_STATE>10 
--and PAYMENT_CODE='online' 
  group by  VID,add_time) bb on aa.VID=bb.VID and aa.SCAN_DATE_KEY=bb.add_time
) where  vid is not null  group by SCAN_DATE_KEY

 
