----- 纯下载APP
----- 7月~8月  扫码人数 (新)

select * from (
select count(distinct(vid)) num1 ,visit_date_key from fact_page_view where visit_date_key between 20160701 and 20160815
and  APPLICATION_KEY=30
and page_name='Tvdownload'
group by  visit_date_key) a 
left join (
SELECT count(distinct(vid)),CREATE_DATE_KEY FROM (
SELECT SS.VID AS VID,SSS.VID AS VID2,CREATE_DATE_KEY FROM 
(select VID,visit_date_key from  fact_page_view s
 where visit_date_key between 20160701 and 20160815
and page_name='Tvdownload'
GROUP BY VID,visit_date_key) SS
LEFT JOIN 
(select VID,CREATE_DATE_KEY from fact_visitor_register where  APPLICATION_KEY=30 and
  CREATE_DATE_KEY between 20160701 and 20160815
  GROUP BY VID,CREATE_DATE_KEY )SSS ON SS.VID=SSS.VID AND  SS.visit_date_key=SSS.CREATE_DATE_KEY 
  ) WHERE VID2 IS NOT NULL 
group by CREATE_DATE_KEY) b on a.visit_date_key=b.CREATE_DATE_KEY


----  7月~8月  扫码人数 (新) 订购
truncate table ls_07010815
select count(distinct(vid)) from ls_07010815
insert into ls_07010815 (vid,VISIT_DATE_KEY)

select vid,VISIT_DATE_KEY from (
SELECT VID,VISIT_DATE_KEY,PAGEEND_TIME,CREATE_DATE from (
select VISIT_DATE_KEY,IP,PAGEEND_TIME,(
case
   when AGENT like '%iPhone%' then 'IOS'
   when AGENT like '%iPad%' then 'IOS'
   when AGENT like '%Android%' then 'Android'
     ELSE ''
       end 
) OS  from fact_page_view where visit_date_key between 20160701 and 20160815
and  APPLICATION_KEY=30
and page_name='Tvdownload'
--and vid in (select VID from fact_visitor_register where APPLICATION_KEY=30 and CREATE_DATE_KEY=visit_date_key  )
----新用户
group by VISIT_DATE_KEY,IP,PAGEEND_TIME,(
case
   when AGENT like '%iPhone%' then 'IOS'
   when AGENT like '%iPad%' then 'IOS'
   when AGENT like '%Android%' then 'Android'
     ELSE ''
       end 
)
) aa left join (
select VID,FIRST_IP,OS,CREATE_DATE_KEY,CREATE_DATE from fact_visitor_register where
  CREATE_DATE_KEY between 20160701 and 20160815
and  APPLICATION_KEY in (10,20,50)) bb on aa.VISIT_DATE_KEY=bb.CREATE_DATE_KEY and aa.os=bb.os and aa.ip=bb.FIRST_IP
)
where  vid is not null 

