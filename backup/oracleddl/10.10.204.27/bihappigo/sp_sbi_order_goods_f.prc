???create or replace procedure bihappigo.sp_sbi_order_goods_f is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  -- r_id        ods_pageview.id%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层fact_goods_sale表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'SP_SBI_ORDER_GOODS_F'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_goods_sale'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_goods_sale
    (id,
     order_key,
     goods_key,
     item_code,
     sku_key,
     goods_name,
     goods_number,
     sort_key,
     type_key,
     kind_key,
     devloper_key,
     brand_key,
     goods_price,
     create_date,
     create_date_key,
     channel,
     channel_key)
    select u.rec_id as id,
           u.order_id as order_key,
           u.goods_id as goods_key,
           (select u1.goods_code
              from dim_goods u1
             where u1.goods_key = u.goods_id) as item_code,
           u.sku as sku_key,
           u.goods_name,
           u.goods_number,
           (select u1.sort_id
              from dim_goods u1
             where u1.goods_key = u.goods_id) as sort_key,
           (select u1.type_id
              from dim_goods u1
             where u1.goods_key = u.goods_id) as type_key,
           (select u1.kind_id
              from dim_goods u1
             where u1.goods_key = u.goods_id) as kind_key,
           (select u1.md_code
              from dim_goods u1
             where u1.goods_key = u.goods_id) as devloper_key,
           (select u1.brand_id
              from dim_goods u1
             where u1.goods_key = u.goods_id) as brand_key,
           u.goods_price,
           u3.create_time as create_date,
           to_number(to_char(u3.create_time, 'yyyymmdd')) as create_date_key,
           u3.channel,
           (select u4.channel_key
              from dim_channel u4
             where u4.channel_name = u3.channel) as channel_key
      from ods_order_goods u,
           (select distinct u2.order_id, u2.create_time, u2.channel
              from ods_orders u2
             where u2.order_id is not null) u3
     where u.order_id = u3.order_id;

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
end sp_sbi_order_goods_f;
/

