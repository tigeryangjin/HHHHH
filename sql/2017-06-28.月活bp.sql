--4-6月活跃用户 BP 访问频次  订购单数  订购金额
select d.member_key,
       d.visit_count,
       nvl(e.order_count, 0) order_count,
       nvl(e.order_amount, 0) order_amount
  from (select c.member_key, count(c.visit_date_key) visit_count
          from (select distinct b.member_key, b.visit_date_key
                  from fact_page_view b
                 where b.visit_date_key between 20170401 and 20170628) c
         group by c.member_key) d,
       (select a.member_key,
               nvl(count(a.order_obj_id), 0) order_count,
               nvl(sum(a.order_amount), 0) order_amount
          from fact_order a
         where a.posting_date_key between 20170401 and 20170628
           and a.order_state = 1
         group by a.member_key) e
 where d.member_key = e.member_key(+)
 order by 2, 3, 4;


