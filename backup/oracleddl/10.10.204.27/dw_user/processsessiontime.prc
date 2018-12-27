???create or replace procedure dw_user.processsessiontime(s_startpoint in fact_session.id%type,
                                               s_endpoint   in fact_session.id%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- s_startpoint fact_session.id%type;
  -- s_endpoint   fact_session.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processsessiontime'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_session'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;
  /*select min(a.id)
    into s_startpoint
    from fact_session a
   where a.life_time_key is null;
  select max(a.id)
    into s_endpoint
    from fact_session a
   where a.life_time_key is null;*/

  update fact_session t
     set t.life_time =
         (t.end_time - t.start_time) * 24 * 60 * 60
   where t.id between s_startpoint and s_endpoint;
  commit;

  update fact_session z
     set z.life_time_key =
         (select y.sessionstaytimekey
            from dim_sessionstaytime y
           where y.min <= z.life_time
             and y.max >= z.life_time)
   where z.id between s_startpoint and s_endpoint;
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
  
end processsessiontime;
/

