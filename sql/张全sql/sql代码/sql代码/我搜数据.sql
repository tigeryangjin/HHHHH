select * from 

-----�ܶ���
(select ADD_TIME as dtime,sum(ORDER_AMOUNT) as �ܶ������,count(1)  as �ܶ������� ,
count(distinct(s.MEMBER_KEY)) as �ܶ������� from (
    select *
     from factec_order    
    where  ADD_TIME  between 20161001 and 20161031 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20161001 and 20161031
     and HMSC='wosou1') 
     
     ) s  group by  ADD_TIME)a  left join 
-----������
(select ADD_TIME as dtime,sum(ORDER_AMOUNT) as ���������,count(1)  as ������������ ,
count(distinct(s.MEMBER_KEY)) as �������������� from (
    select *
     from factec_order    
    where  ADD_TIME  between 20161001 and 20161031 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20161001 and 20161031
     and HMSC='wosou1')  and  CRM_ORDER_NO is not null
     
     ) s  group by  ADD_TIME) b  on a.dtime=b.dtime left join 
     
-----��Ч����
(select ADD_TIME  as dtime,sum(ORDER_AMOUNT) as ��Ч�������,count(1)  as ��Ч�������� ,
count(distinct(s.MEMBER_KEY)) as ��Ч�������� from (
    select *
     from factec_order    
    where  ADD_TIME  between 20161001 and 20161031 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20161001 and 20161031
     and HMSC='wosou1')  and ORDER_STATE>0     
     ) s  group by  ADD_TIME )c  on a.dtime=c.dtime  left join 
 -----���˶���    
 (select ADD_TIME as dtime,sum(ORDER_AMOUNT) as ���˽��,count(1)  as ���˵��� ,
count(distinct(s.MEMBER_KEY)) as �������� from (
    select *
     from factec_order    
    where  ADD_TIME  between 20161001 and 20161031 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20161001 and 20161031
     and HMSC='wosou1')   
     ) s  where  ORDER_STATE=0 and     CANCEL_BEFORE_STATE=0
      group by  ADD_TIME ) d on a.dtime=d.dtime

-----������

select * from       
-----�ܶ���
(select ADD_TIME as dtime,sum(ORDER_AMOUNT) as �ܶ������,count(1)  as �ܶ������� ,
count(distinct(s.MEMBER_KEY)) as �ܶ������� from (
    select *
     from factec_order    
    where  ADD_TIME  between  20160901 and 20161131 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between 20160901 and 20161131
     and HMSC='idvertys3') 
     
     ) s  group by  ADD_TIME)a  left join 
-----������
(select ADD_TIME as dtime,sum(ORDER_AMOUNT) as ���������,count(1)  as ������������ ,
count(distinct(s.MEMBER_KEY)) as �������������� from (
    select *
     from factec_order    
    where  ADD_TIME  between  20160901 and 20161131 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between  20160901 and 20161131
     and HMSC='idvertys3')  and  CRM_ORDER_NO is not null
     
     ) s  group by  ADD_TIME) b  on a.dtime=b.dtime left join 
     
-----��Ч����
(select ADD_TIME  as dtime,sum(ORDER_AMOUNT) as ��Ч�������,count(1)  as ��Ч�������� ,
count(distinct(s.MEMBER_KEY)) as ��Ч�������� from (
    select *
     from factec_order    
    where  ADD_TIME  between  20160901 and 20161131 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between  20160901 and 20161131
     and HMSC='idvertys3')  and ORDER_STATE>0     
     ) s  group by  ADD_TIME )c  on a.dtime=c.dtime  left join 
 -----���˶���    
 (select ADD_TIME as dtime,sum(ORDER_AMOUNT) as ���˽��,count(1)  as ���˵��� ,
count(distinct(s.MEMBER_KEY)) as �������� from (
    select *
     from factec_order    
    where  ADD_TIME  between  20160901 and 20161131 and 
     vid in  (select distinct(vid) from fact_visitor_register  where 
     application_key=20 and  CREATE_DATE_KEY between  20160901 and 20161131
     and HMSC='idvertys3')   
     ) s  where  ORDER_STATE=0 and     CANCEL_BEFORE_STATE=0
      group by  ADD_TIME ) d on a.dtime=d.dtime

  
