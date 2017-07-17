--6月27和28的访问回应和订购回应
drop table member_key_tmp;
create table member_key_tmp(member_key number(20));

select * from member_key_tmp for update;

--
select d.member_key,
       decode(d.is_pv, 0, 'N', 'Y') is_pv,
       decode(d.is_order, 0, 'N', 'Y') is_order
  from (select a.member_key,
               nvl(b.member_key, 0) is_pv,
               nvl(c.member_key, 0) is_order
          from member_key_tmp a,
               (select distinct b1.member_key
                  from fact_page_view b1
                 where b1.visit_date_key between 20170627 and 20170628
                   and b1.member_key <> 0) b,
               (select distinct c1.member_key
                  from fact_order c1
                 where c1.posting_date_key between 20170627 and 20170628
                   and c1.order_state = 1) c
         where a.member_key = b.member_key(+)
           and a.member_key = c.member_key(+)) d
 order by d.member_key;
