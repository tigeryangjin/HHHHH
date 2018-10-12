select count(1),nums,PAGE_NAME from(select count(1) as nums,PAGE_NAME,VID from (
 select  PAGE_NAME,VID,ss.visit_date_key  from fact_page_view  ss where ss.visit_date_key between 20161202 and 20161208 
 and ss.page_name in ('WZT2','Flash_sale','JFDB_Home','KFZT',
 'Search','HappigoSign','Channel','Home_TVLive','Hot_Good',
 'CouponList','Video_home','New_Good','ShoppingCart','Categorya','Home','ZT_Detail2','MemberRights_Home','TVPlayList') 
  and ss.application_key in(10,20) and ss.hmsc in (select HMSC from dim_hmsc where HMPL='非推广')
   group by  PAGE_NAME,VID,ss.visit_date_key) 
  group by  PAGE_NAME,VID  )  group by   nums,PAGE_NAME
  
  
  
  
  
  select  count(1),count(distinct(vid)) from  fact_page_view de where 
  de.visit_date_key between  20161118 and 20161124 
   and de.application_key in(10,20)  ;
   
  select  count(1),count(distinct(vid)) from  fact_page_view de where 
  de.visit_date_key between  20161125 and 20161201 
   and de.application_key in(10,20)  ; 
   
    select  count(1),count(distinct(vid)) from  fact_page_view de where 
  de.visit_date_key between  20161202 and 20161208 
   and de.application_key in(10,20)  ; 
   
-----会员 定   
   
select count(distinct(MEMBER_KEY)),CLV_TYPE,visit_date_key from 
(select MEMBER_KEY,VISIT_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE,CLV_TYPE from 
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161201 and 20161215
group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp ) 
 where CLV_TYPE is not null

group by CLV_TYPE,visit_date_key


----
select count(1),nums from (
select count(1) as nums,member_key  from( 
    select  member_key,visit_date_key from  fact_page_view de where 
  de.visit_date_key between  20161202 and 20161208 
   and de.application_key in(10,20) group by member_key,visit_date_key )   
   group by member_key)group by  nums
   
   
---扫码购

select * from fact_page_view sd where  sd.visit_date_key between 20161202 and 20161211 and sd.page_name=''


select count(distinct(vid)) from fact_page_view  where visit_date_key between 20161101 and 20161131
 and application_key=50
 
 
 select count(1) from fact_visitor_register where APPLICATION_KEY=30
 select max(STATDATE) from STATS_ONLINE_GOOD_MINUTE
 
 
 select count(1),count(distinct(vid)),visit_date_key from  fact_page_view dds where 
 dds.page_name='Mediate_ad' and dds.visit_date_key between 20160922 and 20161101
 group by visit_date_key
 
select LINK,TIMESTAMP from FACT_CMS_POSITION where TIMESTAMP>2016092211
 and key='app_home_ad' and TIMESTAMP<2016110111

select sum(GOODAMOUNT),CREATE_DATE_KEY from fact_daily_goodorder where CREATE_DATE_KEY>=20160922 and CREATE_DATE_KEY<20161101
and GOODNUM>0 and( PAGE_NAME='WZT2' or   PAGE_NAME ='Leave51' )group by CREATE_DATE_KEY


select distinct(MATDLT) from dim_good

select * from (

select GOODS_COMMON_KEY,sum(ORDER_AMOUNT)
 from   fact_goods_sales  where ORDER_DATE_KEY>=20160101
 
 group by GOODS_COMMON_KEY)
 
 
 select count(distinct(MEMBER_KEY)),count(1),VISIT_DATE_KEY from fact_page_view where
   VISIT_DATE_KEY between 20161214 and 20161220 
 and  APPLICATION_KEY=50 
 and  PAGE_NAME='OrderConfirm'    group by VISIT_DATE_KEY
 
 select * from fact_ec_order where add_time=20161219 and  ORDER_AMOUNT>6000
 
 
 select * from fact_page_view where VISIT_DATE_KEY=20161220 and page_name='appdownload'
 
 
 select count(distinct(vid)),count(distinct(MEMBER_KEY)) from factec_order where
  ADD_TIME>=20161201 group by ADD_TIME
  
  select * from fact_order

