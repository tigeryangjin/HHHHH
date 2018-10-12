----- 3月~4月  扫码人数 (新\老)
select * from (
select count(distinct(vid)) num1 ,visit_date_key from fact_page_view where visit_date_key between 20170414 and 20170420
and  APPLICATION_KEY=30
and page_name='TV_QRC'
group by  visit_date_key) a 
left join (
SELECT count(distinct(vid)),CREATE_DATE_KEY FROM (
SELECT SS.VID AS VID,SSS.VID AS VID2,CREATE_DATE_KEY FROM 
(select VID,visit_date_key from  fact_page_view s
 where visit_date_key  between 20170414 and 20170420
and page_name='TV_QRC'
GROUP BY VID,visit_date_key) SS
LEFT JOIN 
(select VID,CREATE_DATE_KEY from fact_visitor_register where  APPLICATION_KEY=30 and
  CREATE_DATE_KEY between 20170414 and 20170420
  GROUP BY VID,CREATE_DATE_KEY )SSS ON SS.VID=SSS.VID AND  SS.visit_date_key=SSS.CREATE_DATE_KEY 
  ) WHERE VID2 IS NOT NULL 
group by CREATE_DATE_KEY) b on a.visit_date_key=b.CREATE_DATE_KEY

----  3月~4月  扫码人数 (新) 订购
create table ls_03110418 
( 
vid varchar(100) default '', 
VISIT_DATE_KEY varchar(20) default ''  )

truncate table  ls_03110418  group by VISIT_DATE_KEY

insert into ls_03110418  (vid,VISIT_DATE_KEY)

select vid,VISIT_DATE_KEY from (
SELECT VID,VISIT_DATE_KEY,PAGEEND_TIME,CREATE_DATE from (
select VISIT_DATE_KEY,IP,PAGEEND_TIME,(
case
   when AGENT like '%iPhone%' then 'IOS'
   when AGENT like '%iPad%' then 'IOS'
   when AGENT like '%Android%' then 'Android'
     ELSE ''
       end 
) OS  from fact_page_view where visit_date_key between 20170311 and 20170318
and  APPLICATION_KEY=30
and page_name='TV_QRC'
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
  CREATE_DATE_KEY between 20170311 and 20170318
and  APPLICATION_KEY in (10,20)) bb on aa.VISIT_DATE_KEY=bb.CREATE_DATE_KEY and aa.os=bb.os and aa.ip=bb.FIRST_IP
)
where  vid is not null 
----- 3月~4月  扫码人数 (所有)

create table ls_03110418z 
( 
vid varchar(100) default '', 
VISIT_DATE_KEY varchar(20) default ''  )

truncate table   ls_03110418z group by VISIT_DATE_KEY

insert into ls_03110418z (vid,VISIT_DATE_KEY)

select vid,VISIT_DATE_KEY from (
SELECT VID,VISIT_DATE_KEY,PAGEEND_TIME,START_DATE_KEY,START_TIME from (
select VISIT_DATE_KEY,IP,PAGEEND_TIME,(
case
   when AGENT like '%iPhone%' then 'IOS'
   when AGENT like '%iPad%' then 'IOS'
   when AGENT like '%Android%' then 'Android'
     ELSE ''
       end 
) OS  from fact_page_view where visit_date_key between 20170311 and 20170420
and  APPLICATION_KEY=30
and page_name='TV_QRC'
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
  START_DATE_KEY between 20170311 and 20170420
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

------微信订购
select count(distinct(vid)),count(1),ADD_TIME,sum(PAY_AMOUNT) from factec_order where 
add_time  between 20170311 and 20170431 
and order_from=76
and  order_state>10
---and  MEMBER_key in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME= add_time )
 group by ADD_TIME
-----订购APP

select ADD_TIME,count(distinct(VID)),count(1),sum(PAY_AMOUNT) from (
select bbb.vid,VISIT_DATE_KEY,ADD_TIME,ORDER_STATE,PAY_AMOUNT from (
select vid,ADD_TIME,ORDER_STATE,PAY_AMOUNT from factec_order  where ADD_TIME between  20170311 and 20170420 
and order_state>0
--and  MEMBER_key in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME= add_time )
)
aaa left join ( 
select VID,VISIT_DATE_KEY from  ls_03110418z  ) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by bbb.vid,VISIT_DATE_KEY,ADD_TIME,ORDER_STATE,PAY_AMOUNT
) where visit_date_key is not null  group by  ADD_TIME


