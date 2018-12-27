???create or replace procedure dw_user.processkillsession is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processkillsession'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'V$SESSION'; --此处需要手工录入该PROCEDURE操作的表格
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
  --= '00000000';
  declare
  v_sid    varchar2(30);
  v_serial varchar2(30);
  v_sql    varchar2(1000);

  begin
  select va.sid into v_sid from sys.mysession va where object='PROCESSGDREALTIME';
  
  SELECT SERIAL# into v_serial FROM sys.mysession2 WHERE SID=v_sid;
  
  v_sql := 'alter system kill session ''' || v_sid || ',' || v_serial || '''';
    execute immediate v_sql;

  
  
  end;
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
end processkillsession;




--alter system kill session '132,11666'
--SELECT SID,SERIAL#,PADDR FROM V$SESSION WHERE SID=132
--select va.sid,va.OBJECT from v$access va where object='PROCESSGDREALTIME2'
/

