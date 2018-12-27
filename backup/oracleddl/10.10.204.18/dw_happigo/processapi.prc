???create or replace procedure dw_happigo.processapi(startpoint in fact_requestlog.logid%type,
                                       endpoint   in fact_requestlog.logid%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       (startpoint in ods_pageview.id%type,
                                               endpoint   in ods_pageview.id%type)
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processapi'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_request'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_request
    (id,
     objectgroupkey,
     objectkey,
     objectname,
     serverkey,
     responsecode,
     logtypekey,
     response,
     request,
     applicationkey,
     vid,
     ip,
     logid,
     logtime,
     logdatekey,
     loghourkey,
     logminutekey,
     createtime)
  
    select api_s.nextval as id,
           10 as objectgroupkey,
           0 as objectkey,
           regexp_substr(resources, '[^/]+', 1, 1) || '/' ||
           regexp_substr(resources, '[^/]+', 1, 2) || '.' || method as objectname,
           '0' as serverkey,
           nvl(f_getexecuteresult(excuteresult), 0) as responsecode,
           10 as logtypekey,
           --cc.excuteresult as response,
           cc.excuteresult ||
           nvl(regexp_substr(cc.resources, '[^/]+', 1, 3), '&') as response,
           cc.authparams || ' ^authparams-end^ ' || cc.fromparams ||
           ' ^fromparams-end^ ' || cc.querryparmas as request,
           nvl(to_char(case
                         when regexp_instr(fromparams, '\appname') > 0 then
                          regexp_substr(substr(fromparams,
                                               regexp_instr(fromparams, '\appname') + 8,
                                               length(fromparams)),
                                        '[^&]+',
                                        1,
                                        1)
                         else
                          null
                       end),
               'unknown') as applicationkey,
           nvl(to_char(case
                         when regexp_instr(fromparams, '\VID') > 0 then
                          regexp_substr(substr(fromparams,
                                               regexp_instr(fromparams, '\VID') + 4,
                                               length(fromparams)),
                                        '[^&]+',
                                        1,
                                        1)
                         else
                          null
                       end),
               'unknown') as vid,
           cc.ip,
           cc.logid,
           cc.logat as logtime,
           to_number(to_char(cc.logat, 'yyyymmdd')) as logdatekey,
           (select y.hour_key
              from dim_hour y
             where y.start_value = to_number(to_char(cc.logat, 'hh24'))) as loghourkey,
           (select t.minute_key
              from dim_minute t
             where t.start_value = to_number(to_char(cc.logat, 'mi'))) as logminutekey,
           sysdate as createtime
      from fact_requestlog cc
     where cc.logid between startpoint and endpoint; --  cc.flag=0;
  --13632600 13632600 13673194 13673194
  --10264599
  --8264596  8264596
  insert_rows := sql%rowcount;
  commit;

  update fact_requestlog
     set flag = 1
   where logid between startpoint and endpoint; --flag=0;

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
end processapi;
/

