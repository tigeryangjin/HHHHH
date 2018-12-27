???create or replace procedure dw_user.processhour(startpoint in fact_page_view.id%type,
                                        endpoint   in fact_page_view.id%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processhour'; --需要手工填入所写PROCEDURE的名称
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

  update fact_page_view t
     set t.visit_hour = to_number(to_char(t.visit_date, 'HH24'))
   where t.id between startpoint and endpoint;

  update /*+ index(z) rule*/ fact_page_view z
     set z.visit_hour_key =
         (select y.time_key
            from dim_time y
           where y.start_value = z.visit_hour)
   where z.id between startpoint and endpoint;

  update fact_session l1
     set l1.hour_key =
         (select b1.time_key from dim_time b1 where b1.start_value = l1.hour)
   where l1.hour_key = 0;

  update fact_visitor_register l2
     set l2.create_time_key =
         (select b1.time_key
            from dim_time b1
           where b1.start_value = l2.create_time)
   where l2.create_time_key = 0;

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
end processhour;
/

