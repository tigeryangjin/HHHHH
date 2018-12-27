???create or replace procedure dw_happigo.processgoods is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层DIM_GOODS表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-06-12
  */

begin

  sp_name          := 'processgoods'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'DIM_GOODS'; --此处需要手工录入该PROCEDURE操作的表格
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

delete from dim_goods;
commit;

  insert into dim_goods
    (goods_key,
     goods_code,
     goods_name,
     price_sale,
     md_code,
     sort_id,
     type_id,
     kind_id,
     brand_id,
     ckey,
     matdl,
     matzl,
     matxl,
     matkl
     
     )
  
    select a.gid,
           a.sitem_code,
           a.title,
           a.price_sale,
           a.md_code,
           a.sort_id,
           a.type_id,
           a.kind_id,
           a.brand_id,
           a.cid,
           a.matdl,
           a.matzl,
           a.matxl,
           a.matkl
      from ods_goodslist a;
  --  where to_char(a.add_time,'yyyy-mm-dd')>='2015-08-17'
  --  and   to_char(a.add_time,'yyyy-mm-dd')<'2015-09-08';
  --  =to_char((sysdate-1),'yyyy-mm-dd');

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
end processgoods;
/

