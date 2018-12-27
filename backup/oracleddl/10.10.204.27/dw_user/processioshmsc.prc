???create or replace procedure dw_user.processioshmsc(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processioshmsc'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view'; --此处需要手工录入该PROCEDURE操作的表格
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

  update fact_page_view l2
     set l2.hmsc =
         (select l1.source
            from fact_app_activelog l1
           where l1.vid = l2.vid
             and l1.mapping_status = 1
             and l1.source is not null
             and rownum = 1)
   where l2.visit_date_key = startpoint
     and l2.application_key = 10;
  commit;

  update fact_page_view l2
     set l2.hmsc = 'as'
   where l2.visit_date_key = startpoint
     and l2.application_key = 10
     and l2.hmsc is null;
  commit;

  update fact_session l2
     set l2.hmsc =
         (select l1.source
            from fact_app_activelog l1
           where l1.vid = l2.vid
             and l1.mapping_status = 1
             and l1.source is not null
             and rownum = 1)
   where l2.start_date_key = startpoint
     and l2.application_key = 10;
  commit;

  update fact_session l2
     set l2.hmsc = 'as'
   where l2.start_date_key = startpoint
     and l2.application_key = 10
     and l2.hmsc is null;
  commit;

  update fact_visitor_register l2
     set l2.hmsc =
         (select l1.source
            from fact_app_activelog l1
           where l1.vid = l2.vid
             and l1.mapping_status = 1
             and l1.source is not null
             and rownum = 1)
   where l2.create_date_key = startpoint
     and l2.application_key = 10;
  commit;

  update fact_visitor_register l2
     set l2.hmsc = 'as'
   where l2.create_date_key = startpoint
     and l2.application_key = 10
     and l2.hmsc is null;
  commit;

  /*update fact_page_view l2
  set l2.hmsc='gdtios',l2.hmsc_key=9999
  where   l2.visit_date_key=startpoint
  and  exists (select * from  FACT_TBL_ACTIVELOG l1 where l1.vid=l2.vid and l1.mapping_status=1 );
   commit;
  
  update fact_session l2
  set l2.hmsc='gdtios'
  where   l2.start_date_key=startpoint
  and  exists (select * from  FACT_TBL_ACTIVELOG l1 where l1.vid=l2.vid and l1.mapping_status=1 );
  
   commit;
  update fact_visitor_register l2
  set l2.hmsc='gdtios'
  where   l2.create_date_key=startpoint
  and  exists (select * from  FACT_TBL_ACTIVELOG l1 where l1.vid=l2.vid and l1.mapping_status=1 );
  
  
    commit;*/

  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.err_msg        := '输入参数[startpoint]:' || startpoint;
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
end processioshmsc;
/