----- 7月~8月  扫码人数 (所有)
create table ls_07010815z 
( 
vid varchar(100) default '', 
VISIT_DATE_KEY varchar(20) default ''  ）

select distinct(VID) from ls_07010815z
truncate table   ls_07010815z

insert into ls_07010815z (vid,VISIT_DATE_KEY)

select vid,VISIT_DATE_KEY from (
SELECT VID,VISIT_DATE_KEY,PAGEEND_TIME,START_DATE_KEY,START_TIME from (
select VISIT_DATE_KEY,IP,PAGEEND_TIME,(
case
   when AGENT like '%iPhone%' then 'IOS'
   when AGENT like '%iPad%' then 'IOS'
   when AGENT like '%Android%' then 'Android'
     ELSE ''
       end 
) OS  from fact_page_view where visit_date_key between 20160701 and 20160815
and  APPLICATION_KEY=30
and page_name='Tvdownload'
group by VISIT_DATE_KEY,IP,PAGEEND_TIME,(
case
   when AGENT like '%iPhone%' then 'IOS'
   when AGENT like '%iPad%' then 'IOS'
   when AGENT like '%Android%' then 'Android'
     ELSE ''
       end 
)
) aa left join (
select VID,FIST_IP, (
case
   when AGENT like '%iPhone%' then 'IOS'
   when AGENT like '%iPad%' then 'IOS'
   when AGENT like '%Android%' then 'Android'
     ELSE ''
       end 
) OS,START_DATE_KEY,START_TIME    from fact_session where
  START_DATE_KEY between 20160701 and 20160815
and  APPLICATION_KEY in (10,20,50)
group by 
 VID,FIST_IP, (
case
   when AGENT like '%iPhone%' then 'IOS'
   when AGENT like '%iPad%' then 'IOS'
   when AGENT like '%Android%' then 'Android'
     ELSE ''
       end 
) ,START_DATE_KEY,START_TIME

) bb on aa.VISIT_DATE_KEY=bb.START_DATE_KEY and aa.os=bb.os and aa.ip=bb.FIST_IP
)
where  vid is not null 
-------
select count(distinct(vid)),VISIT_DATE_KEY from ls_07010815
group by VISIT_DATE_KEY

---
select ADD_TIME,count(distinct(VID)),sum(PAY_AMOUNT) from (
select bbb.vid,VISIT_DATE_KEY,ADD_TIME,ORDER_STATE,PAY_AMOUNT from (
select vid,ADD_TIME,ORDER_STATE,PAY_AMOUNT from factec_order  where ADD_TIME between  20160701 and 20160815 
and order_state>0
and  MEMBER_key in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME= add_time )
)
aaa left join ( 
select VID,VISIT_DATE_KEY from  ls_07010815z) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by bbb.vid,VISIT_DATE_KEY,ADD_TIME,ORDER_STATE,PAY_AMOUNT
) where visit_date_key is not null  group by  ADD_TIME
----
select count(distinct(vid)),VISIT_DATE_KEY from  ls_07010815z
group by  VISIT_DATE_KEY


select sum(PAY_AMOUNT),ADD_TIME  from factec_order where  ADD_TIME between  20160701 and 20160815 
and order_state>10 
group by ADD_TIME



------------------

select sum(ORDER_AMOUNT),ORDER_DATE_KEY from (
select aaaa.MEMBER_KEY,ORDER_DATE_KEY,ORDER_KEY,ORDER_AMOUNT,VISIT_DATE_KEY from ( 
select MEMBER_KEY,ORDER_DATE_KEY,ORDER_KEY,sum(ORDER_AMOUNT)  ORDER_AMOUNT from fact_goods_sales where  SALES_SOURCE_KEY=20 and   ORDER_DATE_KEY  between  20160701 and 20160815 
and  ORDER_STATE=1 and TRAN_TYPE=0  and (LIVE_STATE=1 or REPLAY_STATE=1)

group by MEMBER_KEY,ORDER_DATE_KEY,ORDER_KEY
)aaaa  left join 

(select member_key,visit_date_key from (
select member_key,visit_date_key from (
select vid,ADD_TIME,ORDER_STATE,ORDER_AMOUNT,member_key from factec_order  where ADD_TIME between  20160701 and 20160815 
and order_state>0
)
aaa left join ( 
select VID,VISIT_DATE_KEY from  ls_07010815z) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by member_key,visit_date_key 
) where visit_date_key is not null)  bbbb on aaaa.MEMBER_KEY=bbbb.MEMBER_KEY 
 and  aaaa.ORDER_DATE_KEY=bbbb.visit_date_key
 
 ) where VISIT_DATE_KEY is not null 
 
 group by ORDER_DATE_KEY

--- 30天留存

select count(distinct(MEMBER_KEY)) from (
select aa.MEMBER_KEY,ADD_TIME,START_DATE_KEY from 
 (
select distinct(member_key) member_key,to_date(visit_date_key) add_time  from (
select member_key,visit_date_key from (
select vid,ADD_TIME,ORDER_STATE,PAY_AMOUNT,member_key from factec_order  where ADD_TIME between  20160701 and 20160815 
and order_state>0
)
aaa left join ( 
select VID,VISIT_DATE_KEY from  ls_07010815z) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by member_key,visit_date_key 
) where visit_date_key is not null 
    ) aa left join ( 
 select MEMBER_KEY,to_date(START_DATE_KEY)  START_DATE_KEY from fact_session where  START_DATE_KEY between 20161001 and 20161115 
group by  MEMBER_KEY,START_DATE_KEY)bb on aa.MEMBER_KEY=bb.MEMBER_KEY and add_time+90<START_DATE_KEY
) where START_DATE_KEY is not null 


