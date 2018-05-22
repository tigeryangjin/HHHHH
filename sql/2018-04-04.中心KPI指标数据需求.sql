/*
新增注册用户数  fact_ecmember
新会员订购人数  首单在当月产生的会员人数（去重）
新会员订购业绩  首单在当月产生的会员业绩
老会员订购人数（次月复购）  上一个月有产生订购的用户在本月的订购人数（去重）
老会员订购业绩（次月复购）  上一个月有产生订购的用户在本月的订购金额
当月会员订购人数  
当月会员订购业绩  
老会员订购人数（历史复购）  
老会员订购业绩（历史复购） 
*/

--1.新增注册用户数  fact_ecmember
select substr(a.member_time, 1, 6) month_key,
       count(distinct a.member_crmbp) member_count
  from fact_ecmember a
 where a.member_time between 20180401 and 20180430
 group by substr(a.member_time, 1, 6)
 order by substr(a.member_time, 1, 6);

--2.新会员订购人数  首单在当月产生的会员人数（去重） 新会员订购业绩  首单在当月产生的会员业绩
select a1.month_key,
       count(a1.cust_no) member_count,
       sum(a1.order_amount) order_amount
  from (select to_char(trunc(a.add_time), 'yyyymm') month_key,
               a.cust_no,
               sum(a.order_amount) order_amount
          from fact_ec_order_2 a
         where a.add_time between date '2018-04-01' and date
         '2018-04-30'
           and a.order_state >= 20
         group by to_char(trunc(a.add_time), 'yyyymm'), a.cust_no) a1,
       (select distinct substr(b.member_time, 1, 6) month_key,
                        b.member_crmbp
          from fact_ecmember b
         where b.member_time between 20180401 and 20180430) b1
 where a1.month_key = b1.month_key
   and a1.cust_no = b1.member_crmbp
 group by a1.month_key
 order by a1.month_key;

--3.老会员订购人数（次月复购）  上一个月有产生订购的用户在本月的订购人数（去重） 老会员订购业绩（次月复购）  上一个月有产生订购的用户在本月的订购金额
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
                         where a.add_time between date '2018-03-01' /*上个月1日*/
                           and date '2018-04-30'
                           and a.order_state >= 20
                         group by to_char(trunc(a.add_time), 'yyyymm'),
                                  a.cust_no) b) c
         where c.month_key between 201804 and 201804) d
 where d.is_last_month_order = 1
 group by d.month_key
 order by d.month_key;

--4.当月会员订购人数 当月会员订购业绩
select b.month_key,
       count(b.cust_no) member_count,
       sum(b.order_amount) order_amount
  from (select to_char(trunc(a.add_time), 'yyyymm') month_key,
               a.cust_no,
               sum(a.order_amount) order_amount
          from fact_ec_order_2 a
         where a.add_time between date '2018-04-01' and date
         '2018-04-30'
           and a.order_state >= 20
         group by to_char(trunc(a.add_time), 'yyyymm'), a.cust_no) b
 group by b.month_key
 order by b.month_key;

--5.老会员订购人数（历史复购） 老会员订购业绩（历史复购）
select e.month_key,
       count(e.cust_no) member_count,
       sum(e.order_amount) order_amount
  from (select b.month_key, b.cust_no, c.first_order_date, b.order_amount
          from (select to_char(trunc(a.add_time), 'yyyymm') month_key,
                       a.cust_no,
                       sum(a.order_amount) order_amount
                  from fact_ec_order_2 a
                 where a.add_time between date '2018-04-01' and date
                 '2018-04-30'
                   and a.order_state >= 20
                 group by to_char(trunc(a.add_time), 'yyyymm'), a.cust_no) b,
               (select d.cust_no,
                       to_char(trunc(min(d.add_time)), 'yyyymmdd') first_order_date
                  from fact_ec_order_2 d
                 group by d.cust_no) c
         where b.cust_no = c.cust_no(+)
           and b.month_key > substr(c.first_order_date, 1, 6)) e
 group by e.month_key
 order by e.month_key;

--6.当月购买两次及以上的会员人数,当月购买两次及以上的会员订购业绩
select b.month_key,
       count(b.cust_no) member_count,
       sum(b.order_amount) order_amount
  from (select to_char(trunc(a.add_time), 'yyyymm') month_key,
               a.cust_no,
               count(a.order_id) order_count,
               sum(a.order_amount) order_amount
          from fact_ec_order_2 a
         where a.add_time between date '2017-01-01' and date
         '2018-04-30'
           and a.order_state >= 20
         group by to_char(trunc(a.add_time), 'yyyymm'), a.cust_no
        having count(1) >= 2) b
 group by b.month_key
 order by b.month_key;

--tmp
select distinct a.cust_no
  from fact_ec_order_2 a
 where a.add_time between date '2017-01-01' and date '2017-01-31'
   and a.order_state >= 20
   and exists
 (select 1
          from (select distinct a1.cust_no
                  from fact_ec_order_2 a1
                 where a1.add_time between date '2016-12-01' and date
                 '2016-12-31'
                   and a1.order_state >= 20) b
         where a.cust_no = b.cust_no);
