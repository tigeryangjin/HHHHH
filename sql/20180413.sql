select e.visit_date_key,
       e.channel,
       e.page_view_key,
       e.member_key,
       e.page_staytime,
       case
         when is_new = 1 then
          e.page_view_key
       end new_page_view_key,
       case
         when is_new = 0 then
          e.page_view_key
       end old_page_view_key,
       case
         when is_new = 1 then
          e.member_key
       end new_member_key,
       case
         when is_new = 0 then
          e.member_key
       end old_member_key
  from (select d.visit_date_key,
               case
                 when d.application_key in (10, 20) then
                  'APP'
                 when d.application_key = 70 then
                  'С����'
               end channel,
               d.page_view_key,
               d.member_key,
               d.page_staytime,
               case
                 when to_date(d.visit_date_key, 'yyyymmdd') >
                      d.first_order_date then
                  0
                 when to_date(d.visit_date_key, 'yyyymmdd') <=
                      d.first_order_date then
                  1
               end is_new
          from (select a.visit_date_key,
                       a.application_key,
                       a.page_view_key,
                       a.member_key,
                       a.page_staytime,
                       nvl(c.first_order_date, date '2000-01-01') first_order_date
                  from fact_page_view a,
                       (select b.cust_no member_key,
                               trunc(min(b.add_time)) first_order_date
                          from fact_ec_order_2 b
                         group by b.cust_no) c
                 where a.member_key = c.member_key(+)
                   and a.visit_date_key = 20180412
                   and a.application_key in (10, 20, 70)) d) e;
