--1.1.dau
/*drop table yangjin.fact_page_view_2017;
create table yangjin.fact_page_view_2017 as
  select \*+parallel(16)*\
   d.visit_date_key date_key, d.vid, d.member_key, d.application_key
    from fact_page_view d
   where d.visit_date_key between 20170101 and 20171231;*/

--1.2.wx,app dau
create table yangjin.wxapp_dau_2017 as
select substr(i.date_key, 1, 6) month_key,
       i.is_new_user,
       i.channel_name,
       count(distinct i.vid) dau
  from (select e.date_key,
               e.vid,
               e.member_key,
               case
                 when nvl(f.first_order_date_key, 0) = 0 then
                  'new_user'
                 when f.first_order_date_key < e.date_key then
                  'old_user'
                 when f.first_order_date_key >= e.date_key then
                  'new_user'
               end is_new_user,
               case
                 when e.application_key in (10, 20) then
                  'APP'
                 when e.application_key = 30 then
                  '3G'
                 when e.application_key = 40 then
                  'PC'
                 when e.application_key = 50 then
                  '微信'
               end channel_name,
               case
                 when g.vid is null then
                  'non_scan'
                 else
                  'scan'
               end is_scan
          from yangjin.fact_page_view_2017 e,
               dim_member f,
               (select h.scan_date_key, h.vid
                  from dim_vid_scan h
                 where h.scan_date_key between 20170101 and 20171231) g
         where e.member_key = f.member_bp
           and e.date_key = g.scan_date_key(+)
           and e.vid = g.vid(+)
           and e.application_key in (10, 20, 50)) i
 where i.is_scan = 'scan'
 group by substr(i.date_key, 1, 6), i.is_new_user, i.channel_name
 order by substr(i.date_key, 1, 6), i.is_new_user, i.channel_name;

--1.2.all_dau
create table yangjin.nm_dau_2017 as
select substr(i.date_key, 1, 6) month_key,
       i.is_new_user,
       count(distinct i.vid) dau
  from (select e.date_key,
               e.vid,
               e.member_key,
               case
                 when nvl(f.first_order_date_key, 0) = 0 then
                  'new_user'
                 when f.first_order_date_key < e.date_key then
                  'old_user'
                 when f.first_order_date_key >= e.date_key then
                  'new_user'
               end is_new_user,
               case
                 when g.vid is null then
                  'non_scan'
                 else
                  'scan'
               end is_scan
          from yangjin.fact_page_view_2017 e,
               dim_member f,
               (select h.scan_date_key, h.vid
                  from dim_vid_scan h
                 where h.scan_date_key between 20170101 and 20171231) g
         where e.member_key = f.member_bp
           and e.date_key = g.scan_date_key(+)
           and e.vid = g.vid(+)
           and e.application_key in (10, 20, 50)) i
 where i.is_scan = 'scan'
 group by substr(i.date_key, 1, 6), i.is_new_user
 order by substr(i.date_key, 1, 6), i.is_new_user;

--2.1.app,wx ord
create table wxapp_ord_2017
select substr(a4.date_key, 1, 6) month_key,
       a4.is_new_user,
       a4.channel_name,
       count(distinct a4.member_key) order_member_count,
       sum(a4.order_amount) order_amount,
       sum(a4.goods_num) order_qty,
       count(a4.order_id) order_count
  from (select a2.add_time date_key,
               case
                 when a2.app_name = 'KLGMPortal' then
                  '3G'
                 when a2.app_name = 'KLGWX' then
                  '微信'
                 when a2.app_name in ('KLGAndroid', 'KLGiPhone') then
                  'APP'
                 when a2.app_name = 'KLGPortal' then
                  'PC'
               end channel_name,
               case
                 when nvl(a3.first_order_date_key, 0) = 0 then
                  'new_user'
                 when a3.first_order_date_key < a2.add_time then
                  'old_user'
                 when a3.first_order_date_key >= a2.add_time then
                  'new_user'
               end is_new_user,
               a2.order_id,
               a2.vid,
               a2.member_key,
               a2.goods_num,
               a2.order_amount
          from (select a1.order_id,
                       a1.add_time,
                       a1.vid,
                       a1.order_from,
                       a1.app_name,
                       a1.member_key,
                       a1.order_amount,
                       a1.goods_num
                  from factec_order a1
                 where a1.add_time between 20170101 and 20171231
                   and a1.order_state >= 20
                   and a1.order_from <> '76') a2,
               dim_member a3
         where a2.member_key = a3.member_bp(+)
           and a2.app_name in ('KLGAndroid', 'KLGiPhone', 'KLGWX')) a4
 group by substr(a4.date_key, 1, 6), a4.is_new_user, a4.channel_name;

