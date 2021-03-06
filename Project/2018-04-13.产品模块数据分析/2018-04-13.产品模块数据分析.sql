--********************************************************************************
--流量分析报表oper_traffic_analysis
--********************************************************************************
/*
新老客根据member_key判断，是否订购只看电商渠道
*/
--1.日活
select f.visit_date_key date_key,
       f.channel,
       'Dau' page_name,
       count(f.all_page_view_key) all_pv,
       count(distinct f.all_member_key) all_uv,
       round(avg(f.all_page_stay_time)) all_stay_time,
       count(f.new_page_view_key) new_pv,
       count(distinct f.new_member_key) new_uv,
       round(avg(f.new_page_stay_time)) new_stay_time,
       count(f.old_page_view_key) old_pv,
       count(distinct f.old_member_key) old_uv,
       round(avg(f.old_page_stay_time)) old_stay_time
  from (select e.visit_date_key,
               e.channel,
               e.page_view_key all_page_view_key,
               e.member_key all_member_key,
               e.page_stay_time all_page_stay_time,
               case
                 when is_new = 1 then
                  e.page_view_key
               end new_page_view_key,
               case
                 when is_new = 0 then
                  e.page_view_key
               end old_page_view_key,
               --
               case
                 when is_new = 1 then
                  e.member_key
               end new_member_key,
               case
                 when is_new = 0 then
                  e.member_key
               end old_member_key,
               --
               case
                 when is_new = 1 then
                  e.page_stay_time
               end new_page_stay_time,
               case
                 when is_new = 0 then
                  e.page_stay_time
               end old_page_stay_time
          from (select d.visit_date_key,
                       case
                         when d.application_key in (10, 20) then
                          'APP'
                         when d.application_key = 70 then
                          '小程序'
                       end channel,
                       d.page_view_key,
                       d.member_key,
                       d.page_staytime page_stay_time,
                       case
                         when to_date(d.visit_date_key, 'yyyymmdd') >
                              d.first_order_date then
                          0
                         when to_date(d.visit_date_key, 'yyyymmdd') <=
                              d.first_order_date then
                          1
                       end is_new /*是否新会员标志，1:新会员、0:老会员*/
                  from (select a.visit_date_key,
                               a.application_key,
                               a.page_view_key,
                               a.member_key,
                               a.page_staytime,
                               nvl(c.first_order_date, date '2000-01-01') first_order_date /*首单订购日期*/
                          from fact_page_view a,
                               (select b.cust_no member_key,
                                       trunc(min(b.add_time)) first_order_date
                                  from fact_ec_order_2 b
                                 group by b.cust_no) c
                         where a.member_key = c.member_key(+)
                           and a.visit_date_key = 20180412
                              /*APP、小程序*/
                           and a.application_key in (10, 20, 70)) d) e) f
 group by f.visit_date_key, f.channel;

--2.页面
select f.visit_date_key date_key,
       f.channel,
       f.page_name,
       count(f.all_page_view_key) all_pv,
       count(distinct f.all_member_key) all_uv,
       round(avg(f.all_page_stay_time)) all_stay_time,
       count(f.new_page_view_key) new_pv,
       count(distinct f.new_member_key) new_uv,
       round(avg(f.new_page_stay_time)) new_stay_time,
       count(f.old_page_view_key) old_pv,
       count(distinct f.old_member_key) old_uv,
       round(avg(f.old_page_stay_time)) old_stay_time
  from (select e.visit_date_key,
               e.channel,
               e.page_name,
               e.page_view_key all_page_view_key,
               e.member_key all_member_key,
               e.page_stay_time all_page_stay_time,
               case
                 when is_new = 1 then
                  e.page_view_key
               end new_page_view_key,
               case
                 when is_new = 0 then
                  e.page_view_key
               end old_page_view_key,
               --
               case
                 when is_new = 1 then
                  e.member_key
               end new_member_key,
               case
                 when is_new = 0 then
                  e.member_key
               end old_member_key,
               --
               case
                 when is_new = 1 then
                  e.page_stay_time
               end new_page_stay_time,
               case
                 when is_new = 0 then
                  e.page_stay_time
               end old_page_stay_time
          from (select d.visit_date_key,
                       case
                         when d.application_key in (10, 20) then
                          'APP'
                         when d.application_key = 70 then
                          '小程序'
                       end channel,
                       d.page_view_key,
                       d.member_key,
                       d.page_key,
                       d.page_name,
                       d.page_staytime page_stay_time,
                       case
                         when to_date(d.visit_date_key, 'yyyymmdd') >
                              d.first_order_date then
                          0
                         when to_date(d.visit_date_key, 'yyyymmdd') <=
                              d.first_order_date then
                          1
                       end is_new /*是否新会员标志，1:新会员、0:老会员*/
                  from (select a.visit_date_key,
                               a.application_key,
                               a.page_view_key,
                               a.member_key,
                               a.page_key,
                               a.page_name,
                               a.page_staytime,
                               nvl(c.first_order_date, date '2000-01-01') first_order_date /*首单订购日期*/
                          from fact_page_view a,
                               (select b.cust_no member_key,
                                       trunc(min(b.add_time)) first_order_date
                                  from fact_ec_order_2 b
                                 group by b.cust_no) c
                         where a.member_key = c.member_key(+)
                           and a.visit_date_key = 20180412
                           and a.application_key in (10, 20, 70)
                           and a.page_name in ('Home',
                                               'Home_TVLive',
                                               'TV_home',
                                               'Channel',
                                               'Good',
                                               'Search',
                                               'Member',
                                               'PayEnd')) d) e) f
 group by f.visit_date_key, f.channel, f.page_name;

