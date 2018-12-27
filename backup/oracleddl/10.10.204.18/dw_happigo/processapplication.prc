???create or replace procedure dw_happigo.processapplication--(startpoint in fact_page_view.id%type,
--endpoint in fact_page_view.id%type)
 is

  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  fact_page_view.id%type;
 -- endpoint    fact_page_view.id%type;

begin

  sp_name          := 'processpvapplication'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_application'; --此处需要手工录入该PROCEDURE操作的表格
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

  /*select min(a.id)
    into startpoint
    from fact_page_view a
   where a.application_key = 0;
  select max(a.id)
    into endpoint
    from fact_page_view a
   where a.application_key = 0;*/


  
  DELETE from fact_page_view WHERE visit_date_key=20160229 and (id) IN 

( SELECT id FROM fact_page_view where visit_date_key=20160229 GROUP BY id HAVING COUNT(id) > 1) 
AND ROWID NOT IN (SELECT MIN(ROWID) FROM fact_page_view where visit_date_key=20160229 GROUP BY id HAVING COUNT(*) > 1);
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
  
end processapplication;
/