--2.2.all_ord
create table yangjin.nm_ord_2017 as
select substr(a4.date_key, 1, 6) month_key,
       a4.is_new_user,
       count(distinct a4.member_key) order_member_count,
       sum(a4.order_amount) order_amount,
       sum(a4.goods_num) order_qty,
       count(a4.order_id) order_count
  from (select a2.add_time date_key,
               case
                 when nvl(a3.first_order_date_key, 0) = 0 then
                  'new_user'
                 when a3.first_order_date_key < a2.add_time then
                  'old_user'
                 when a3.first_order_date_key >= a2.add_time then
                  'new_user'
               end is_new_user,
               a2.order_id,
               a2.vid,
               a2.member_key,
               a2.goods_num,
               a2.order_amount
          from (select a1.order_id,
                       a1.add_time,
                       a1.vid,
                       a1.order_from,
                       a1.app_name,
                       a1.member_key,
                       a1.order_amount,
                       a1.goods_num
                  from factec_order a1
                 where a1.add_time between 20170101 and 20171231
                   and a1.order_state >= 20
                   and a1.order_from <> '76') a2,
               dim_member a3
         where a2.member_key = a3.member_bp(+)) a4
 group by substr(a4.date_key, 1, 6), a4.is_new_user;


--3.1
select dim.month_key,
       dim.is_new_user,
       dim.channel_name,
       a.dau,
       b.order_member_count,
       b.order_amount,
       b.order_qty
  from (select d1.month_key, d2.is_new_user, d3.channel_name
          from (select 201701 month_key
                  from dual
                union all
                select 201702 month_key
                  from dual
                union all
                select 201703 month_key
                  from dual
                union all
                select 201704 month_key
                  from dual
                union all
                select 201705 month_key
                  from dual
                union all
                select 201706 month_key
                  from dual
                union all
                select 201707 month_key
                  from dual
                union all
                select 201708 month_key
                  from dual
                union all
                select 201709 month_key
                  from dual
                union all
                select 201710 month_key
                  from dual
                union all
                select 201711 month_key
                  from dual
                union all
                select 201712 month_key
                  from dual) d1,
               (select 'new_user' is_new_user
                  from dual
                union all
                select 'old_user' is_new_user
                  from dual) d2,
               (select 'APP' channel_name
                  from dual
                union all
                select '微信' channel_name
                  from dual) d3) dim,
       yangjin.wxapp_dau_2017 a,
       yangjin.wxapp_ord_2017 b
 where dim.month_key = a.month_key(+)
   and dim.month_key = b.month_key(+)
   and dim.is_new_user = a.is_new_user(+)
   and dim.is_new_user = b.is_new_user(+)
   and dim.channel_name = a.channel_name(+)
   and dim.channel_name = b.channel_name(+);

--3.2
select dim.month_key,
       dim.is_new_user,
       dim.channel_name,
       a.dau,
       b.order_member_count,
       b.order_amount,
       b.order_qty
  from (select d1.month_key, d2.is_new_user, d3.channel_name
          from (select 201701 month_key
                  from dual
                union all
                select 201702 month_key
                  from dual
                union all
                select 201703 month_key
                  from dual
                union all
                select 201704 month_key
                  from dual
                union all
                select 201705 month_key
                  from dual
                union all
                select 201706 month_key
                  from dual
                union all
                select 201707 month_key
                  from dual
                union all
                select 201708 month_key
                  from dual
                union all
                select 201709 month_key
                  from dual
                union all
                select 201710 month_key
                  from dual
                union all
                select 201711 month_key
                  from dual
                union all
                select 201712 month_key
                  from dual) d1,
               (select 'new_user' is_new_user
                  from dual
                union all
                select 'old_user' is_new_user
                  from dual) d2,
               (select '新媒体' channel_name
                  from dual) d3) dim,
       yangjin.nm_dau_2017 a,
       yangjin.nm_ord_2017 b
 where dim.month_key = a.month_key(+)
   and dim.month_key = b.month_key(+)
   and dim.is_new_user = a.is_new_user(+)
   and dim.is_new_user = b.is_new_user(+);