--3.跳失
select f3.start_date_key date_key,
       f3.channel,
       g3.page_name,
       count(f3.member_key) all_bounce_uv,
       count(f3.new_member_key) new_bounce_uv,
       count(f3.old_member_key) old_bounce_uv
  from (select e3.start_date_key,
               e3.channel,
               e3.left_page_key,
               e3.member_key,
               case
                 when e3.is_new = 1 then
                  member_key
               end new_member_key,
               case
                 when e3.is_new = 0 then
                  member_key
               end old_member_key
          from (select d3.start_date_key,
                       case
                         when d3.application_key in (10, 20) then
                          'APP'
                         when d3.application_key = 70 then
                          '小程序'
                       end channel,
                       d3.member_key,
                       d3.left_page_key,
                       case
                         when to_date(d3.start_date_key, 'yyyymmdd') >
                              d3.first_order_date then
                          0
                         when to_date(d3.start_date_key, 'yyyymmdd') <=
                              d3.first_order_date then
                          1
                       end is_new /*是否新会员标志，1:新会员、0:老会员*/
                  from (select a3.start_date_key,
                               a3.member_key,
                               a3.application_key,
                               a3.left_page_key,
                               nvl(c3.first_order_date, date '2000-01-01') first_order_date /*首单订购日期*/
                          from fact_session a3,
                               (select b3.cust_no member_key,
                                       trunc(min(b3.add_time)) first_order_date
                                  from fact_ec_order_2 b3
                                 group by b3.cust_no) c3
                         where a3.member_key = c3.member_key(+)
                           and a3.start_date_key = 20180412
                           and a3.application_key in (10, 20, 70)) d3) e3) f3,
       dim_page g3
 where f3.left_page_key = g3.page_key
   and g3.page_name in ('Home',
                        'Home_TVLive',
                        'TV_home',
                        'Channel',
                        'Good',
                        'Search',
                        'Member',
                        'PayEnd')
 group by f3.start_date_key, f3.channel, g3.page_name;

