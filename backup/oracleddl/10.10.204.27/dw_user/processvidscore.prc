???create or replace procedure dw_user.processvidscore is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processvidscore'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_vid_base'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_visitor_register%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
  begin
  
    select * bulk collect
      into var_array
      from fact_visitor_register e
     where e.create_date_key=to_number(to_char(sysdate - 1, 'yyyymmdd')) and application_key in (10,20);
  
    for i in 1 .. var_array.count loop
    
      if get_hsource(var_array(i).hmsc) = 1 then
        insert into dim_vid_base
        values
          (var_array(i).vid, 3, var_array(i).create_date_key);
        commit;
      
      elsif get_hsource(var_array(i).hmsc) = 2 then
      
        insert into dim_vid_base
        values
          (var_array(i).vid, -3, var_array(i).create_date_key);
        commit;
      
      elsif get_hsource(var_array(i).hmsc) = 3 then
      
        insert into dim_vid_base
        values
          (var_array(i).vid, -1, var_array(i).create_date_key);
        commit;
      
      else
      
        insert into dim_vid_base
        values
          (var_array(i).vid, -1, var_array(i).create_date_key);
        commit;
      
      end if;
    
    end loop;
  
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
end processvidscore;
/

