???create or replace procedure dw_user.processlivescan(startpoint   in varchar2,
                                            endpoint     in varchar2,
                                            startpoint_1 in varchar2,
                                            endpoint_1   in varchar2,
                                            startpoint_2 in number,
                                            endpoint_3   in varchar2,
                                            startpoint_5 in varchar2,
                                            endpoint_5   in varchar2) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processlivescan'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_livescan'; --此处需要手工录入该PROCEDURE操作的表格
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

  declare
  
    dw number;
  
  begin
  
    select p1.day_of_week
      into dw
      from dim_date p1
     where p1.date_key = startpoint_2;
  
    if dw not in (1, 6, 7) then
      insert into fact_daily_livescan
        select
        
         live_scan_seq.nextval,
         startpoint || '年' || '第' || endpoint || '周' || startpoint_1 || '至' ||
         endpoint_1 as weekname,
         w1.visit_date_key,
         w1.item_code,
         (select p1.matdlt
            from dim_good p1
           where p1.item_code = w1.item_code
             and p1.current_flg = 'Y') as matdlt,
         w1.tv_name,
         w1.smcs,
         w1.smrs,
         nvl(w2.dgrs, 0) as dgrs,
         nvl(w2.dgsl, 0) as dgsl,
         nvl(w2.dgje, 0) as dgje
          from (select z1.visit_date_key,
                       z1.item_code,
                       z1.tv_name,
                       count(z1.vid) as smcs,
                       count(distinct z1.vid) as smrs
                  from (select y2.goods_common_id,
                               y2.item_code,
                               y2.tv_name,
                               y1.vid,
                               y1.visit_date_key
                          from (select *
                                  from fact_page_view k1
                                 where k1.visit_date_key = startpoint_2
                                   and (k1.page_key = 39910
                                   or k1.page_name in ('Click_live_gd','Click_live_order','Click_broadcast','Click_recommend_gd')
                                   )
                                   ) y1,
                               (select *
                                  from dim_tv_good k2
                                 where k2.tv_startday_key = startpoint_2) y2
                         where y1.visit_date_key = y2.tv_startday_key
                           and y1.visit_date >= y2.tv_start_time
                           and y1.visit_date <= y2.tv_end_time) z1
                 group by z1.visit_date_key, z1.item_code, z1.tv_name) w1,
               
               (select z6.add_time,
                       z6.item_code,
                       count(distinct z6.cust_no) as dgrs,
                       sum(z6.goods_num) as dgsl,
                       sum(z6.goods_pay_price * z6.goods_num) as dgje
                  from (select z2.add_time,
                               z2.goods_price,
                               z2.order_id,
                               z2.cust_no,
                               z2.item_code,
                               z2.goods_name,
                               z2.matdlt,
                               z2.goods_num,
                               z2.goods_pay_price
                          from (select *
                                  from order_good
                                 where add_time = startpoint_2
                                   and iscg = 1
                                   and order_from='76'
                                   ) z2,
                               (select *
                                  from dim_tv_good k2
                                 where k2.tv_startday_key = startpoint_2) z3
                         where z2.add_time = z3.tv_startday_key
                              --and   z2.addtime>=z3.tv_start_time
                              --and   z2.addtime<=z3.tv_end_time
                           --and z2.goods_commonid = z3.goods_common_id
                           and z2.item_code = z3.item_code) z6
                 group by z6.add_time, z6.item_code) w2
         where w1.visit_date_key = w2.add_time(+)
           and w1.item_code = w2.item_code(+);
    
      insert_rows := sql%rowcount;
      commit;
    
    else
      insert into fact_daily_livescan
        select
        
         live_scan_seq.nextval,
         startpoint || '年' || '第' || endpoint_3 || '周' || startpoint_5 || '至' ||
         endpoint_5 as weekname,
         w1.visit_date_key,
         w1.item_code,
         (select p1.matdlt
            from dim_good p1
           where p1.item_code = w1.item_code
             and p1.current_flg = 'Y') as matdlt,
         w1.tv_name,
         w1.smcs,
         w1.smrs,
         nvl(w2.dgrs, 0) as dgrs,
         nvl(w2.dgsl, 0) as dgsl,
         nvl(w2.dgje, 0) as dgje
          from (select z1.visit_date_key,
                       z1.item_code,
                       z1.tv_name,
                       count(z1.vid) as smcs,
                       count(distinct z1.vid) as smrs
                  from (select y2.goods_common_id,
                               y2.item_code,
                               y2.tv_name,
                               y1.vid,
                               y1.visit_date_key
                          from (select *
                                  from fact_page_view k1
                                 where k1.visit_date_key = startpoint_2
                                   and (k1.page_key = 39910
                                   or k1.page_name in ('Click_live_gd','Click_live_order','Click_broadcast','Click_recommend_gd')
                                   )) y1,
                               (select *
                                  from dim_tv_good k2
                                 where k2.tv_startday_key = startpoint_2) y2
                         where y1.visit_date_key = y2.tv_startday_key
                           and y1.visit_date >= y2.tv_start_time
                           and y1.visit_date <= y2.tv_end_time) z1
                 group by z1.visit_date_key, z1.item_code, z1.tv_name) w1,
               
               (select z6.add_time,
                       z6.item_code,
                       count(distinct z6.cust_no) as dgrs,
                       sum(z6.goods_num) as dgsl,
                       sum(z6.goods_pay_price * z6.goods_num) as dgje
                  from (select z2.add_time,
                               z2.goods_price,
                               z2.order_id,
                               z2.cust_no,
                               z2.item_code,
                               z2.goods_name,
                               z2.matdlt,
                               z2.goods_num,
                               z2.goods_pay_price
                          from (select *
                                  from order_good
                                 where add_time = startpoint_2
                                   and iscg = 1
                                   and order_from='76'
                                   ) z2,
                               (select *
                                  from dim_tv_good k2
                                 where k2.tv_startday_key = startpoint_2) z3
                         where z2.add_time = z3.tv_startday_key
                              --and   z2.addtime>=z3.tv_start_time
                              --and   z2.addtime<=z3.tv_end_time
                           --and z2.goods_commonid = z3.goods_common_id
                           and z2.item_code = z3.item_code) z6
                 group by z6.add_time, z6.item_code) w2
         where w1.visit_date_key = w2.add_time(+)
           and w1.item_code = w2.item_code(+);
    
      insert_rows := sql%rowcount;
      commit;
    
    end if;
  
  end;

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
end processlivescan;
/