--4.合并
create table oper_traffic_analysis as
  with dp as
   (select f.visit_date_key date_key,
           f.channel,
           'Dau' page_name,
           count(f.all_page_view_key) all_pv,
           count(distinct f.all_member_key) all_uv,
           round(avg(f.all_page_stay_time)) all_stay_time,
           count(f.new_page_view_key) new_pv,
           count(distinct f.new_member_key) new_uv,
           round(avg(f.new_page_stay_time)) new_stay_time,
           count(f.old_page_view_key) old_pv,
           count(distinct f.old_member_key) old_uv,
           round(avg(f.old_page_stay_time)) old_stay_time
      from (select e.visit_date_key,
                   e.channel,
                   e.page_view_key all_page_view_key,
                   e.member_key all_member_key,
                   e.page_stay_time all_page_stay_time,
                   case
                     when is_new = 1 then
                      e.page_view_key
                   end new_page_view_key,
                   case
                     when is_new = 0 then
                      e.page_view_key
                   end old_page_view_key,
                   --
                   case
                     when is_new = 1 then
                      e.member_key
                   end new_member_key,
                   case
                     when is_new = 0 then
                      e.member_key
                   end old_member_key,
                   --
                   case
                     when is_new = 1 then
                      e.page_stay_time
                   end new_page_stay_time,
                   case
                     when is_new = 0 then
                      e.page_stay_time
                   end old_page_stay_time
              from (select d.visit_date_key,
                           case
                             when d.application_key in (10, 20) then
                              'APP'
                             when d.application_key = 70 then
                              '小程序'
                           end channel,
                           d.page_view_key,
                           d.member_key,
                           d.page_staytime page_stay_time,
                           case
                             when to_date(d.visit_date_key, 'yyyymmdd') >
                                  d.first_order_date then
                              0
                             when to_date(d.visit_date_key, 'yyyymmdd') <=
                                  d.first_order_date then
                              1
                           end is_new /*是否新会员标志，1:新会员、0:老会员*/
                      from (select a.visit_date_key,
                                   a.application_key,
                                   a.page_view_key,
                                   a.member_key,
                                   a.page_staytime,
                                   nvl(c.first_order_date, date '2000-01-01') first_order_date /*首单订购日期*/
                              from fact_page_view a,
                                   (select b.cust_no member_key,
                                           trunc(min(b.add_time)) first_order_date
                                      from fact_ec_order_2 b
                                     group by b.cust_no) c
                             where a.member_key = c.member_key(+)
                               and a.visit_date_key = 20180412
                                  /*APP、小程序*/
                               and a.application_key in (10, 20, 70)) d) e) f
     group by f.visit_date_key, f.channel
    union all
    select f.visit_date_key date_key,
           f.channel,
           f.page_name,
           count(f.all_page_view_key) all_pv,
           count(distinct f.all_member_key) all_uv,
           round(avg(f.all_page_stay_time)) all_stay_time,
           count(f.new_page_view_key) new_pv,
           count(distinct f.new_member_key) new_uv,
           round(avg(f.new_page_stay_time)) new_stay_time,
           count(f.old_page_view_key) old_pv,
           count(distinct f.old_member_key) old_uv,
           round(avg(f.old_page_stay_time)) old_stay_time
      from (select e.visit_date_key,
                   e.channel,
                   e.page_name,
                   e.page_view_key all_page_view_key,
                   e.member_key all_member_key,
                   e.page_stay_time all_page_stay_time,
                   case
                     when is_new = 1 then
                      e.page_view_key
                   end new_page_view_key,
                   case
                     when is_new = 0 then
                      e.page_view_key
                   end old_page_view_key,
                   --
                   case
                     when is_new = 1 then
                      e.member_key
                   end new_member_key,
                   case
                     when is_new = 0 then
                      e.member_key
                   end old_member_key,
                   --
                   case
                     when is_new = 1 then
                      e.page_stay_time
                   end new_page_stay_time,
                   case
                     when is_new = 0 then
                      e.page_stay_time
                   end old_page_stay_time
              from (select d.visit_date_key,
                           case
                             when d.application_key in (10, 20) then
                              'APP'
                             when d.application_key = 70 then
                              '小程序'
                           end channel,
                           d.page_view_key,
                           d.member_key,
                           d.page_key,
                           d.page_name,
                           d.page_staytime page_stay_time,
                           case
                             when to_date(d.visit_date_key, 'yyyymmdd') >
                                  d.first_order_date then
                              0
                             when to_date(d.visit_date_key, 'yyyymmdd') <=
                                  d.first_order_date then
                              1
                           end is_new /*是否新会员标志，1:新会员、0:老会员*/
                      from (select a.visit_date_key,
                                   a.application_key,
                                   a.page_view_key,
                                   a.member_key,
                                   a.page_key,
                                   a.page_name,
                                   a.page_staytime,
                                   nvl(c.first_order_date, date '2000-01-01') first_order_date /*首单订购日期*/
                              from fact_page_view a,
                                   (select b.cust_no member_key,
                                           trunc(min(b.add_time)) first_order_date
                                      from fact_ec_order_2 b
                                     group by b.cust_no) c
                             where a.member_key = c.member_key(+)
                               and a.visit_date_key = 20180412
                               and a.application_key in (10, 20, 70)
                               and a.page_name in ('Home',
                                                   'Home_TVLive',
                                                   'TV_home',
                                                   'Channel',
                                                   'Good',
                                                   'Search',
                                                   'Member',
                                                   'PayEnd')) d) e) f
     group by f.visit_date_key, f.channel, f.page_name),
  buv as
   (select f3.start_date_key date_key,
           f3.channel,
           g3.page_name,
           count(f3.member_key) all_bounce_uv,
           count(f3.new_member_key) new_bounce_uv,
           count(f3.old_member_key) old_bounce_uv
      from (select e3.start_date_key,
                   e3.channel,
                   e3.left_page_key,
                   e3.member_key,
                   case
                     when e3.is_new = 1 then
                      member_key
                   end new_member_key,
                   case
                     when e3.is_new = 0 then
                      member_key
                   end old_member_key
              from (select d3.start_date_key,
                           case
                             when d3.application_key in (10, 20) then
                              'APP'
                             when d3.application_key = 70 then
                              '小程序'
                           end channel,
                           d3.member_key,
                           d3.left_page_key,
                           case
                             when to_date(d3.start_date_key, 'yyyymmdd') >
                                  d3.first_order_date then
                              0
                             when to_date(d3.start_date_key, 'yyyymmdd') <=
                                  d3.first_order_date then
                              1
                           end is_new /*是否新会员标志，1:新会员、0:老会员*/
                      from (select a3.start_date_key,
                                   a3.member_key,
                                   a3.application_key,
                                   a3.left_page_key,
                                   nvl(c3.first_order_date, date '2000-01-01') first_order_date /*首单订购日期*/
                              from fact_session a3,
                                   (select b3.cust_no member_key,
                                           trunc(min(b3.add_time)) first_order_date
                                      from fact_ec_order_2 b3
                                     group by b3.cust_no) c3
                             where a3.member_key = c3.member_key(+)
                               and a3.start_date_key = 20180412
                               and a3.application_key in (10, 20, 70)) d3) e3) f3,
           dim_page g3
     where f3.left_page_key = g3.page_key
       and g3.page_name in ('Home',
                            'Home_TVLive',
                            'TV_home',
                            'Channel',
                            'Good',
                            'Search',
                            'Member',
                            'PayEnd')
     group by f3.start_date_key, f3.channel, g3.page_name),
  dim as
   (select dim1.date_key, dim2.channel, dim3.page_name
      from (select to_char(date '2018-04-12', 'yyyymmdd') date_key from dual) dim1,
           (select 'APP' channel
              from dual
            union
            select '小程序' channel
              from dual) dim2,
           (select 'Dau' page_name
              from dual
            union
            select 'Home' page_name
              from dual
            union
            select 'Home_TVLive' page_name
              from dual
            union
            select 'TV_home' page_name
              from dual
            union
            select 'Channel' page_name
              from dual
            union
            select 'Good' page_name
              from dual
            union
            select 'Search' page_name
              from dual
            union
            select 'Member' page_name
              from dual
            union
            select 'PayEnd' page_name
              from dual) dim3)
  select dim.date_key,
         dim.channel,
         dim.page_name,
         nvl(dp.all_pv, 0) all_pv,
         nvl(dp.all_uv, 0) all_uv,
         nvl(dp.all_stay_time, 0) all_stay_time,
         nvl(buv.all_bounce_uv, 0) all_bounce_uv,
         nvl(dp.new_pv, 0) new_pv,
         nvl(dp.new_uv, 0) new_uv,
         nvl(dp.new_stay_time, 0) new_stay_time,
         nvl(buv.new_bounce_uv, 0) new_bounce_uv,
         nvl(dp.old_pv, 0) old_pv,
         nvl(dp.old_uv, 0) old_uv,
         nvl(dp.old_stay_time, 0) old_stay_time,
         nvl(buv.old_bounce_uv, 0) old_bounce_uv,
         sysdate w_insert_dt,
         sysdate w_update_dt
    from dim, dp, buv
   where dim.date_key = dp.date_key(+)
     and dim.channel = dp.channel(+)
     and dim.page_name = dp.page_name(+)
     and dim.date_key = buv.date_key(+)
     and dim.channel = buv.channel(+)
     and dim.page_name = buv.page_name(+);