-------订购人


select MEMBER_KEY,min(mtime) mtime from ls_03110418r where  mtime<=20170319
group by MEMBER_KEY   


--- 30天留存

select count(distinct(MEMBER_KEY)) from (
select aa.MEMBER_KEY,ADD_TIME,START_DATE_KEY from (
select MEMBER_KEY,to_date(min(mtime)) add_time from ls_03110418r where  mtime<=20170319
group by MEMBER_KEY  ) aa left join ( 
 select MEMBER_KEY,to_date(START_DATE_KEY)  START_DATE_KEY from fact_session where  START_DATE_KEY between 20170311 and 20170431 
group by  MEMBER_KEY,START_DATE_KEY)bb on aa.MEMBER_KEY=bb.MEMBER_KEY and add_time+30<START_DATE_KEY
) where START_DATE_KEY is not null 


----- 订购次数
select sum(nums)/count(distinct(MEMBER_KEY)) from (
select aa.MEMBER_KEY MEMBER_KEY ,bb.add_time add_time ,nums from (
select MEMBER_KEY,to_date(min(mtime)) add_time from ls_03110418r where  mtime<=20170319
group by MEMBER_KEY  )  aa left join ( 
 select MEMBER_KEY,to_date(add_time) add_time,count(1) nums from  factec_order  where add_time between 20170311 and 20170431 
 and   order_state>10
 group by  MEMBER_KEY,add_time
 
 )bb on aa.MEMBER_KEY=bb.MEMBER_KEY and bb.add_time between aa.add_time and aa.add_time+30
) 




---访问时长\停留时长
select count(distinct(START_DATE_KEY)),sum(LIFE_TIME),MEMBER_KEY from(
select aa.MEMBER_KEY,START_DATE_KEY,mtime,LIFE_TIME from (
select MEMBER_KEY,to_date(START_DATE_KEY)  START_DATE_KEY,sum(LIFE_TIME) LIFE_TIME from fact_session where  MEMBER_KEY!=0 and 
 START_DATE_KEY    between 20170311 and 20170431 
 group by MEMBER_KEY,START_DATE_KEY
 ) aa  left join (
select MEMBER_KEY,to_date(min(mtime)) mtime from ls_03110418r where  mtime<=20170319
group by MEMBER_KEY  ) 

 bb on aa.MEMBER_KEY=bb.MEMBER_KEY and aa.START_DATE_KEY between mtime and mtime+30
) where mtime is not null
group by MEMBER_KEY





----- 订购次数
select sum(nums),count(distinct(MEMBER_KEY)),sum(AMOUNT) from (
select aa.MEMBER_KEY MEMBER_KEY ,bb.add_time add_time ,nums,AMOUNT from (
select distinct(member_key) member_key,to_date(visit_date_key) add_time  from (
select member_key,visit_date_key from (
select vid,ADD_TIME,ORDER_STATE,PAY_AMOUNT,member_key from factec_order  where ADD_TIME  between 20170311 and 20170431 
and order_state>0
)
aaa left join ( 
select VID,VISIT_DATE_KEY  from ls_03110418 where VISIT_DATE_KEY<=20170318 ) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by member_key,visit_date_key 
) where visit_date_key is not null 
    )  aa left join ( 
 select MEMBER_KEY,to_date(add_time) add_time,count(1) nums,sum(order_AMOUNT)  AMOUNT from  factec_order  where add_time   between 20170311 and 20170431  
 and   order_state>10
 and   APP_NAME in ('KLGAndroid','KLGWX','KLGiPhone')
 group by  MEMBER_KEY,add_time
 
 )bb on aa.MEMBER_KEY=bb.MEMBER_KEY and bb.add_time between aa.add_time and aa.add_time+30
) 




--------TV播出商品

