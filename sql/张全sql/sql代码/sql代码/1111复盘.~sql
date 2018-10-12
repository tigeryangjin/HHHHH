---视频购订购用户画像
select  s.member_bp,s.member_age,s.member_agenda,s.register_resource,s.valid_orderamount  from dim_member s where  
MEMBER_BP in (select distinct(MEMBER_KEY) from fact_page_view a where  ( a.visit_date_key between 20161110 and 20161112  or a.visit_date_key between 20161019 and 20161021)
 and (a.page_name='Video_home' or a.page_name='Video_live'))  
and  MEMBER_BP in(select distinct(MEMBER_KEY) from factec_order  where   ( add_time between 20161110 and 20161112  or add_time between 20161019 and 20161021)and ORDER_STATE>0 )
and  MEMBER_BP in
(
 select  distinct(MEMBER_KEY) from fact_page_view  a where ( a.visit_date_key between 20161110 and 20161112  or a.visit_date_key between 20161019 and 20161021)
 and a.page_name='Good'  AND (IP_GEO_KEY IN(39130,39157,39129,39113,39151,39115,39152,39188,39150,39120) 
 OR LAST_PAGE_KEY  IN  (39130,39157,39129,39113,39151,39115,39152,39188,39150,39120) ))
 
----39130   39157  39129  39113  39151  39115 39152  39188  39150  39120



-----

select count(distinct(MEMBER_KEY)),CLV_TYPE,visit_date_key from 
(select MEMBER_KEY,VISIT_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE,CLV_TYPE from 
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161101 and 20161101
 and (a.page_name='Video_home' or a.page_name='Video_live' or a.page_name='Video_replay')
group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp ) 
 where CLV_TYPE is not null

group by CLV_TYPE,visit_date_key


----视频购 访问用户画像

select  s.member_bp,s.member_age,s.member_agenda,s.register_resource,s.valid_orderamount  from dim_member s where  
MEMBER_BP in (select distinct(MEMBER_KEY) from fact_page_view a where  a.visit_date_key between 20161110 and 20161112 
 and (a.page_name='Video_home' or a.page_name='Video_live')) 
 
 
 select count(1),count(distinct(vid)),visit_date_key from fact_page_view  a  where visit_date_key between 20161110 and 20161112 
 and (a.page_name='Video_home' or a.page_name='Video_live' or a.page_name='Video_replay')
 group by visit_date_key
 
 
 -----20101020
 select count(1),count(distinct(vid)),visit_date_key from fact_page_view  a  where visit_date_key between 20161019 and 20161021 
 and (a.page_name='Video_home' or a.page_name='Video_live' or a.page_name='Video_replay')
 group by visit_date_key
 
 --20161111
 
 select count(1),count(distinct(vid)),visit_date_key from fact_page_view  a  where visit_date_key between 20161110 and 20161112 
 and (a.page_name='Video_home' or a.page_name='Video_live' or a.page_name='Video_replay')
 group by visit_date_key
 
 
 -----
 select count(1),cn from (
  select count(distinct(visit_date_key)) as cn,vid from fact_page_view  a  where visit_date_key between 20161105 and 20161111 
 and (a.page_name='Video_home' or a.page_name='Video_live' or a.page_name='Video_replay')
 group by vid
 ) group by cn
----

  ----注册数据
  ---新用户注册
  select count(1) from fact_ecmember where MEMBER_CRMBP in (
  select MEMBER_KEY from fact_session  where   START_DATE_KEY=20161111  and vid in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161111 and APPLICATION_KEY in (10,20)
 ) )and  MEMBER_TIME =20161111 
 
  ---老非用户注册
  select count(1) from fact_ecmember where MEMBER_CRMBP in (
  select MEMBER_KEY from fact_session  where   START_DATE_KEY=20161111   and   APPLICATION_KEY in (10,20) 
  
   and MEMBER_KEY!=0) and 
  MEMBER_TIME =20161111
 
  
  
  
  
 ---新用户加购物车
  select  count(distinct(vid)) from  fact_shoppingcar  where CREATE_DATE_KEY=20161111 and vid in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161111 and APPLICATION_KEY in (10,20)
  )
   ---老用户加购物车
  select  count(distinct(vid)) from  fact_shoppingcar  where CREATE_DATE_KEY=20161111 and vid in (
   select vid from fact_session  where   START_DATE_KEY=20161111   and   APPLICATION_KEY in (10,20) 
 )
  
  ---总订购人数
  ---新用户总订购
  select count(distinct(vid)) from  factec_order where ADD_TIME=20161111 and vid  in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161111 and APPLICATION_KEY in (10,20)
 ) 
  ---新用户有效订购
   select count(distinct(vid)),sum(ORDER_AMOUNT) from  factec_order where ADD_TIME=20161111 and vid  in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161111 and APPLICATION_KEY in (10,20)
 )  and ORDER_STATE>0 
  



  

      ---老非用户总订购
  select count(distinct(vid)) from  factec_order where ADD_TIME=20161111 and  vid in (
   select vid from fact_session  where   START_DATE_KEY=20161111   and   APPLICATION_KEY in (10,20) 
  )  ;
  ---老非用户有效订购
   select count(distinct(vid)),sum(ORDER_AMOUNT) from  factec_order where ADD_TIME=20161111 and  vid in (
   select vid from fact_session  where   START_DATE_KEY=20161111   and   APPLICATION_KEY in (10,20) 
)   and ORDER_STATE>0 ;
  ----
 ----1111 各个节点转化情况
  ---日活
 select  sum(uv)/count(visit_date_key) from (
  select count(distinct(vid)) as uv ,visit_date_key from fact_page_view  sa where 
  sa.visit_date_key  between 20161101 and 20161107 and sa.application_key in (10,20)
group by visit_date_key );
  ----
  
  select count(distinct(vid)) as uv from fact_visitor_register where CREATE_DATE_KEY=20161111
  
  ---商品详情页
  
  select  sum(uv)/count(visit_date_key) from (
  select count(distinct(vid)) as uv,visit_date_key from fact_page_view  sa where 
   sa.visit_date_key   between 20161101 and 20161107 and sa.application_key in (10,20)
  and sa.page_name='Good'
 group by visit_date_key );
  
  ---订单提交页
  
   select  sum(uv)/count(visit_date_key) from (
  select count(distinct(vid)) as uv,visit_date_key from fact_page_view  sa where 
  sa.visit_date_key   between 20161101 and 20161107  and sa.application_key in (10,20)
  and sa.page_name='OrderConfirm' group by visit_date_key );
  ---总订购人数 
  select  sum(uv)/count(ADD_TIME) from (
  select count(distinct(vid)) as uv,ADD_TIME
  from factec_order where ADD_TIME   between 20161101 and 20161107 and   ORDER_FROM in(63,61)
  group by ADD_TIME ) ;
  
  ----有效订购人数
  select  sum(uv)/count(ADD_TIME) from (
  select count(distinct(vid)) as uv,ADD_TIME
   from factec_order where ADD_TIME between 20161101 and 20161107  and   ORDER_FROM in(63,61) and ORDER_STATE>0   
   and ORDER_AMOUNT>9
   
   group by ADD_TIME );
