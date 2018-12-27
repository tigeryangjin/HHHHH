???create or replace procedure bihappigo.sp_sbi_orders_f is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
 -- r_id        ods_pageview.id%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层fact_orders表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'SP_SBI_ORDERS_F'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_orders'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_orders
    (id,
     order_number,
     member_key,
     session_key,
     hmsr_key,
     application_key,
     device_key,
     order_status_key,
     payment_status_key,
     payment_status,
     goods_count,
     goods_unit_count,
     total_price_key,
     total_price,
     price_discount_key,
     price_discount,
     total_points_key,
     total_points,
     shipping_address_key,
     payment_mode_key,
     create_time,
     creat_date_key,
     iscancle)
    select a.rec_id as id,
           a.order_id as order_number,
           b.member_key as member_key,
           b.session_key as session_key,
           b.hmsr_key as hmsr_key,
           b.application_key as application_key,
           b.device_key as device_key,
           a.order_status as order_status_key,
           0 as payment_status_key,
           a.proc_state as payment_status,
           d.goods_count as goods_count,
           d.goods_unit_count as goods_unit_count,
           0 as total_price_key,
           a.total_price as total_price,
           0 as price_discount_key,
           a.save_price as price_discount,
           0 as total_points_key,
           a.total_points as total_points,
           a.addr_id as shipping_address_key,
           a.pay_type as payment_mode_key,
           a.create_time as create_time,
           to_number(to_char(a.create_time, 'yyyymmdd')) as creat_date_key,
           case
             when a.proc_state = '订单取消' then
              1
             else
              0
           end as iscancle
      from fact_session b,
           ods_orders a,
           (select c.order_id,
                   count(c.goods_id) as goods_count,
                   sum(c.goods_number) as goods_unit_count
              from ods_order_goods c
             group by c.order_id) d
    
     where b.member_key = a.cust_no
       and a.order_id = d.order_id
       and a.create_time between b.start_date - 600 / 86400 and
           b.end_date + 600 / 86400;

  insert_rows := sql%rowcount;

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
end sp_sbi_orders_f;
/

