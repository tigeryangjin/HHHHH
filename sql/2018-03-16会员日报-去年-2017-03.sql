/*
���Ͽ͡�ɨ���û���VISIT_DATE��ͨ·ҵ����ࡢ�ջ����������������������������������
dim_member��fact_page_view��dim_vid_scan��factec_order
3G
΢��
APP
PC
*/
--1.����
select l.date_key,
       l.is_new_user,
       l.is_scan,
       l.channel_name,
       count(distinct l.member_key) order_member_count,
       sum(l.order_amount) order_amount,
       sum(l.goods_num) order_qty,
       count(l.order_id) order_count
  from (select b.add_time date_key,
               case
                 when b.order_from = '76' then
                  'scan'
                 else
                  'non_scan'
               end is_scan,
               case
                 when b.app_name = 'KLGMPortal' then
                  '3G'
                 when b.app_name = 'KLGWX' then
                  '΢��'
                 when b.app_name in ('KLGAndroid', 'KLGiPhone') then
                  'APP'
                 when b.app_name = 'KLGPortal' then
                  'PC'
               end channel_name,
               case
                 when c.firstw_order_date_key = b.add_time then
                  'new_user'
                 else
                  'old_user'
               end is_new_user,
               b.order_id,
               b.vid,
               b.member_key,
               b.goods_num,
               b.order_amount
          from (select a.order_id,
                       a.add_time,
                       a.vid,
                       a.order_from,
                       a.app_name,
                       a.member_key,
                       a.order_amount,
                       a.goods_num
                  from factec_order a
                 where a.add_time between 20170301 and 20170331
                   and a.order_state >= 20) b,
               dim_member c
         where b.member_key = c.member_bp) l
 group by l.date_key, l.is_new_user, l.is_scan, l.channel_name
 order by l.date_key, l.is_new_user, l.is_scan, l.channel_name;

--2.��Ϊ
--2.1
/*drop table fact_page_view_201703;
create table fact_page_view_201703 as
  select d.visit_date_key date_key,
         d.vid,
         d.member_key,
         case
           when d.application_key = 30 then
            '3G'
           when d.application_key = 50 then
            '΢��'
           when d.application_key in (10, 20) then
            'APP'
           when d.application_key = 40 then
            'PC'
         end channel_name,
         d.application_key
    from fact_page_view d
   where d.visit_date_key between 20170301 and 20170331;*/
--2.2
select i.date_key,
       i.is_new_user,
       i.is_scan,
       i.channel_name,
       count(distinct i.vid) dau
  from (select e.date_key,
               e.vid,
               e.member_key,
               e.channel_name,
               case
                 when f.first_order_date_key = e.date_key then
                  'new_user'
                 else
                  'old_user'
               end is_new_user,
               case
                 when g.vid is null then
                  'non_scan'
                 else
                  'scan'
               end is_scan
          from fact_page_view_201703 e,
               dim_member f,
               (select h.scan_date_key, h.vid
                  from dim_vid_scan h
                 where h.scan_date_key between 20170301 and 20170331) g
         where e.member_key = f.member_bp
           and e.date_key = g.scan_date_key(+)
           and e.vid = g.vid(+)
           and e.channel_name is not null) i
 group by i.date_key, i.is_new_user, i.is_scan, i.channel_name
 order by i.date_key, i.is_new_user, i.is_scan, i.channel_name;

--2.3 union
--create table oper_dau_order_201703 as
truncate table oper_dau_order_201703;
insert into oper_dau_order_201703
  (date_key,
   is_new_user,
   is_scan,
   channel_name,
   dau,
   order_member_count,
   order_amount,
   order_qty,
   order_count)
  select k.date_key,
         k.is_new_user,
         k.is_scan,
         k.channel_name,
         k.dau,
         nvl(j.order_member_count, 0) order_member_count,
         nvl(j.order_amount, 0) order_amount,
         nvl(j.order_qty, 0) order_qty,
         nvl(j.order_count, 0) order_count
    from (select l.date_key,
                 l.is_new_user,
                 l.is_scan,
                 l.channel_name,
                 count(distinct l.member_key) order_member_count,
                 sum(l.order_amount) order_amount,
                 sum(l.goods_num) order_qty,
                 count(l.order_id) order_count
            from (select b.add_time date_key,
                         case
                           when b.order_from = '76' then
                            'scan'
                           else
                            'non_scan'
                         end is_scan,
                         case
                           when b.app_name = 'KLGMPortal' then
                            '3G'
                           when b.app_name = 'KLGWX' then
                            '΢��'
                           when b.app_name in ('KLGAndroid', 'KLGiPhone') then
                            'APP'
                           when b.app_name = 'KLGPortal' then
                            'PC'
                         end channel_name,
                         case
                           when c.firstw_order_date_key = b.add_time then
                            'new_user'
                           else
                            'old_user'
                         end is_new_user,
                         b.order_id,
                         b.vid,
                         b.member_key,
                         b.goods_num,
                         b.order_amount
                    from (select a.order_id,
                                 a.add_time,
                                 a.vid,
                                 a.order_from,
                                 a.app_name,
                                 a.member_key,
                                 a.order_amount,
                                 a.goods_num
                            from factec_order a
                           where a.add_time between 20170301 and 20170331
                             and a.order_state >= 20) b,
                         dim_member c
                   where b.member_key = c.member_bp) l
           group by l.date_key, l.is_new_user, l.is_scan, l.channel_name) j,
         (select i.date_key,
                 i.is_new_user,
                 i.is_scan,
                 i.channel_name,
                 count(distinct i.vid) dau
            from (select e.date_key,
                         e.vid,
                         e.member_key,
                         e.channel_name,
                         case
                           when f.first_order_date_key >= e.date_key then
                            'new_user'
                           when f.first_order_date_key between 0 and
                                e.date_key then
                            'old_user'
                           when nvl(f.first_order_date_key, 0) = 0 then
                            'new_user'
                         end is_new_user,
                         case
                           when g.vid is null then
                            'non_scan'
                           else
                            'scan'
                         end is_scan
                    from fact_page_view_201703 e,
                         dim_member f,
                         (select h.scan_date_key, h.vid
                            from dim_vid_scan h
                           where h.scan_date_key between 20170301 and 20170331) g
                   where e.member_key = f.member_bp(+)
                     and e.date_key = g.scan_date_key(+)
                     and e.vid = g.vid(+)
                     and e.channel_name is not null) i
           group by i.date_key, i.is_new_user, i.is_scan, i.channel_name) k
   where j.date_key(+) = k.date_key
     and j.is_new_user(+) = k.is_new_user
     and j.is_scan(+) = k.is_scan
     and j.channel_name(+) = k.channel_name
   order by k.date_key, k.is_new_user, k.is_scan, k.channel_name;

--tmp
select * from dim_application;
select * from dim_member;
select distinct a.application_key, a.application_name
  from fact_page_view a
 where a.visit_date_key = 20180315;
select * from dim_vid_scan;
select distinct a.app_name
  from factec_order a
 where a.add_time between 20170301 and 20170331;
select distinct d.application_name
  from fact_page_view d
 where d.visit_date_key between 20170301 and 20170331;