--5.
/*CALL YANGJIN_PKG.OPER_TRAFFIC_ANALYSIS_PROC(20180413);
CALL YANGJIN_PKG.OPER_TRAFFIC_ANALYSIS_PROC(20180414);
CALL YANGJIN_PKG.OPER_TRAFFIC_ANALYSIS_PROC(20180415);
CALL YANGJIN_PKG.OPER_TRAFFIC_ANALYSIS_PROC(20180416);*/

--********************************************************************************
--点击分析报表oper_Click_analysis
--********************************************************************************
--1.total
INSERT INTO OPER_CLICK_ANALYSIS
  (A.DATE_KEY,
   A.CHANNEL,
   A.PAGE_NAME,
   A.PAGE_VALUE,
   A.ALL_PV,
   A.ALL_UV,
   A.NEW_PV,
   A.NEW_UV,
   A.OLD_PV,
   A.OLD_UV,
   A.W_INSERT_DT,
   A.W_UPDATE_DT)
  WITH DIM AS
   (SELECT DIM1.DATE_KEY, DIM2.CHANNEL, DIM3.PAGE_NAME
      FROM (SELECT TO_CHAR(DATE '2018-04-12', 'yyyymmdd') DATE_KEY FROM DUAL) DIM1,
           (SELECT 'APP' CHANNEL
              FROM DUAL
            UNION
            SELECT '小程序' CHANNEL
              FROM DUAL) DIM2,
           (SELECT 'SL_B2C_Article' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_B2C_Bigad' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_B2C_Dt' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_B2C_Floorad' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_B2C_Floorgoods' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_B2C_Homegood' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_B2C_Homegoods' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_B2C_Homegoodslike' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_B2C_Search' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Suppliergood' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Supplier' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Specifications' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Shoppcaring' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_share' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Recommend' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Promotion' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Order' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Evaluate' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Customer' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Coupons' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Collection' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Brandgood' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_Brand' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_BigPic' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_Good_ASK' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_Ygood' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_TVplay' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_TVlist2' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_TVlist1' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_Tvgoodremind' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_Tvgoodbuy' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_Tvgood' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_Middlead' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_brandAD' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_Bigad' PAGE_NAME
              FROM DUAL
            UNION
            SELECT 'SL_TV_Bgood' PAGE_NAME
              FROM DUAL) DIM3),
  CLK AS
   (SELECT F.VISIT_DATE_KEY DATE_KEY,
           F.CHANNEL,
           F.PAGE_NAME,
           COUNT(F.ALL_PAGE_VIEW_KEY) ALL_PV,
           COUNT(DISTINCT F.ALL_MEMBER_KEY) ALL_UV,
           ROUND(AVG(F.ALL_PAGE_STAY_TIME)) ALL_STAY_TIME,
           COUNT(F.NEW_PAGE_VIEW_KEY) NEW_PV,
           COUNT(DISTINCT F.NEW_MEMBER_KEY) NEW_UV,
           ROUND(AVG(F.NEW_PAGE_STAY_TIME)) NEW_STAY_TIME,
           COUNT(F.OLD_PAGE_VIEW_KEY) OLD_PV,
           COUNT(DISTINCT F.OLD_MEMBER_KEY) OLD_UV,
           ROUND(AVG(F.OLD_PAGE_STAY_TIME)) OLD_STAY_TIME
      FROM (SELECT E.VISIT_DATE_KEY,
                   E.CHANNEL,
                   E.PAGE_NAME,
                   E.PAGE_VIEW_KEY ALL_PAGE_VIEW_KEY,
                   E.MEMBER_KEY ALL_MEMBER_KEY,
                   E.PAGE_STAY_TIME ALL_PAGE_STAY_TIME,
                   CASE
                     WHEN IS_NEW = 1 THEN
                      E.PAGE_VIEW_KEY
                   END NEW_PAGE_VIEW_KEY,
                   CASE
                     WHEN IS_NEW = 0 THEN
                      E.PAGE_VIEW_KEY
                   END OLD_PAGE_VIEW_KEY,
                   --
                   CASE
                     WHEN IS_NEW = 1 THEN
                      E.MEMBER_KEY
                   END NEW_MEMBER_KEY,
                   CASE
                     WHEN IS_NEW = 0 THEN
                      E.MEMBER_KEY
                   END OLD_MEMBER_KEY,
                   --
                   CASE
                     WHEN IS_NEW = 1 THEN
                      E.PAGE_STAY_TIME
                   END NEW_PAGE_STAY_TIME,
                   CASE
                     WHEN IS_NEW = 0 THEN
                      E.PAGE_STAY_TIME
                   END OLD_PAGE_STAY_TIME
              FROM (SELECT D.VISIT_DATE_KEY,
                           CASE
                             WHEN D.APPLICATION_KEY IN (10, 20) THEN
                              'APP'
                             WHEN D.APPLICATION_KEY = 70 THEN
                              '小程序'
                           END CHANNEL,
                           D.PAGE_VIEW_KEY,
                           D.MEMBER_KEY,
                           D.PAGE_KEY,
                           D.PAGE_NAME,
                           D.PAGE_STAYTIME PAGE_STAY_TIME,
                           CASE
                             WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') >
                                  D.FIRST_ORDER_DATE THEN
                              0
                             WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') <=
                                  D.FIRST_ORDER_DATE THEN
                              1
                           END IS_NEW /*是否新会员标志，1:新会员、0:老会员*/
                      FROM (SELECT A.VISIT_DATE_KEY,
                                   A.APPLICATION_KEY,
                                   A.PAGE_VIEW_KEY,
                                   A.MEMBER_KEY,
                                   A.PAGE_KEY,
                                   A.PAGE_NAME,
                                   A.PAGE_STAYTIME,
                                   NVL(C.FIRST_ORDER_DATE, DATE '2000-01-01') FIRST_ORDER_DATE /*首单订购日期*/
                              FROM FACT_PAGE_VIEW_HIT A,
                                   (SELECT B.CUST_NO MEMBER_KEY,
                                           TRUNC(MIN(B.ADD_TIME)) FIRST_ORDER_DATE
                                      FROM FACT_EC_ORDER_2 B
                                     GROUP BY B.CUST_NO) C
                             WHERE A.MEMBER_KEY = C.MEMBER_KEY(+)
                               AND A.VISIT_DATE_KEY = 20180412
                               AND A.APPLICATION_KEY IN (10, 20, 70)
                               AND EXISTS
                             (SELECT 1
                                      FROM DIM
                                     WHERE DIM.PAGE_NAME = A.PAGE_NAME)) D) E) F
     GROUP BY F.VISIT_DATE_KEY, F.CHANNEL, F.PAGE_NAME)
  SELECT DIM.DATE_KEY,
         DIM.CHANNEL,
         DIM.PAGE_NAME,
         'Summary' PAGE_VALUE,
         NVL(CLK.ALL_PV, 0) ALL_PV,
         NVL(CLK.ALL_UV, 0) ALL_UV,
         NVL(CLK.NEW_PV, 0) NEW_PV,
         NVL(CLK.NEW_UV, 0) NEW_UV,
         NVL(CLK.OLD_PV, 0) OLD_PV,
         NVL(CLK.OLD_UV, 0) OLD_UV,
         SYSDATE W_INSERT_DT,
         SYSDATE W_UPDATE_DT
    FROM DIM, CLK
   WHERE DIM.DATE_KEY = CLK.DATE_KEY(+)
     AND DIM.CHANNEL = CLK.CHANNEL(+)
     AND DIM.PAGE_NAME = CLK.PAGE_NAME(+);