----- 订购次数
select sum(nums),count(distinct(MEMBER_KEY)),sum(AMOUNT) from (
select aa.MEMBER_KEY MEMBER_KEY ,bb.add_time add_time ,nums,AMOUNT from (
select distinct(member_key) member_key,to_date(visit_date_key) add_time  from (
select member_key,visit_date_key from ( 
select vid,ADD_TIME,ORDER_STATE,PAY_AMOUNT,member_key from factec_order  where ADD_TIME between  20160701 and 20160815 
and order_state>0 and  
)
aaa left join ( 
select VID,VISIT_DATE_KEY from  ls_07010815) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by member_key,visit_date_key 
) where visit_date_key is not null 
    )  aa left join ( 
 select MEMBER_KEY,to_date(add_time) add_time,count(1) nums,sum(order_AMOUNT)  AMOUNT from  factec_order  where add_time  between 20160701 and 20160931 
 and   order_state>10
 and   APP_NAME in ('KLGAndroid','KLGWX','KLGiPhone')
 group by  MEMBER_KEY,add_time
 
 )bb on aa.MEMBER_KEY=bb.MEMBER_KEY and bb.add_time between aa.add_time and aa.add_time+30
) 




---访问时长\停留时长
select count(distinct(START_DATE_KEY)),sum(LIFE_TIME),MEMBER_KEY from(
select aa.MEMBER_KEY,START_DATE_KEY,mtime,LIFE_TIME from (
select MEMBER_KEY,to_date(START_DATE_KEY)  START_DATE_KEY,sum(LIFE_TIME) LIFE_TIME from fact_session where  MEMBER_KEY!=0 and 
 START_DATE_KEY  between   20160701 and 20160931 
 group by MEMBER_KEY,START_DATE_KEY
 ) aa  left join (
select distinct(member_key) member_key,to_date( min(visit_date_key)) mtime  from (
select member_key,visit_date_key from (
select vid,ADD_TIME,ORDER_STATE,PAY_AMOUNT,member_key from factec_order  where ADD_TIME between  20160701 and 20160815 
and order_state>0
)
aaa left join ( 
select VID,VISIT_DATE_KEY from  ls_07010815z) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by member_key,visit_date_key 
)  where visit_date_key is not null  group by member_key
    ) 

 bb on aa.MEMBER_KEY=bb.MEMBER_KEY and aa.START_DATE_KEY between mtime and mtime+30
) where mtime is not null
group by MEMBER_KEY

--

----- 
----- 订购次数
select sum(nums),count(distinct(MEMBER_KEY)),sum(AMOUNT) from (
select aa.MEMBER_KEY MEMBER_KEY ,bb.add_time add_time ,nums,AMOUNT from (
select distinct(member_key) member_key,to_date(visit_date_key) add_time  from (
select member_key,visit_date_key from ( 
select vid,ADD_TIME,ORDER_STATE,PAY_AMOUNT,member_key from factec_order  
where ADD_TIME between  20160701 and 20160815 
and order_state>0   
)
aaa left join ( 
select VID,VISIT_DATE_KEY from  ls_07010815z) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by member_key,visit_date_key 
) where visit_date_key is not null 
    )  aa left join ( 
 select MEMBER_KEY,to_date(add_time) add_time,count(1) nums,sum(order_AMOUNT)  AMOUNT from 
  factec_order  where add_time  between 20160701 and 20161231 
 and   order_state>10
 and   APP_NAME in ('KLGAndroid','KLGWX','KLGiPhone')
 group by  MEMBER_KEY,add_time
 
 )bb on aa.MEMBER_KEY=bb.MEMBER_KEY and bb.add_time between aa.add_time and aa.add_time+90
) 
----------------
select count(1) from  dim_member where  app_LAST_DATE_KEY>0 ---and     wx_LAST_DATE_KEY>0
 and   MEMBER_BP in (
select MEMBER_KEY from  fact_session where
  START_DATE_KEY    between  20160701 and 20160815  
  and APPLICATION_KEY IN(10,20,50)   and
  
 vid in (
select VID from ls_07010815z  group by VID ) group by MEMBER_KEY )

 count(distinct(MEMBER_KEY))
