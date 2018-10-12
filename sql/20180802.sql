select * from member_label_link_mv;

select 27277.03+50799.28+8510.78+11215.92+2597.88+700 from dual;

select * from member_label_link_v;
select * from member_label_head;
select * from member_label_link;
select * from member_label_log;

select * from odshappigo.ods_pageview a where a.isprocessed=0;
select max(a.id) max_id from odshappigo.ods_pageview a;

select * from w_etl_log a where a.proc_name='createpaveviewfact' order by a.start_time desc;
select * from w_etl_log a order by a.start_time desc;
select * from odshappigo.ods_pageview a where a.createon>=date'2018-08-05';
select * from fact_page_view a where a.visit_date_key=20180805 and a.page_name='TV_QRC';
select * from dim_device;
createpaveviewfact
select * from fact_page_view a where a.visit_date_key=20180805;

select * from factec_order a where a.order_id=3169535;
select * from fact_ec_order a where a.order_id=3169535;
select * from fact_ec_order_2 a where a.order_id=3169535;

--5781,5782,5783,5784,5785
select * from fact_goods_sales a where a.posting_date_key>=20180715 and a.coupons is not null;
select * from fact_ec_order;
select * from factec_order a where a.voucher_ref in (5781,5782,5783,5784,5785);

select distinct a.voucher_t_id,a.voucher_title from fact_voucher a where a.voucher_title like '%员工%';


--4.当月会员订购人数 当月会员订购业绩
select b.month_key,
       count(b.cust_no) member_count,
       sum(b.order_amount) order_amount
  from (select to_char(trunc(a.add_time), 'yyyymm') month_key,
               a.cust_no,
               sum(a.order_amount) order_amount
          from fact_ec_order_2 a
         where a.add_time between date '2018-07-01' and date
         '2018-08-01'
           and a.order_state >= 20
        --and a.cust_no=603003139
         group by to_char(trunc(a.add_time), 'yyyymm'), a.cust_no) b
 group by b.month_key
 order by b.month_key;

--
select d.month_key,
       d.month_type,
       count(d.cust_no) member_count,
       sum(d.order_amount) order_amount
  from (select c.month_key,
               c.cust_no,
               c.order_amount,
               case
                 when c.last_month_key is null then
                  'new_month'
                 when months_between(to_date(c.month_key, 'yyyymm'),
                                     to_date(c.last_month_key, 'yyyymm')) = 1 then
                  'last_month'
                 else
                  'other_month'
               end month_type
          from (select b.month_key,
                       b.cust_no,
                       b.order_amount,
                       lag(b.month_key) over(partition by b.cust_no order by b.month_key, b.cust_no) last_month_key
                  from (select to_char(trunc(a.add_time), 'yyyymm') month_key,
                               a.cust_no,
                               sum(a.order_amount) order_amount
                          from fact_ec_order_2 a
                         where a.order_state >= 20
                         group by to_char(trunc(a.add_time), 'yyyymm'),
                                  a.cust_no) b) c
         where c.month_key = 201807) d
 group by d.month_key, d.month_type;

select to_char(trunc(a.add_time), 'yyyymm') month_key,
       a.cust_no,
       sum(a.order_amount) order_amount
  from fact_ec_order_2 a
 where a.order_state >= 20
   and a.cust_no = 603003139
 group by to_char(trunc(a.add_time), 'yyyymm'), a.cust_no;

SELECT *
  FROM fact_ec_order_2 a
 where a.order_state >= 20
   and a.cust_no = 603003139;
