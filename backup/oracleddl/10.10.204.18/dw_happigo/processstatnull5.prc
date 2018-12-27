???create or replace procedure dw_happigo.processstatnull5 is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processstatnull5'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'stats_online_visitor_minute'; --此处需要手工录入该PROCEDURE操作的表格
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


  declare
  
    type type_array is table of stats_online_visitor_minute%rowtype index by binary_integer; --类似二维数组 
  
    vtcnt     number;
    var_array type_array;
    -- 115858126
  begin
  
    select * bulk collect
      into var_array
      from stats_online_visitor_minute e
     where e.frequency=5
       and e.onlinevisitor=0
       and e.statdate>=to_number(to_char(sysdate,'yyyymmdd'));
       
     
  
    for i in 1 .. var_array.count loop
    
   
    
      select nvl(count(distinct vid),0)
        into vtcnt
        from fact_page_view z1
       where z1.visit_date >= var_array(i).START_TIME
         and z1.visit_date < var_array(i).END_TIME
         and z1.application_key = var_array(i).APPLICATION_KEY;
    
      update stats_online_visitor_minute z2
         set z2.onlinevisitor = vtcnt
       where z2.id = var_array(i).id;
    
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
  
end processstatnull5;
/

