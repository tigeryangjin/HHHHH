???create or replace procedure dw_user.processvidscan(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processvidscan'; --需要手工填入所写PROCEDURE的名称
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

  insert into dim_vid_scan
    (vid,
     scan_date_key,
     active_date_key,
     ip,
     create_date
     
     )
  
    select vid, scan_date_key, active_date_key, ip, sysdate
      from (select distinct j2.vid,
                            j2.visit_date_key as scan_date_key,
                            0                 as active_date_key,
                            j2.ip
              from fact_page_view j2
             where j2.visit_date_key = startpoint
               and j2.application_key != 30
               and exists
             (select j1.ip
                      from fact_page_view j1
                     where j1.visit_date_key = startpoint
                       and (page_key = 39910 or
                           page_name in ('Click_live_gd',
                                          'Click_live_order',
                                          'Click_broadcast',
                                          'Click_recommend_gd'))
                       and j1.ip = j2.ip)
               and not exists (select *
                      from dim_vid_scan j3
                     where j3.scan_date_key = startpoint
                       and j3.vid = j2.vid
                       and j3.ip = j2.ip));
  commit;

  update dim_vid_scan g1
     set g1.active_date_key =
         (select MIN(k1.create_date_key)
            from fact_visitor_register k1
           where k1.vid = g1.vid)
   where g1.scan_date_key = startpoint;

  commit;

  update dim_vid_scan l2
     set l2.is_new = 1
   where l2.scan_date_key = startpoint
     and l2.scan_date_key = l2.active_date_key;
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
end processvidscan;
/

