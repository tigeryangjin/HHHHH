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
                  'н╒пе'
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
