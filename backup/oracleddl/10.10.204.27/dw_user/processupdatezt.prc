???create or replace procedure dw_user.processupdatezt(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processupdatezt'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_cms_zt'; --此处需要手工录入该PROCEDURE操作的表格
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

  update fact_cms_zt d1
     set d1.zt_id = case
                      when url like '%restapi.happigo.com/pages/zt%' then
                       to_number(substr((regexp_substr(regexp_substr(d1.url,
                                                                     '[^?]+',
                                                                     1,
                                                                     2),
                                                       '[^&]+',
                                                       1,
                                                       1)),
                                        4,
                                        length((regexp_substr(regexp_substr(d1.url,
                                                                            '[^?]+',
                                                                            1,
                                                                            2),
                                                              '[^&]+',
                                                              1,
                                                              1)))))
                      when url like '%3g.happigo.com/spdy.php%' then
                       to_number(substr((regexp_substr(regexp_substr(d1.url,
                                                                     '[^?]+',
                                                                     1,
                                                                     2),
                                                       '[^&]+',
                                                       1,
                                                       1)),
                                        5,
                                        length((regexp_substr(regexp_substr(d1.url,
                                                                            '[^?]+',
                                                                            1,
                                                                            2),
                                                              '[^&]+',
                                                              1,
                                                              1)))))
                      when url like '%3g.happigo.com/default.php%' then
                       to_number(substr((regexp_substr(regexp_substr(d1.url,
                                                                     '[^?]+',
                                                                     1,
                                                                     2),
                                                       '[^&]+',
                                                       2,
                                                       3)),
                                        7,
                                        length(regexp_substr(regexp_substr(d1.url,
                                                                           '[^?]+',
                                                                           1,
                                                                           2),
                                                             '[^&]+',
                                                             2,
                                                             3))))
                      else
                       id
                    end
   where d1.timestamp = startpoint;

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
end processupdatezt;
/

