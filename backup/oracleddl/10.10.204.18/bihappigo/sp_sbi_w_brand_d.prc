???create or replace procedure bihappigo.sp_sbi_w_brand_d is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  startpoint  ods_goods_brand.brand_id%type;
  endpoint    ods_goods_brand.brand_id%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层DIM_GOODS表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-06-12
  */

begin

  sp_name          := 'sp_sbi_w_brand_d'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'DIM_BRAND'; --此处需要手工录入该PROCEDURE操作的表格
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

  select min(a.brand_id)
    into startpoint
    from ods_goods_brand a
   where a.flag = 0;
  select max(a.brand_id)
    into endpoint
    from ods_goods_brand a
   where a.flag = 0;

  insert into dim_brand
    (brand_key,
  brand_name,
  createdate
     )
  
    select a.brand_id,
           a.brand_name,
           sysdate
      from ods_goods_brand a
     where a.brand_id between startpoint and endpoint
       and a.flag = 0;

  insert_rows := sql%rowcount;

  update ods_goods_brand
     set flag = 1
   where brand_id between startpoint and endpoint;

  update process_flag j
     set j.start_point = startpoint, j.end_point = endpoint
   where j.flag_name = 'ods_goods_brand';

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
end sp_sbi_w_brand_d;
/

