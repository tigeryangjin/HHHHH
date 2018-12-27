???create or replace procedure dw_happigo.processpvapplication(startpoint in fact_page_view.id%type,
endpoint in fact_page_view.id%type)
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


  
  update fact_page_view c
     set c.application_key =
         (select d.application_key
            from dim_application d
           where d.application_name = c.application_name),
          c.channel_key=(select e.channel_key
            from dim_application e
           where e.application_name = c.application_name)
   where c.id between startpoint and endpoint;
   
   commit;
   
   ---关联不上的维度，全部处理为-1
  update fact_page_view c
     set c.application_key =-1
       
   where c.application_key=0 and  c.id between startpoint and endpoint;
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
  
end processpvapplication;
/

