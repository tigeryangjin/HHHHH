----小程序 
  (
  select count(distinct a.vid) 日活,count(distinct c.vid) 注册,count(distinct b.vid) 订购 ,sum(num1) from (
 select VID,visit_date_key from  fact_page_view where visit_date_key between 20180401 and   20180630
 and APPLICATION_KEY IN(70)
 and  vid not in(
 select vid from  dim_vid_scan where SCAN_DATE_KEY  between 20180401 and   20180630
 )
 and vid in ( select VID from fact_visitor_register where  CREATE_DATE_KEY  
 between  20180401 and   20180630  and APPLICATION_KEY  IN(50,70))
 
 group by VID,visit_date_key) a 
 left join 
 
 (select VID,START_DATE_KEY from 
 (select VID,MEMBER_KEY,START_DATE_KEY from   fact_session where  START_DATE_KEY between 20180401 and   20180630) 
 s join (select MEMBER_CRMBP,MEMBER_TIME from fact_ecmember where MEMBER_TIME between 
 20180401 and   20180630 ) ss  on s.MEMBER_KEY=ss.MEMBER_CRMBP AND S.START_DATE_KEY=SS.MEMBER_TIME 
  group by  VID,START_DATE_KEY) c  on 
 (a.vid=c.vid  and a.visit_date_key=c.START_DATE_KEY )
 left join 
 
 (select VID,add_time,sum(order_amount) num1
  from factec_order where add_time between 20180401 and   20180630 
  and order_state>10  
  and order_from !=76
  and   MEMBER_KEY in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME 
  between  20180401 and   20180630  )
  group by VID,add_time) b on   (a.vid=b.vid and a.visit_date_key=b.add_time  )  );
 
----微商城 
  (
  select count(distinct a.vid) 日活,count(distinct c.vid) 注册,count(distinct b.vid) 订购 ,sum(num1) from (
 select VID,visit_date_key from  fact_page_view where visit_date_key between 20180401 and   20180630
 and APPLICATION_KEY IN(50)
 and  vid not in(
 select vid from  dim_vid_scan where SCAN_DATE_KEY  between 20180401 and   20180630
 )
 and vid in ( select VID from fact_visitor_register where  CREATE_DATE_KEY  
 between  20180401 and   20180630  and APPLICATION_KEY  IN(50))
 
 group by VID,visit_date_key) a 
 left join 
 
 (select VID,START_DATE_KEY from 
 (select VID,MEMBER_KEY,START_DATE_KEY from   fact_session where  START_DATE_KEY between 20180401 and   20180630) 
 s join (select MEMBER_CRMBP,MEMBER_TIME from fact_ecmember where MEMBER_TIME between 
 20180401 and   20180630 ) ss  on s.MEMBER_KEY=ss.MEMBER_CRMBP AND S.START_DATE_KEY=SS.MEMBER_TIME 
  group by  VID,START_DATE_KEY) c  on 
 (a.vid=c.vid  and a.visit_date_key=c.START_DATE_KEY )
 left join 
 
 (select VID,add_time,sum(order_amount) num1
  from factec_order where add_time between 20180401 and   20180630 
  and order_state>10  
  and order_from !=76
  and   MEMBER_KEY in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME 
  between  20180401 and   20180630  )
  group by VID,add_time) b on   (a.vid=b.vid and a.visit_date_key=b.add_time  )  );
 
-----双屏互动 
  (
  select count(distinct IP) 日活,count(distinct c.vid) 注册,count(distinct b.vid) 订购  from (
 select VID,IP,visit_date_key from  fact_page_view where visit_date_key between 20180401 and   20180630
 and APPLICATION_KEY IN(30,50)
 and( url like '%SPHD%'  )
 and vid in ( select VID from fact_visitor_register where  CREATE_DATE_KEY  
 between  20180401 and   20180630  and APPLICATION_KEY  IN(30,50))
 
 group by VID,IP,visit_date_key) a 
 left join 
 
 (select VID,FIST_IP,START_DATE_KEY from 
 (select VID,FIST_IP,MEMBER_KEY,START_DATE_KEY from   fact_session where  START_DATE_KEY between 20180401 and   20180630) 
 s join (select MEMBER_CRMBP,MEMBER_TIME from fact_ecmember where MEMBER_TIME between 
 20180401 and   20180630 ) ss  on s.MEMBER_KEY=ss.MEMBER_CRMBP AND S.START_DATE_KEY=SS.MEMBER_TIME  group by  VID,FIST_IP,START_DATE_KEY) c  on 
 (a.ip=c.FIST_IP  and a.visit_date_key=c.START_DATE_KEY )
 left join 
 
 (select VID,ORDER_IP,add_time
  from factec_order where add_time between 20180401 and   20180630 
  and order_state>10  
  and   MEMBER_KEY in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME 
  between  20180401 and   20180630  )
  group by VID,ORDER_IP,add_time) b on   (a.ip=b.ORDER_IP and a.visit_date_key=b.add_time  )  );
 


 
 ----短信  按周
  (
  select count(distinct IP) 日活,count(distinct c.vid) 注册,count(distinct b.vid) 订购  from (
 select VID,IP,visit_date_key from  fact_page_view where visit_date_key between 20180401 and   20180630
 and APPLICATION_KEY=30
 and( url like '%DXTX%'  )
 and vid in ( select VID from fact_visitor_register where  CREATE_DATE_KEY  
 between  20180401 and   20180630  and APPLICATION_KEY=30)
 
 group by VID,IP,visit_date_key) a 
 left join 
 
 (select VID,FIST_IP,START_DATE_KEY from 
 (select VID,FIST_IP,MEMBER_KEY,START_DATE_KEY from   fact_session where  START_DATE_KEY between 20180401 and   20180630) 
 s join (select MEMBER_CRMBP,MEMBER_TIME from fact_ecmember where MEMBER_TIME between 
 20180401 and   20180630 ) ss  on s.MEMBER_KEY=ss.MEMBER_CRMBP AND S.START_DATE_KEY=SS.MEMBER_TIME  group by  VID,FIST_IP,START_DATE_KEY) c  on 
 (a.ip=c.FIST_IP  and a.visit_date_key=c.START_DATE_KEY )
 left join 
 
 (select VID,ORDER_IP,add_time
  from factec_order where add_time between 20180401 and   20180630 
  and order_state>10  
  and   MEMBER_KEY in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME 
  between  20180401 and   20180630  )
  group by VID,ORDER_IP,add_time) b on   (a.ip=b.ORDER_IP and a.visit_date_key=b.add_time  )  );
 



 --------扫码购
 select 
 (
 select COUNT(DISTINCT VID) num1 from  fact_page_view 
 where visit_date_key between  20180401 and   20180630 
 and page_name='TV_QRC'
 and  vid in ( select VID from fact_visitor_register where  CREATE_DATE_KEY  
 between  20180401 and   20180630  and APPLICATION_KEY=30) ) as 扫码人数,
 
 (select count(distinct MEMBER_KEY) from fact_session where START_DATE_KEY 
between  20180401 and   20180630 
and vid in 
(select VID from dim_vid_scan where  SCAN_DATE_KEY between  20180401
 and   20180630 )
 and MEMBER_KEY in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME 
  between  20180401 and   20180630  )) as 注册人数,
  
   (
  select count(distinct MEMBER_KEY) num2 from factec_order where add_time  between  20180401
 and   20180630 and order_state>10 and order_from=76 and  MEMBER_KEY in (select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME 
  between  20180401 and   20180630  )) as 订购人数 
 
 
 from dual;

 
 
