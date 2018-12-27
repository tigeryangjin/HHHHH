???create or replace procedure dw_user.processdimipgeo(startpoint number,
                                            endpoint   number) is
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
  sp_name          := 'processpageipgeo'; --需要手工填入所写PROCEDURE的名称
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

  declare
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
    ip_key    number;
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from fact_page_view e
     where e.id between startpoint and endpoint
     order by e.id;
  
    for i in 1 .. var_array.count loop
    
      select /*+ index(e2 IP_START3_IDX) */
       nvl((max(e2.ip_geo_key)), -1)
        into ip_key
        from dim_ip_geo e2
       where e2.ip_start_2 <= var_array(i).ip_int*0.000001
         and e2.ip_end_2 >= var_array(i).ip_int*0.000001;
    
      update /*+ index(e FPV_ID) */ fact_page_view e
         set e.ipgeo_key = ip_key
       where e.id = var_array(i).id;
    
      commit;
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
  
end processdimipgeo;
/