--2.page_value
SELECT F.VISIT_DATE_KEY DATE_KEY,
       F.CHANNEL,
       F.PAGE_NAME,
       F.PAGE_VALUE,
       COUNT(F.ALL_PAGE_VIEW_KEY) ALL_PV,
       COUNT(DISTINCT F.ALL_MEMBER_KEY) ALL_UV,
       COUNT(F.NEW_PAGE_VIEW_KEY) NEW_PV,
       COUNT(DISTINCT F.NEW_MEMBER_KEY) NEW_UV,
       COUNT(F.OLD_PAGE_VIEW_KEY) OLD_PV,
       COUNT(DISTINCT F.OLD_MEMBER_KEY) OLD_UV,
       SYSDATE W_INSERT_DT,
       SYSDATE W_UPDATE_DT
  FROM (SELECT E.VISIT_DATE_KEY,
               E.CHANNEL,
               E.PAGE_NAME,
               E.PAGE_VALUE,
               E.PAGE_VIEW_KEY ALL_PAGE_VIEW_KEY,
               E.MEMBER_KEY ALL_MEMBER_KEY,
               CASE
                 WHEN IS_NEW = 1 THEN
                  E.PAGE_VIEW_KEY
               END NEW_PAGE_VIEW_KEY,
               CASE
                 WHEN IS_NEW = 0 THEN
                  E.PAGE_VIEW_KEY
               END OLD_PAGE_VIEW_KEY,
               --
               CASE
                 WHEN IS_NEW = 1 THEN
                  E.MEMBER_KEY
               END NEW_MEMBER_KEY,
               CASE
                 WHEN IS_NEW = 0 THEN
                  E.MEMBER_KEY
               END OLD_MEMBER_KEY
          FROM (SELECT D.VISIT_DATE_KEY,
                       CASE
                         WHEN D.APPLICATION_KEY IN (10, 20) THEN
                          'APP'
                         WHEN D.APPLICATION_KEY = 70 THEN
                          '小程序'
                       END CHANNEL,
                       D.PAGE_VIEW_KEY,
                       D.MEMBER_KEY,
                       D.PAGE_KEY,
                       D.PAGE_NAME,
                       D.PAGE_VALUE,
                       CASE
                         WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') >
                              D.FIRST_ORDER_DATE THEN
                          0
                         WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') <=
                              D.FIRST_ORDER_DATE THEN
                          1
                       END IS_NEW /*是否新会员标志，1:新会员、0:老会员*/
                  FROM (SELECT A.VISIT_DATE_KEY,
                               A.APPLICATION_KEY,
                               A.PAGE_VIEW_KEY,
                               A.MEMBER_KEY,
                               A.PAGE_KEY,
                               A.PAGE_NAME,
                               A.PAGE_VALUE,
                               A.PAGE_STAYTIME,
                               NVL(C.FIRST_ORDER_DATE, DATE '2000-01-01') FIRST_ORDER_DATE /*首单订购日期*/
                          FROM FACT_PAGE_VIEW_HIT A,
                               (SELECT B.CUST_NO MEMBER_KEY,
                                       TRUNC(MIN(B.ADD_TIME)) FIRST_ORDER_DATE
                                  FROM FACT_EC_ORDER_2 B
                                 GROUP BY B.CUST_NO) C
                         WHERE A.MEMBER_KEY = C.MEMBER_KEY(+)
                           AND A.VISIT_DATE_KEY = 20180412
                           AND A.APPLICATION_KEY IN (10, 20, 70)
                           AND A.PAGE_NAME IN
                               ('SL_B2C_Bigicon', 'SL_B2C_ICON')) D) E) F
 GROUP BY F.VISIT_DATE_KEY, F.CHANNEL, F.PAGE_NAME, F.PAGE_VALUE;
