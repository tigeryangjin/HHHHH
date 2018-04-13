/*
新老客根据member_key判断，是否订购只看电商渠道
*/
--1.日活
select f.visit_date_key,
       f.channel,
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
select f.visit_date_key,
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
select a3.start_date_key,
       a3.member_key,
       a3.application_key,
       a3.left_page_key
  from fact_session a3
 where a3.start_date_key = 20180412
   and a3.application_key in (10, 20, 70);

--tmp
select * from select * from DIM_PAGE a where lower(a.page_name) = 'good';


select *
  from all_col_comments a
 where lower(a.COLUMN_NAME) like '%page_key%'
 order by 1, 2, 3;
/*
Home
Home_TVLive
TV_home
Channel
Good
Search
Member
PayEnd
*/
select a.page_key, a.page_name, count(1)
  from fact_page_view a
 where a.visit_date_key = 20180412
   and a.page_key in (6404, 6966, 38628, 47536)
 group by a.page_key, a.page_name;
select *
  from fact_page_view a
 where a.visit_date_key = 20180412
   and a.page_key = 38628;
select distinct a.page_key, a.page_name
  from fact_page_view a
 where a.visit_date_key = 20180412
   and lower(a.page_name) in ('home',
                              'home_tvlive',
                              'tv_home',
                              'channel',
                              'good',
                              'search',
                              'member',
                              'payend')
 order by 2, 1;
select *
  from fact_session a
 where a.start_date_key = 20180413
   and a.vid = 'iphone92c235f6aa6cb6e8ba5e0770b79a931508e8e9ec'
 order by a.start_time;
select *
  from fact_page_view a
 where a.visit_date_key = 20180413
   and a.vid = 'iphone92c235f6aa6cb6e8ba5e0770b79a931508e8e9ec'
 order by a.visit_date;
select *
  from fact_session a
 where a.start_date_key = 20180413
   and a.start_page_key <> a.left_page_key;
select a.session_key, count(1)
  from fact_page_view a
 where a.visit_date_key = 20180413
 group by a.session_key
 order by count(1) desc;
select *
  from fact_page_view a
 where a.session_key = 101974290
 order by a.visit_date;
select *
  from fact_session a
 where a.session_key = 101974290
 order by a.start_date_key;
