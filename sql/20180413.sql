select d3.start_date_key,
       case
         when d3.application_key in (10, 20) then
          'APP'
         when d3.application_key = 70 then
          'С����'
       end channel,
       d3.member_key,
       d3.left_page_key,
       case
         when to_date(d3.start_date_key, 'yyyymmdd') > d3.first_order_date then
          0
         when to_date(d3.start_date_key, 'yyyymmdd') <= d3.first_order_date then
          1
       end is_new /*�Ƿ��»�Ա��־��1:�»�Ա��0:�ϻ�Ա*/
  from (select a3.start_date_key,
               a3.member_key,
               a3.application_key,
               a3.left_page_key,
               nvl(c3.first_order_date, date '2000-01-01') first_order_date /*�׵���������*/
          from fact_session a3,
               (select b3.cust_no member_key,
                       trunc(min(b3.add_time)) first_order_date
                  from fact_ec_order_2 b3
                 group by b3.cust_no) c3
         where a3.member_key = c3.member_key(+)
           and a3.start_date_key = 20180412
           and a3.application_key in (10, 20, 70)) d3
 where d3.member_key > 0
 order by 1, 2, 3, 4, 5