--3.
CALL YANGJIN_PKG.OPER_CLICK_ANALYSIS_PROC(20180412);
CALL YANGJIN_PKG.OPER_CLICK_ANALYSIS_PROC(20180413);
CALL YANGJIN_PKG.OPER_CLICK_ANALYSIS_PROC(20180414);
CALL YANGJIN_PKG.OPER_CLICK_ANALYSIS_PROC(20180415);
CALL YANGJIN_PKG.OPER_CLICK_ANALYSIS_PROC(20180416);

--4.执行记录日志查询
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME IN
       ('YANGJIN_PKG.OPER_TRAFFIC_ANALYSIS_PROC',
        'YANGJIN_PKG.OPER_CLICK_ANALYSIS_PROC')
 ORDER BY A.START_TIME DESC;

--5.点击分析页面写DIM_PAGE
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页资讯模块'
 WHERE A.PAGE_NAME = 'SL_B2C_Article'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页资讯模块');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页大眼睛'
 WHERE A.PAGE_NAME = 'SL_B2C_Bigad'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页大眼睛');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页答题'
 WHERE A.PAGE_NAME = 'SL_B2C_Dt'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页答题');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页楼层广告'
 WHERE A.PAGE_NAME = 'SL_B2C_Floorad'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页楼层广告');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页楼层商品'
 WHERE A.PAGE_NAME = 'SL_B2C_Floorgoods'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页楼层商品');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页优选好物'
 WHERE A.PAGE_NAME = 'SL_B2C_Homegood'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页优选好物');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页优选好物'
 WHERE A.PAGE_NAME = 'SL_B2C_Homegoods'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页优选好物');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页找相似'
 WHERE A.PAGE_NAME = 'SL_B2C_Homegoodslike'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页找相似');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页搜索'
 WHERE A.PAGE_NAME = 'SL_B2C_Search'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页搜索');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '供应商商品'
 WHERE A.PAGE_NAME = 'SL_Good_Suppliergood'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '供应商商品');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '供应商商品'
 WHERE A.PAGE_NAME = 'SL_Good_Supplier'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '供应商商品');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品规格'
 WHERE A.PAGE_NAME = 'SL_Good_Specifications'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品规格');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '加购物车'
 WHERE A.PAGE_NAME = 'SL_Good_Shoppcaring'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '加购物车');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品分享'
 WHERE A.PAGE_NAME = 'SL_Good_share'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品分享');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '猜你喜欢'
 WHERE A.PAGE_NAME = 'SL_Good_Recommend'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '猜你喜欢');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品促销'
 WHERE A.PAGE_NAME = 'SL_Good_Promotion'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品促销');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '提交订单'
 WHERE A.PAGE_NAME = 'SL_Good_Order'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '提交订单');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品评价'
 WHERE A.PAGE_NAME = 'SL_Good_Evaluate'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品评价');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品客服'
 WHERE A.PAGE_NAME = 'SL_Good_Customer'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品客服');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品领券'
 WHERE A.PAGE_NAME = 'SL_Good_Coupons'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品领券');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品收藏'
 WHERE A.PAGE_NAME = 'SL_Good_Collection'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品收藏');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '品牌商品'
 WHERE A.PAGE_NAME = 'SL_Good_Brandgood'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '品牌商品');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '品牌点击'
 WHERE A.PAGE_NAME = 'SL_Good_Brand'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '品牌点击');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品大图'
 WHERE A.PAGE_NAME = 'SL_Good_BigPic'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品大图');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品问答'
 WHERE A.PAGE_NAME = 'SL_Good_ASK'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品问答');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '昨日热播'
 WHERE A.PAGE_NAME = 'SL_TV_Ygood'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '昨日热播');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = 'TV直播间'
 WHERE A.PAGE_NAME = 'SL_TV_TVplay'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> 'TV直播间');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = 'TV直播查看更多'
 WHERE A.PAGE_NAME = 'SL_TV_TVlist2'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> 'TV直播查看更多');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '节目表'
 WHERE A.PAGE_NAME = 'SL_TV_TVlist1'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '节目表');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '直播商品直播提醒'
 WHERE A.PAGE_NAME = 'SL_TV_Tvgoodremind'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '直播商品直播提醒');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '直播商品立即订购'
 WHERE A.PAGE_NAME = 'SL_TV_Tvgoodbuy'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '直播商品立即订购');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '直播商品点击'
 WHERE A.PAGE_NAME = 'SL_TV_Tvgood'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '直播商品点击');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '中间广告位'
 WHERE A.PAGE_NAME = 'SL_TV_Middlead'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '中间广告位');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '品牌推荐'
 WHERE A.PAGE_NAME = 'SL_TV_brandAD'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '品牌推荐');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '大眼睛'
 WHERE A.PAGE_NAME = 'SL_TV_Bigad'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '大眼睛');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '前日热播'
 WHERE A.PAGE_NAME = 'SL_TV_Bgood'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '前日热播');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页三区块'
 WHERE A.PAGE_NAME = 'SL_B2C_Bigicon'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页三区块');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页ICON'
 WHERE A.PAGE_NAME = 'SL_B2C_ICON'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页ICON');