select count(distinct(MEMBER_KEY)) from factec_order where ADD_TIME between 20161202 and 20161207 and  MEMBER_KEY in (

select distinct(MEMBER_KEY) from oper_member_order_10_199  where  
 RECORD_DATE_KEY  between 20161201 and 20161206)
 
 
 
 
 
 
 
 
 
 
 select * from  
 (select REGISTER_RESOURCE,CLV_TYPE_W,FIRSTW_ORDER_DATE_KEY,MEMBER_BP
  from dim_member  where  LASTW_ORDER_DATE_KEY>20161100 
  group by   REGISTER_RESOURCE,CLV_TYPE_W,FIRSTW_ORDER_DATE_KEY,MEMBER_BP)
 a left join 
 (select MEMBER_KEY,sum(ORDER_AMOUNT),sum(ORDER_NUMS),count(1) 
 from fact_order where  ORDER_DATE_KEY>20161100  and SALES_SOURCE_KEY=20  and ORDER_STATE=1
 group by MEMBER_KEY) b on a.MEMBER_BP=b.MEMBER_KEY
 
 
 select * from fact_goods_sales  where GOODS_COMMON_KEY=206512
 
 
 select count(distinct(vid)),visit_date_key,count(1) from fact_page_view  ss  where  ss.visit_date_key between 20161213  and 20161226 and ss.page_name='Home_TVLive'
  group by visit_date_key
 
  select count(distinct(vid)),visit_date_key,count(1) from fact_page_view  ss  where  ss.visit_date_key  between 20161213  and 20161226   and ss.page_name='TVPlayList'
  group by visit_date_key
 
 select sum(ORDER_AMOUNT),count(1),ORDER_DATE_KEY from fact_order  where  SALES_SOURCE_KEY=10 and ORDER_DATE_KEY >20161200 and  ORDER_STATE=1 
 
 group by ORDER_DATE_KEY
 
 
 select * from fact_daily_wx where VISIT_DATE_KEY>20161200
 
 
 select  ZBPARTNER from ods_zbpartner1  where ZBPARTNER='1500181301'
 
 
 select * from factec_order where ADD_TIME between 20161201 and 20161231 and 
 
 
  MEMBER_KEY not in (select MEMBER_BP from dim_member)
  
  select distinct(MEMBER_KEY) from fact_session where START_DATE_KEY between 20161201 and 20161231and  MEMBER_KEY
  
  not in (select MEMBER_BP from dim_member)
  
  
  select sum(GOODS_AMOUNT) from factec_order  where ADD_TIME=20170103 and  vid in (
  select distinct(VID) from fact_page_view where APPLICATION_KEY=10  and VISIT_DATE_KEY=20170103
  and VER_NAME='6.8.8')  and order_state>0
  
  
  select SSID from  ls_test for update
  
  
  select * from fact_goods_sales    where ORDER_KEY in (  select SSID from  ls_test)  and ORDER_STATE=1 

  select c.matdlt,b.GOODS_COMMON_KEY,c.goods_name,a.SALES_AMOUNT,a.POINTS_AMOUNT,a.AMOUNT_PAID from fact_order a
  left join fact_goods_sales b on a.ORDER_KEY=b.ORDER_KEY
  left join dim_good c on  b.GOODS_COMMON_KEY=c.item_code
   where a.ORDER_KEY in (  select SSID from  ls_test)  and a.ORDER_STATE=1  
  
  select * from fact_goods_sales
  select ADD_TIME,VID,ADD_TIME_INT,ORDER_STATE,VTEXT1 from   Fact_Ec_Order a left join 
  dim_zone  b on  a.TRANSPZONE=b.ZONE1_4
  
   where ADD_TIME>20160601 and  ORDER_STATE>0  and ADD_TIME<systime
  
  select * from factec_order  
  
  
 select 
  to_date(ADD_TIME,'YYYY-MM-DD HH24:MI:ss')  时间,
  VID   编号,
  TO_DATE('19700101', 'yyyymmdd') + (ADD_TIME_INT) / 86400 +

        TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone), 1, 3)) / 24  时段,
  ORDER_STATE 订单状态,
  VTEXT1   省级,
  VTEXT2   市级 from   FactEc_Order a left join 
  dim_zone  b on  a.TRANSPZONE=b.ZONE1_4
   where ADD_TIME>20160601 and  ORDER_STATE>0

select TO_DATE('19700101', 'yyyymmdd') + (1422009505) / 86400 +

        TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone), 1, 3)) / 24 dtime

   from dual;
   
   SELECT systimestamp,
       Trunc(systimestamp, 'hh'),  --时
       Trunc(systimestamp, 'mi'),  --时分
       To_Date(To_Char(systimestamp, 'yyyy/mm/dd hh24:mi:ss'),
               'yyyy/mm/dd hh24:mi:ss')--时分秒
  from dual;
  
  
  select MEMBER_KEY,COUNT(DISTINCT(ITEM_CODE)) from FACT_MEMBER_EC_GOODS_SALES  GROUP BY MEMBER_KEY
  
  
  
    select * from 
    
    
    
    
    select count(distinct(vid)),count(1),VISIT_DATE_KEY from fact_page_view  where VISIT_DATE_KEY between 20161201 and 20161201 and
     PAGE_NAME='Good_Recommend'  group by VISIT_DATE_KEY
     
     
     
     select  count(1),count(distinct(vid)),sum(PAGE_STAYTIME) from fact_page_view  ssd
      where ssd.visit_date_key between 20161209   and 20161203
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.2','6.8.4') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
 
------

