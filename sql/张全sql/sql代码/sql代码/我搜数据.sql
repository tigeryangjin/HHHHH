select * from 

-----总订购
(select ADD_TIME as dtime,sum(ORDER_AMOUNT) as 总订购金额,count(1)  as 总订购单数 ,
count(distinct(s.MEMBER_KEY)) as 总订购人数 from (
    select *
     from factec_order    
    where  ADD_TIME  between 20161001 and 20161031 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20161001 and 20161031
     and HMSC='wosou1') 
     
     ) s  group by  ADD_TIME)a  left join 
-----净订购
(select ADD_TIME as dtime,sum(ORDER_AMOUNT) as 净订购金额,count(1)  as 净订购订单数 ,
count(distinct(s.MEMBER_KEY)) as 净订购订购人数 from (
    select *
     from factec_order    
    where  ADD_TIME  between 20161001 and 20161031 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20161001 and 20161031
     and HMSC='wosou1')  and  CRM_ORDER_NO is not null
     
     ) s  group by  ADD_TIME) b  on a.dtime=b.dtime left join 
     
-----有效订购
(select ADD_TIME  as dtime,sum(ORDER_AMOUNT) as 有效订购金额,count(1)  as 有效订购单数 ,
count(distinct(s.MEMBER_KEY)) as 有效订购人数 from (
    select *
     from factec_order    
    where  ADD_TIME  between 20161001 and 20161031 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20161001 and 20161031
     and HMSC='wosou1')  and ORDER_STATE>0     
     ) s  group by  ADD_TIME )c  on a.dtime=c.dtime  left join 
 -----拒退订购    
 (select ADD_TIME as dtime,sum(ORDER_AMOUNT) as 拒退金额,count(1)  as 拒退单数 ,
count(distinct(s.MEMBER_KEY)) as 拒退人数 from (
    select *
     from factec_order    
    where  ADD_TIME  between 20161001 and 20161031 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20161001 and 20161031
     and HMSC='wosou1')   
     ) s  where  ORDER_STATE=0 and     CANCEL_BEFORE_STATE=0
      group by  ADD_TIME ) d on a.dtime=d.dtime

-----艾瓦特

select * from       
-----总订购
(select ADD_TIME as dtime,sum(ORDER_AMOUNT) as 总订购金额,count(1)  as 总订购单数 ,
count(distinct(s.MEMBER_KEY)) as 总订购人数 from (
    select *
     from factec_order    
    where  ADD_TIME  between  20160901 and 20161131 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20160901 and 20161131
     and HMSC='idvertys3') 
     
     ) s  group by  ADD_TIME)a  left join 
-----净订购
(select ADD_TIME as dtime,sum(ORDER_AMOUNT) as 净订购金额,count(1)  as 净订购订单数 ,
count(distinct(s.MEMBER_KEY)) as 净订购订购人数 from (
    select *
     from factec_order    
    where  ADD_TIME  between  20160901 and 20161131 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between  20160901 and 20161131
     and HMSC='idvertys3')  and  CRM_ORDER_NO is not null
     
     ) s  group by  ADD_TIME) b  on a.dtime=b.dtime left join 
     
-----有效订购
(select ADD_TIME  as dtime,sum(ORDER_AMOUNT) as 有效订购金额,count(1)  as 有效订购单数 ,
count(distinct(s.MEMBER_KEY)) as 有效订购人数 from (
    select *
     from factec_order    
    where  ADD_TIME  between  20160901 and 20161131 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between  20160901 and 20161131
     and HMSC='idvertys3')  and ORDER_STATE>0     
     ) s  group by  ADD_TIME )c  on a.dtime=c.dtime  left join 
 -----拒退订购    
 (select ADD_TIME as dtime,sum(ORDER_AMOUNT) as 拒退金额,count(1)  as 拒退单数 ,
count(distinct(s.MEMBER_KEY)) as 拒退人数 from (
    select *
     from factec_order    
    where  ADD_TIME  between  20160901 and 20161131 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between  20160901 and 20161131
     and HMSC='idvertys3')   
     ) s  where  ORDER_STATE=0 and     CANCEL_BEFORE_STATE=0
      group by  ADD_TIME ) d on a.dtime=d.dtime

  
