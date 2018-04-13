select b.level_name, sum(b.order_amount) sum_order_amount
  from (select a.order_id,
               a.order_amount,
               case
                 when a.order_amount between 10 and 600 then
                  '10-600'
                 when a.order_amount > 600 then
                  '600+'
               end level_name
          from fact_ec_order_2 a
         where a.add_time between date '2017-01-01' and date
         '2017-12-31'
           and a.order_amount >= 10
           and a.order_state >= 20) b
 group by b.level_name;
