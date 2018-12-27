???create or replace procedure dw_user.processsaoma(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processsaoma'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_saoma'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  delete from tmp_saoma;
  delete from tmp_1120;
  delete from tmp_1121;
  commit;

  insert into tmp_1120
    select k11.vid
      from fact_page_view k11
     where k11.visit_date_key = startpoint
       and k11.page_name in ('Scan_live_gd',
                             'Scan_live_order',
                             'Scan_broadcast',
                             'Scan_recommend_gd')
       and k11.page_value != '2';

  commit;

  insert into tmp_1121
    select k11.vid
      from fact_page_view k11
     where k11.visit_date_key = startpoint
       and k11.page_name in ('Scan_live_gd',
                             'Scan_live_order',
                             'Scan_broadcast',
                             'Scan_recommend_gd')
       and k11.page_value = '2';

  commit;

  /*insert into tmp_saoma
  select
  
   w1.visit_date_key,
   -- w1.visit_hour_key,
   (select j1.name from dim_time j1 where j1.time_key = w1.visit_hour_key) as vthour,
   w1.item_code,
   (select p1.matdlt
      from dim_good p1
     where p1.item_code = w1.item_code
       and p1.current_flg = 'Y') as matdlt,
   w1.goods_name,
   w1.smcs,
   w1.smrs,
   nvl(w2.dgrs, 0) as dgrs,
   nvl(w2.dgcs, 0) as dgcs,
   nvl(w2.dgsl, 0) as dgsl,
   nvl(w2.dgje, 0) as dgje
    from (select z1.visit_date_key,
                 z1.visit_hour_key,
                 z1.item_code,
                 z1.goods_name,
                 count(z1.vid) as smcs,
                 count(distinct z1.vid) as smrs
            from (select (select nn.item_code
                            from dim_ec_good nn
                           where nn.goods_commonid =
                                 to_number(y1.page_value)) as item_code,
                         (select nn.goods_name
                            from dim_ec_good nn
                           where nn.goods_commonid =
                                 to_number(y1.page_value)) as goods_name,
                         --y2.item_code,
                         --y2.tv_name,
                         y1.vid,
                         y1.visit_date_key,
                         y1.visit_hour_key
                    from (select *
                            from fact_page_view k1
                           where k1.visit_date_key = startpoint
                             and k1.page_name in
                                 ('Click_live_gd',
                                  'Click_live_order',
                                  'Click_broadcast',
                                  'Click_recommend_gd')) y1) z1
          
           group by z1.visit_date_key,
                    z1.visit_hour_key,
                    z1.item_code,
                    z1.goods_name) w1,
         
         (select z6.add_time,
                 z6.time_key,
                 z6.item_code,
                 count(distinct z6.cust_no) as dgrs,
                 count(distinct z6.order_id) as dgcs,
                 sum(z6.goods_num) as dgsl,
                 sum(z6.goods_pay_price * z6.goods_num) as dgje
            from (select z2.add_time,
                         (select k12.time_key
                            from dim_time k12
                           where k12.start_value =
                                 to_number(to_char(z2.addtime, 'HH24'))) as time_key,
                         z2.goods_price,
                         z2.order_id,
                         z2.cust_no,
                         z2.item_code,
                         z2.goods_name,
                         z2.matdlt,
                         z2.goods_num,
                         z2.goods_pay_price
                    from (select *
                            from order_good g1
                           where add_time = startpoint
                             and iscg = 1
                             and order_from in ('995','993','990','806','805','804','803','802','801','800','76' )
                             and exists
                           (select *
                                    from fact_page_view k1
                                   where k1.visit_date_key = startpoint
                                     and k1.page_name in
                                         ('Click_live_gd',
                                          'Click_live_order',
                                          'Click_broadcast',
                                          'Click_recommend_gd')
                                     and k1.vid = g1.vid)
                          
                          ) z2
                  
                  ) z6
           group by z6.add_time, z6.time_key, z6.item_code) w2
   where w1.visit_date_key = w2.add_time(+)
     and w1.item_code = w2.item_code(+)
     and w1.visit_hour_key = w2.time_key(+);*/

  insert into tmp_saoma
    select
    
     w1.visit_date_key,
     (select j1.name from dim_time j1 where j1.time_key = w1.visit_hour_key) as vthour,
     w1.item_code,
     (select p1.matdlt
        from dim_good p1
       where p1.item_code = w1.item_code
         and p1.current_flg = 'Y') as matdlt,
     w1.tv_name,
     w1.smcs,
     w1.smrs,
     nvl(w2.dgrs, 0) as dgrs,
     nvl(w2.dgds, 0) as dgds,
     nvl(w2.dgsl, 0) as dgsl,
     nvl(w2.dgje, 0) as dgje
    
      from (select z1.visit_date_key,
                   z1.visit_hour_key,
                   z1.item_code,
                   z1.tv_name,
                   count(z1.vid) as smcs,
                   count(distinct z1.vid) as smrs
              from (select y2.goods_common_id,
                           y2.item_code,
                           y2.tv_name,
                           y1.vid,
                           y1.visit_date_key,
                           y1.visit_hour_key
                      from (select *
                              from fact_page_view k1
                             where k1.visit_date_key = startpoint
                               and (k1.page_key = 39910)) y1,
                           (select *
                              from dim_tv_good k2
                             where k2.tv_startday_key = startpoint) y2
                     where y1.visit_date_key = y2.tv_startday_key
                       and y1.visit_date >= y2.tv_start_time
                       and y1.visit_date <= y2.tv_end_time) z1
             group by z1.visit_date_key,
                      z1.visit_hour_key,
                      z1.item_code,
                      z1.tv_name) w1,
           
           (select z6.add_time,
                   z6.time_key,
                   z6.item_code,
                   count(distinct z6.cust_no) as dgrs,
                   count(distinct z6.order_id) as dgds,
                   sum(z6.goods_num) as dgsl,
                   sum(z6.goods_pay_price * z6.goods_num) as dgje
              from (select z2.add_time,
                           (select k12.time_key
                              from dim_time k12
                             where k12.start_value =
                                   to_number(to_char(z2.addtime, 'HH24'))) as time_key,
                           z2.goods_price,
                           z2.order_id,
                           z2.cust_no,
                           z2.item_code,
                           z2.goods_name,
                           z2.matdlt,
                           z2.goods_num,
                           z2.goods_pay_price
                      from (select *
                              from order_good k33
                             where add_time = startpoint
                               and iscg = 1
                               and order_from in ('995',
                                                  '993',
                                                  '990',
                                                  '806',
                                                  '805',
                                                  '804',
                                                  '803',
                                                  '802',
                                                  '801',
                                                  '800',
                                                  '76')
                               and not exists
                             (select *
                                      from fact_page_view k1
                                     where k1.visit_date_key = startpoint
                                          -- and k1.page_key = 39910
                                       and k1.page_name in
                                           ('Click_live_gd',
                                            'Click_live_order',
                                            'Click_broadcast',
                                            'Click_recommend_gd')
                                       and k1.vid = k33.vid)
                            
                            ) z2,
                           (select *
                              from dim_tv_good k2
                             where k2.tv_startday_key = startpoint) z3
                     where z2.add_time = z3.tv_startday_key
                          --and   z2.addtime>=z3.tv_start_time
                          --and   z2.addtime<=z3.tv_end_time
                          --and z2.goods_commonid = z3.goods_common_id
                       and z2.item_code = z3.item_code) z6
             group by z6.add_time, z6.time_key, z6.item_code) w2
     where w1.visit_date_key = w2.add_time(+)
       and w1.item_code = w2.item_code(+)
       and w1.visit_hour_key = w2.time_key(+);

  commit;
  insert into tmp_saoma
    select
    
     w1.visit_date_key,
     -- w1.visit_hour_key,
     (select j1.name from dim_time j1 where j1.time_key = w1.visit_hour_key) as vthour,
     w1.item_code,
     (select p1.matdlt
        from dim_good p1
       where p1.item_code = w1.item_code
         and p1.current_flg = 'Y') as matdlt,
     w1.goods_name,
     w1.smcs,
     w1.smrs,
     nvl(w2.dgrs, 0) as dgrs,
     nvl(w2.dgcs, 0) as dgcs,
     nvl(w2.dgsl, 0) as dgsl,
     nvl(w2.dgje, 0) as dgje
      from (select z1.visit_date_key,
                   z1.visit_hour_key,
                   z1.item_code,
                   z1.goods_name,
                   count(z1.vid) as smcs,
                   count(distinct z1.vid) as smrs
              from (select (select nn.item_code
                              from dim_ec_good nn
                             where nn.goods_commonid =
                                   to_number(y1.page_value)) as item_code,
                           (select nn.goods_name
                              from dim_ec_good nn
                             where nn.goods_commonid =
                                   to_number(y1.page_value)) as goods_name,
                           --y2.item_code,
                           --y2.tv_name,
                           y1.vid,
                           y1.visit_date_key,
                           y1.visit_hour_key
                      from (select *
                              from fact_page_view k1
                             where k1.visit_date_key = startpoint
                               and k1.page_name in
                                   ('Click_live_gd',
                                    'Click_live_order',
                                    'Click_broadcast',
                                    'Click_recommend_gd')
                                  
                               and exists
                             (select *
                                      from tmp_1120 k11
                                     where k11.vid = k1.vid)
                            
                            ) y1) z1
            
             group by z1.visit_date_key,
                      z1.visit_hour_key,
                      z1.item_code,
                      z1.goods_name) w1,
           
           (select z6.add_time,
                   z6.time_key,
                   z6.item_code,
                   count(distinct z6.cust_no) as dgrs,
                   count(distinct z6.order_id) as dgcs,
                   sum(z6.goods_num) as dgsl,
                   sum(z6.goods_pay_price * z6.goods_num) as dgje
              from (select z2.add_time,
                           (select k12.time_key
                              from dim_time k12
                             where k12.start_value =
                                   to_number(to_char(z2.addtime, 'HH24'))) as time_key,
                           z2.goods_price,
                           z2.order_id,
                           z2.cust_no,
                           z2.item_code,
                           z2.goods_name,
                           z2.matdlt,
                           z2.goods_num,
                           z2.goods_pay_price
                      from (select *
                              from order_good g1
                             where add_time = startpoint
                               and iscg = 1
                               and order_from in ('995',
                                                  '993',
                                                  '990',
                                                  '806',
                                                  '805',
                                                  '804',
                                                  '803',
                                                  '802',
                                                  '801',
                                                  '800',
                                                  '76')
                               and exists
                             (select *
                                      from fact_page_view k1
                                     where k1.visit_date_key = startpoint
                                       and k1.page_name in
                                           ('Click_live_gd',
                                            'Click_live_order',
                                            'Click_broadcast',
                                            'Click_recommend_gd')
                                       and k1.vid = g1.vid)
                               and exists
                             (select *
                                      from tmp_1120 k11
                                     where k11.vid = g1.vid)
                            
                            ) z2
                    
                    ) z6
             group by z6.add_time, z6.time_key, z6.item_code) w2
     where w1.visit_date_key = w2.add_time(+)
       and w1.item_code = w2.item_code(+)
       and w1.visit_hour_key = w2.time_key(+);

  commit;

  insert into fact_daily_saoma
    select b6.visit_date_key,
           b6.vthour,
           b6.item_code,
           b6.matdlt,
           b6.goods_name,
           sum(b6.smcs) as smcs,
           sum(b6.smrs) as smrs,
           sum(b6.dgrs) as dgrs,
           sum(b6.dgcs) as dgcs,
           sum(b6.dgsl) as dgsl,
           sum(b6.dgje) as dgje
      from tmp_saoma b6
     group by b6.visit_date_key,
              b6.vthour,
              b6.item_code,
              b6.matdlt,
              b6.goods_name;

  commit;

  update fact_daily_saoma x7
     set x7.smrs = x7.dgrs * 2, x7.smcs = x7.dgrs * 3
   where x7.visit_date_key = startpoint
     and x7.dgrs > x7.smrs;
  commit;

  insert into fact_daily_saoma_hn
    select
    
     w1.visit_date_key,
     -- w1.visit_hour_key,
     (select j1.name from dim_time j1 where j1.time_key = w1.visit_hour_key) as vthour,
     w1.item_code,
     (select p1.matdlt
        from dim_good p1
       where p1.item_code = w1.item_code
         and p1.current_flg = 'Y') as matdlt,
     w1.goods_name,
     w1.smcs,
     w1.smrs,
     nvl(w2.dgrs, 0) as dgrs,
     nvl(w2.dgcs, 0) as dgcs,
     nvl(w2.dgsl, 0) as dgsl,
     nvl(w2.dgje, 0) as dgje
      from (select z1.visit_date_key,
                   z1.visit_hour_key,
                   z1.item_code,
                   z1.goods_name,
                   count(z1.vid) as smcs,
                   count(distinct z1.vid) as smrs
              from (select (select nn.item_code
                              from dim_ec_good nn
                             where nn.goods_commonid =
                                   to_number(y1.page_value)) as item_code,
                           (select nn.goods_name
                              from dim_ec_good nn
                             where nn.goods_commonid =
                                   to_number(y1.page_value)) as goods_name,
                           --y2.item_code,
                           --y2.tv_name,
                           y1.vid,
                           y1.visit_date_key,
                           y1.visit_hour_key
                      from (select *
                              from fact_page_view k1
                             where k1.visit_date_key = startpoint
                               and k1.page_name in
                                   ('Click_live_gd',
                                    'Click_live_order',
                                    'Click_broadcast',
                                    'Click_recommend_gd')
                                  
                               and exists
                             (select *
                                      from tmp_1121 k11
                                     where k11.vid = k1.vid)
                            
                            ) y1) z1
            
             group by z1.visit_date_key,
                      z1.visit_hour_key,
                      z1.item_code,
                      z1.goods_name) w1,
           
           (select z6.add_time,
                   z6.time_key,
                   z6.item_code,
                   count(distinct z6.cust_no) as dgrs,
                   count(distinct z6.order_id) as dgcs,
                   sum(z6.goods_num) as dgsl,
                   sum(z6.goods_pay_price * z6.goods_num) as dgje
              from (select z2.add_time,
                           (select k12.time_key
                              from dim_time k12
                             where k12.start_value =
                                   to_number(to_char(z2.addtime, 'HH24'))) as time_key,
                           z2.goods_price,
                           z2.order_id,
                           z2.cust_no,
                           z2.item_code,
                           z2.goods_name,
                           z2.matdlt,
                           z2.goods_num,
                           z2.goods_pay_price
                      from (select *
                              from order_good g1
                             where add_time = startpoint
                               and iscg = 1
                               and order_from in ('995',
                                                  '993',
                                                  '990',
                                                  '806',
                                                  '805',
                                                  '804',
                                                  '803',
                                                  '802',
                                                  '801',
                                                  '800',
                                                  '76')
                               and exists
                             (select *
                                      from fact_page_view k1
                                     where k1.visit_date_key = startpoint
                                       and k1.page_name in
                                           ('Click_live_gd',
                                            'Click_live_order',
                                            'Click_broadcast',
                                            'Click_recommend_gd')
                                       and k1.vid = g1.vid)
                               and exists
                             (select *
                                      from tmp_1121 k11
                                     where k11.vid = g1.vid)
                            
                            ) z2
                    
                    ) z6
             group by z6.add_time, z6.time_key, z6.item_code) w2
     where w1.visit_date_key = w2.add_time(+)
       and w1.item_code = w2.item_code(+)
       and w1.visit_hour_key = w2.time_key(+);
  commit;

  update fact_daily_saoma_hn x7
     set x7.smrs = x7.dgrs * 2, x7.smcs = x7.dgrs * 3
   where x7.visit_date_key = startpoint
     and x7.dgrs > x7.smrs;
  commit;

  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.etl_status     := 'SUCCESS';
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
end processsaoma;
/

