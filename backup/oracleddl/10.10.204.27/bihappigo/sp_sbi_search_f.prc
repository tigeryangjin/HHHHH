???create or replace procedure bihappigo.SP_SBI_SEARCH_F is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  -- r_id        ods_pageview.id%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层fact_search表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'SP_SBI_SEARCH_F'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_search'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_search
    (id          ,
  vid         ,
  mid         ,
  ip          ,
  createon    ,
  isprocessed ,
  skw         ,
  a    )
    select z.id,
    z.vid,
    z.mid,
    z.ip,
    z.createon,
    z.isprocessed,
    z.skw,
    z.a
      from ods_search z;

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
end SP_SBI_SEARCH_F;
/

