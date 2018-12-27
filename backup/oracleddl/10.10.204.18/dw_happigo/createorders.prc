???create or replace procedure dw_happigo.createorders is
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

  sp_name          := 'processorders'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_order'; --此处需要手工录入该PROCEDURE操作的表格
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

  --delete from fact_orders;
  insert into fact_order
    (order_id,
     addr_id,
     total_price,
     save_price,
     total_points,
     member_key,
     channel_key,
     channel,
     order_date_key,
     order_date,
     order_time_key,
     order_time,
     pay_date_key,
     pay_date,
     pay_time_key,
     pay_time,
     pay_name,
     pay_status,
     order_orgin,
     order_key,
     pay_type_key,
     pay_status_key,
     application_key
     
     )
    select a1.order_id,
           a1.addr_id,
           a1.total_price,
           a1.save_price,
           a1.total_points,
           to_number(a1.cust_no) as member_key,
           (select b.channel_key
              from dim_channel b
             where b.channel_name = a1.channel) as channel_key,
           a1.channel,
           to_number(to_char(a1.create_time, 'yyyymmdd')) as order_date_key,
           a1.create_time as order_date,
           (select b1.hour_key
              from dim_hour b1
             where b1.start_value =
                   to_number(to_char(a1.create_time, 'hh24'))) as order_time_key,
           to_number(to_char(a1.create_time, 'hh24')) as order_time,
           to_number(to_char(nvl(a2.modify_status_time, a1.create_time),
                             'yyyymmdd')) as pay_date_key,
           nvl(a2.modify_status_time, a1.create_time) as pay_date,
           (select b1.hour_key
              from dim_hour b1
             where b1.start_value =
                   to_number(to_char(nvl(a2.modify_status_time,
                                         a1.create_time),
                                     'hh24'))) as pay_time_key,
           to_number(to_char(nvl(a2.modify_status_time, a1.create_time),
                             'hh24')) as pay_time,
           nvl(a2.pay_name, 'unknown') as pay_name,
           nvl(a2.pay_status, 'unknown') as pay_status,
           a1.order_orgin,
           a1.rec_id as order_key,
           nvl(a2.pay_type_key, 0) as pay_type_key,
           nvl(a2.pay_status_key, 0) as pay_status_key,
           0 as application_key
      from ods_orders a1, ods_order_pay a2
     where a1.status = 0
       and a1.order_id = a2.order_no(+)
       and to_char(a1.create_time, 'yyyy-mm-dd')=to_char((sysdate - 1), 'yyyy-mm-dd');
       --and to_char(a1.create_time, 'yyyy-mm-dd')<'2015-12-02'
        --   to_char((sysdate - 1), 'yyyy-mm-dd');

  insert_rows := sql%rowcount;

  commit;

  update fact_order
     set application_key = 40
   where channel_key = 1;
     --and to_char(order_date, 'yyyy-mm-dd') =
         --to_char((sysdate - 1), 'yyyy-mm-dd');
  update fact_order
     set application_key = 50
   where channel_key = 2;
    -- and to_char(order_date, 'yyyy-mm-dd') =
      --   to_char((sysdate - 1), 'yyyy-mm-dd');
  update fact_order
     set application_key = 10
   where channel_key = 3
     and order_orgin = 61;
  --   and to_char(order_date, 'yyyy-mm-dd') =
   --      to_char((sysdate - 1), 'yyyy-mm-dd');

  update fact_order
     set application_key = 20
   where channel_key = 3
     and order_orgin = 63;
   --  and to_char(order_date, 'yyyy-mm-dd') =
   --      to_char((sysdate - 1), 'yyyy-mm-dd');
  update fact_order
     set application_key = 30
   where channel_key = 4;
    -- and to_char(order_date, 'yyyy-mm-dd') =
    --     to_char((sysdate - 1), 'yyyy-mm-dd');
  commit;
  update fact_order
     set application_key = -1
   where application_key = 0;
     --and to_char(order_date, 'yyyy-mm-dd') =
    --     to_char((sysdate - 1), 'yyyy-mm-dd');
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
end createorders;
/

