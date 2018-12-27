???create or replace procedure dw_user.processpagelation(startpoint in fact_page_view.id%type,
                                              endpoint   in fact_page_view.id%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processpagelation'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view'; --此处需要手工录入该PROCEDURE操作的表格
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

  --259450453

  declare
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
    p_key     number;
    p_value   varchar2(1000);
    mid       number;
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from fact_page_view e
     where e.id between startpoint and endpoint;
  
    for i in 1 .. var_array.count loop
    
      select /*+ index(a FPV_VISITOR) */
       nvl(max(a.id), var_array(i).id)
        into mid
        from fact_page_view a
       where a.id < var_array(i).id
         and a.id > 400000000
         and a.application_key = var_array(i).application_key
         and a.device_key = var_array(i).device_key;
    
      select /*+ index(z FPV_ID) */
       z.page_key
        into p_key
        from fact_page_view z
       where z.id = mid;
    
      select /*+ index(z FPV_ID) */
       z.page_value
        into p_value
        from fact_page_view z
       where z.id = mid;
    
      update /*+ index(s FPV_ID) */ fact_page_view s
         set s.last_page_key = p_key, s.hmkw = p_value
       where id = var_array(i).id;
    
      if mod(i, 1000) = 0 then
        commit;
      end if;
    
    end loop;
    commit;
  
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
  
end processpagelation;
/