COMMIT;

--5.1.流量分析页面写DIM_PAGE
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页'
 WHERE A.PAGE_NAME = 'Home'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '首页-TV直播'
 WHERE A.PAGE_NAME = 'Home_TVLive'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '首页-TV直播');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = 'TV直播页'
 WHERE A.PAGE_NAME = 'TV_home'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> 'TV直播页');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '频道页'
 WHERE A.PAGE_NAME = 'Channel'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '频道页');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '商品详情页'
 WHERE A.PAGE_NAME = 'Good'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '商品详情页');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '搜索页'
 WHERE A.PAGE_NAME = 'Search'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '搜索页');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '个人中心'
 WHERE A.PAGE_NAME = 'Member'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '个人中心');
COMMIT;
UPDATE DIM_PAGE A
   SET A.PAGE_CNM = '支付完成页'
 WHERE A.PAGE_NAME = 'PayEnd'
   AND (A.PAGE_CNM IS NULL OR A.PAGE_CNM <> '支付完成页');
COMMIT;

--6.

--tmp
SELECT * FROM DIM_PAGE A WHERE A.PAGE_NAME = 'SL_B2C_ICON';
SELECT * FROM FACT_PAGE_VIEW_HIT A WHERE A.PAGE_NAME = 'SL_B2C_ICON';
SELECT A.PAGE_NAME, A.PAGE_CNM, COUNT(1)
  FROM DIM_PAGE A
 GROUP BY A.PAGE_NAME, A.PAGE_CNM
 ORDER BY A.PAGE_NAME, A.PAGE_CNM;

SELECT * FROM DIM_PAGE A WHERE A.PAGE_NAME LIKE 'SL%';

SELECT 59 / 4000 FROM DUAL;
