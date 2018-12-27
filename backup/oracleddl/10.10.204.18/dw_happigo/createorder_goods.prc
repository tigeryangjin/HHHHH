???create or replace procedure dw_happigo.createorder_goods is
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

  sp_name          := 'createorder_goods'; --需要手工填入所写PROCEDURE的名称
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

  --delete from fact_goods_sale;

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
     hour,
     hour_key,
     ckey,
     member_key,
     channel_key,
     channel_name
     )
    select u.rec_id as id,
           u.order_id as order_key,
           u.goods_id as goods_key,
          nvl( (select u1.goods_code
              from dim_goods u1
             where u1.goods_key = u.goods_id),0) as item_code,
           u.sku as sku_key,
          nvl(u.goods_name,'unknown'),
           u.goods_number,
          nvl( (select u1.sort_id
              from dim_goods u1
             where u1.goods_key = u.goods_id),0) as sort_key,
          nvl( (select u1.type_id
              from dim_goods u1
             where u1.goods_key = u.goods_id),0) as type_key,
           nvl((select u1.kind_id
              from dim_goods u1
             where u1.goods_key = u.goods_id),0) as kind_key,
           nvl((select u1.md_code
              from dim_goods u1
             where u1.goods_key = u.goods_id),0) as devloper_key,
          nvl((select u1.brand_id
              from dim_goods u1
             where u1.goods_key = u.goods_id),0) as brand_key,
           u.goods_price,
           u3.create_time as create_date,
           to_number(to_char(u3.create_time, 'yyyymmdd')) as create_date_key,
           to_number(to_char(u3.create_time, 'hh24')) as hour,
           (select h1.hour_key
              from dim_hour h1
             where h1.start_value =
                   to_number(to_char(u3.create_time, 'hh24'))) as hour_key,
            nvl((select u1.kind_id
              from dim_goods u1
             where u1.goods_key = u.goods_id),0) as ckey,
           to_number(u3.cust_no)  as member_key,
          ( select u4.channel_key from  dim_channel u4
           where u4.channel_name=u3.channel) as channel_key,
           u3.channel
    /*u3.channel,
    (select u4.channel_key
       from dim_channel u4
      where u4.channel_name = u3.channel) as channel_key*/
      from ods_order_goods u,
           (select distinct u2.order_id,u2.cust_no, u2.create_time,u2.channel
              from ods_orders u2
             where u2.order_id is not null
               and u2.status = 0) u3
     where u.order_id = u3.order_id
 and to_char(u3.create_time, 'yyyy-mm-dd') >='2015-09-08'
 and to_char(u3.create_time, 'yyyy-mm-dd') <'2015-09-18';
  --to_char((sysdate - 1), 'yyyy-mm-dd')

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
end createorder_goods;
/

