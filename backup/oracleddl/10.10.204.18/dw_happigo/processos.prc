???create or replace procedure dw_happigo.processos is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
   startpoint fact_visitor.id%type;
   endpoint   fact_visitor.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processos'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_visitor'; --此处需要手工录入该PROCEDURE操作的表格
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
  select min(a.id)
    into startpoint
    from fact_visitor a
   where a.os_key=0;
  select max(a.id)
    into endpoint
    from fact_visitor a
   where a.os_key=0;
   
   
   update fact_visitor a
   set a.os='IOS' where   a.id between  startpoint and endpoint and a.agent like '%iPhone%';
   
   update fact_visitor a
   set a.os='Android' where   a.id between  startpoint and endpoint and a.agent like '%Android%';
   
   update fact_visitor a
   set a.os='IOS' where   a.id between  startpoint and endpoint and a.agent like '%Macintosh%';
   
   update fact_visitor a
   set a.os='IOS' where   a.id between  startpoint and endpoint and a.agent like '%iPad%';
   
   update fact_visitor a
   set a.os='Windows' where   a.id between  startpoint and endpoint and a.agent like '%Windows%';
   
    update fact_visitor a
   set a.os='Windows' where   a.id between  startpoint and endpoint and a.agent like '%Win32%'; 
 
   update fact_visitor a
   set a.os='Googlebot' where   a.id between  startpoint and endpoint and a.agent like '%Googlebot%';
   
    update fact_visitor a
   set a.os='spider' where   a.id between  startpoint and endpoint and a.agent like '%spider%';
    
    update fact_visitor a
   set a.os='unknown' where   a.id between  startpoint and endpoint and a.os is null;
   
   commit;
   
   
update fact_visitor c
     set c.os_key =
         (select d.os_key
            from dim_os d
           where d.os = c.os)
           where   c.id between  startpoint and endpoint;
    

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
  
end processos;
/

