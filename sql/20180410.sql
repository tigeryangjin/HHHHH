select d.month_key,
       count(d.cust_no) member_count,
       sum(d.order_amount) order_amount
  from (select c.month_key,
               c.cust_no,
               c.order_amount,
               case
                 when c.month_key - c.last_month_key in (1, 89) then
                  1
                 else
                  0
               end is_last_month_order
          from (select b.month_key,
                       b.cust_no,
                       b.order_amount,
                       lag(b.month_key) over(partition by b.cust_no order by b.month_key, b.cust_no) last_month_key
                  from (select to_char(trunc(a.add_time), 'yyyymm') month_key,
                               a.cust_no,
                               sum(a.order_amount) order_amount
                          from fact_ec_order_2 a
                         where a.add_time between date '2017-12-01' and date
                         '2018-03-31'
                           and a.order_state >= 20
                         group by to_char(trunc(a.add_time), 'yyyymm'),
                                  a.cust_no) b) c
         where c.month_key between 201801 and 201803) d
 where d.is_last_month_order = 1
 group by d.month_key
 order by d.month_key;

select 201801 - 201712, 201701 - 201612 from dual;

select b.month_key,
       b.cust_no,
       b.order_amount,
       lag(b.month_key) over(partition by b.cust_no order by b.month_key) last_month_key
  from (select to_char(trunc(a.add_time), 'yyyymm') month_key,
               a.cust_no,
               sum(a.order_amount) order_amount
          from fact_ec_order_2 a
         where a.add_time between date '2017-12-01' and date
         '2018-03-31'
           and a.order_state >= 20
           and a.cust_no = 1308008612
         group by to_char(trunc(a.add_time), 'yyyymm'), a.cust_no) b
-- where b.month_key between 201801 and 201803
 order by 1, 4;

select *
  from fact_ec_order_2 a
 where a.add_time between date '2018-01-01' and date '2018-02-28'
   and a.order_state >= 20
   and exists
 (select 1
          from (select *
                  from fact_ec_order_2 c
                 where c.add_time between date '2017-12-01' and date
                 '2017-12-31'
                   and c.order_state >= 20) b
         where a.cust_no = b.cust_no);

select d.cust_no, count(1)
  from (select distinct to_char(c.add_time, 'yyyymm') month_key, c.cust_no
          from fact_ec_order_2 c
         where c.add_time between date '2017-12-01' and date '2018-03-31') d
 group by d.cust_no
having count(1) = 4;