select * from STATS_ONLINE_GOOD2_MINUTE
    ------------
    
     select  count(1),count(distinct(vid)),ssd.page_name,ssd.visit_date_key from fact_page_view  ssd
      where ssd.visit_date_key  between 20170105 and 20170112
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.8','6.9.0') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
      
    group by ssd.page_name,ssd.visit_date_key
    
    ---------  6.8.8  求用户黏度
    SELECT SUM(exp(CHI)),page_name,SUM(exp(3))  FROM (
       SELECT COUNT(1) AS CHI,page_name,VID FROM (
         select  ssd.page_name,ssd.visit_date_key,VID from fact_page_view  ssd
      where ssd.visit_date_key  between 20170105 and 20170111
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.8','6.9.0') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
         group by ssd.page_name,ssd.visit_date_key,VID)
   
       GROUP BY page_name,VID)  GROUP BY page_name
      ---------  6.8.6  求用户黏度
    SELECT SUM(exp(CHI)),page_name,SUM(exp(3))  FROM (
       SELECT COUNT(1) AS CHI,page_name,VID FROM (
         select  ssd.page_name,ssd.visit_date_key,VID from fact_page_view  ssd
      where ssd.visit_date_key  between 20161224 and 20161230
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.6') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
         group by ssd.page_name,ssd.visit_date_key,VID)
   
       GROUP BY page_name,VID)  GROUP BY page_name
             ---------  6.8.2  求用户黏度
    SELECT SUM(exp(CHI)),page_name,SUM(exp(3))  FROM (
       SELECT COUNT(1) AS CHI,page_name,VID FROM (
         select  ssd.page_name,ssd.visit_date_key,VID from fact_page_view  ssd
      where ssd.visit_date_key  between 20161124 and 20161130
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.2','6.8.4') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
         group by ssd.page_name,ssd.visit_date_key,VID)
   
       GROUP BY page_name,VID)  GROUP BY page_name
       
       
       
    
    
    
    
    
    ---------------


          
     
     select  count(1),count(distinct(vid)),sum(PAGE_STAYTIME) from fact_page_view  ssd
      where ssd.visit_date_key  between 20170105 and 20170112
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.8','6.9.0') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
      
      
      
      
      --------------
      
      
           
     select  count(1),count(distinct(vid)),sum(PAGE_STAYTIME) from fact_page_view  ssd
      where ssd.visit_date_key between 20161222   and 20161222
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.6') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
-------
   select sum(LIFE_TIME)/count(distinct(vid)) ,START_DATE_KEY
   from fact_session  where  VER_NAME in ('6.8.2','6.8.4')   and   application_key  in(10,20) 
   and hmsc in('as','hw','klg','t360','oppo','wdj','xm') and START_DATE_KEY between 20161109 and 20161204
   group by START_DATE_KEY 
   
 -----
    select sum(LIFE_TIME)/count(distinct(vid)) ,START_DATE_KEY
   from fact_session  where  VER_NAME in ('6.8.6')   and   application_key  in(10,20) 
   and hmsc in('as','hw','klg','t360','oppo','wdj','xm') and START_DATE_KEY between 20161209 and 20170101
   group by START_DATE_KEY   
   
  -----  6.8.8 活跃时长
    select sum(LIFE_TIME)/count(distinct(vid)) ,START_DATE_KEY
   from fact_session  where  VER_NAME in ('6.8.8')   and   application_key  in(10,20) 
   and hmsc in('as','hw','klg','t360','oppo','wdj','xm') and START_DATE_KEY between 20170105 and 20170112
   group by START_DATE_KEY   
      
      
      select * from fact_page_view where  visit_date_key =20170101
     ------
     
      select count(distinct(ssd.vid)),count(distinct(ss.MEMBER_KEY)) from 
     (select distinct(VID)  as vid,SESSION_KEY from fact_page_view  ssd
      where ssd.visit_date_key between 20161114 and 20161123
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.2','6.8.4') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')  and ssd.page_name='Login')  ssd 
      left join fact_session  ss on  ssd.SESSION_KEY=ss.SESSION_KEY
      
      
      ------
       
      select count(distinct(ssd.vid)),count(distinct(ss.MEMBER_KEY)) from 
     (select distinct(VID)  as vid,SESSION_KEY from fact_page_view  ssd
      where ssd.visit_date_key between 20161214 and 20161223
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.6') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')  and ssd.page_name='Login')  ssd 
      left join fact_session  ss on  ssd.SESSION_KEY=ss.SESSION_KEY
      
      
      ---单页面的编号 
      
        select  count(1),count(distinct(vid)),ssd.page_name,ssd.visit_date_key from fact_page_view  ssd
      where ssd.visit_date_key  between 20170105 and 20170112
      and ssd.application_key  in(10,20) and VER_NAME in ('6.8.8','6.9.0')   and ssd.page_name='Good_videoplay'
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
      
    group by ssd.page_name,ssd.visit_date_key
    
    select * from (
    select PAGE_VALUE,count(1),count(distinct(vid)) from fact_page_view where 
     visit_date_key=20170112 and page_name='Good_videoplay'
     
     group by PAGE_VALUE
     ) a left join (
     
     select PAGE_VALUE,count(1),count(distinct(vid)) from  fact_page_view where 
     visit_date_key=20170112 and page_name='Good'   and
     
     PAGE_VALUE in  ( select distinct(PAGE_VALUE) from fact_page_view where 
     visit_date_key=20170112 and page_name='Good_videoplay')
     group by PAGE_VALUE)b  on a.PAGE_VALUE=b.PAGE_VALUE