select count(distinct(vid)),count(1),ADD_TIME,sum(PAY_AMOUNT) from factec_order where 
add_time  between 20170311 and 20170431 
--and order_from=76
and  order_state>10
and CRM_ORDER_NO in (

select ORDER_H_KEY from (
select aaaa.MEMBER_KEY,ORDER_DATE_KEY,ORDER_H_KEY,ORDER_AMOUNT,VISIT_DATE_KEY from ( 
select MEMBER_KEY,ORDER_DATE_KEY,ORDER_H_KEY,sum(ORDER_AMOUNT)  ORDER_AMOUNT from fact_goods_sales where 
 SALES_SOURCE_KEY=20 and   ORDER_DATE_KEY  between  20170311 and 20170420 
and  ORDER_STATE>0  and(LIVE_STATE=1 or REPLAY_STATE=1

or GOODS_COMMON_KEY in (select  ITEM_CODE from dim_tv_good where to_char(TV_START_TIME,'yyyymmdd')=ORDER_DATE_KEY )
 
)

select count(distinct(MEMBER_KEY)) from factec_order where 
add_time  between 20161111 and 20161231  
and order_from=76
and  order_state>10

group by MEMBER_KEY,ORDER_DATE_KEY,ORDER_H_KEY
)aaaa  left join 

(select member_key,visit_date_key from (
select member_key,visit_date_key from (
select vid,ADD_TIME,ORDER_STATE,ORDER_AMOUNT,member_key from factec_order  where 
ADD_TIME between  20170311 and 20170420
and order_state>0
)
aaa left join ( 
select VID,VISIT_DATE_KEY from  ls_03110418z) bbb on aaa.vid=bbb.vid and aaa.add_time=bbb.visit_date_key 
group by member_key,visit_date_key 
) where visit_date_key is not null)  bbbb on aaaa.MEMBER_KEY=bbbb.MEMBER_KEY 
 and  aaaa.ORDER_DATE_KEY=bbbb.visit_date_key
 
 ) where VISIT_DATE_KEY is not null 
 
 group by ORDER_H_KEY

)
group by ADD_TIME
-----------
select count(distinct(vid)),count(1),ADD_TIME,sum(PAY_AMOUNT) from factec_order where 
add_time  between 20170311 and 20170431 
and order_from=76
and  order_state>10
---and  MEMBER_key in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME= add_time )
and CRM_ORDER_NO in (
 
select ORDER_H_KEY from 
( 
select MEMBER_KEY,ORDER_DATE_KEY,ORDER_H_KEY,sum(ORDER_AMOUNT)  ORDER_AMOUNT  from fact_goods_sales where  SALES_SOURCE_KEY=20
 and   ORDER_DATE_KEY  between    20170311 and 20170420
and  ORDER_STATE>0 and TRAN_TYPE=0  and (LIVE_STATE=1 or REPLAY_STATE=1

or GOODS_COMMON_KEY in (select  ITEM_CODE from dim_tv_good where to_char(TV_START_TIME,'yyyymmdd')=ORDER_DATE_KEY )
)
and  ORDER_H_KEY in (select CRM_ORDER_NO from factec_order where ADD_TIME   
between   20170311 and 20170420  and order_from=76 and order_state>10)
group by MEMBER_KEY,ORDER_DATE_KEY,ORDER_KEY,ORDER_H_KEY
)
group by ORDER_H_KEY
)
group by ADD_TIME


-----------------
select count(1) from (
select MEMBER_KEY,count(distinct(APPLICATION_KEY)) nums from  fact_session where
  START_DATE_KEY  between   20170311 and 20170420 
 and APPLICATION_KEY IN(10,20,50)
 and   MEMBER_KEY in (
select MEMBER_KEY from  fact_session where
  START_DATE_KEY  between   20170311 and 20170420  and
 vid in (
select VID from ls_03110418z  group by VID ) )

group by MEMBER_KEY) where nums>=2


----------------

select count(1) from  dim_member where       wx_LAST_DATE_KEY>0
 and   MEMBER_BP in (
select count(distinct(MEMBER_KEY)) from  fact_session where
  START_DATE_KEY    between 20170311 and 20170420     and
 vid in (
select VID from ls_03110418z  group by VID ) )


--


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

