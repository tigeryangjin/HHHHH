???create or replace procedure dw_user.processvisitor_active(startpoint in w_active_num.id%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- startpoint  fact_page_view.id%type;
  --endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processvisitor_active'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_visitor_active'; --此处需要手工录入该PROCEDURE操作的表格
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

  /* select id
  into startpoint
  from W_ACTIVE_NUM;*/

  declare
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
    --p_key number;
    -- etime date;
    --mid number;
    -- minid number;
    var_array type_array;
  
  begin
  
    select *
      bulk collect
      into var_array
      from fact_page_view e
     where e.id between startpoint and startpoint + 5000
       and e.device_key != 0;
  
    for i in 1 .. var_array.count loop
    
      insert into fact_visitor_active
      
        (visitor_key,
         vid,
         ip,
         application_key,
         application_name,
         active_date_key,
         active_hour_key,
         active_date,
         level1,
         level2,
         os,
         ver_key,
         ver_name,
         url,
         plan,
         keyword,
         adgroup,
         MEMBER_KEY)
      
        select d2.device_key,
               d2.vid,
               d2.ip,
               d2.application_key,
               d2.application_name,
               d2.visit_date_key,
               d2.visit_hour_key,
               d2.visit_date,
               d2.level1,
               d2.level2,
               d2.os,
               d2.ver_key,
               d2.ver_name,
               d2.url,
               d2.plan,
               d2.keyword,
               d2.adgroup,
               d2.member_key
          from (select d1.device_key,
                       d1.vid,
                       d1.ip,
                       d1.application_key,
                       d1.application_name,
                       d1.visit_date_key,
                       d1.visit_date,
                       d1.visit_hour_key,
                       nvl(case
                             when d1.application_key in (10, 20) then
                              (select x.hmmd from dim_hmsc x where x.hmsc = d1.hmsc)
                             else
                              nvl((select distinct d3.level1
                                    from dim_promotion d3
                                   where d3.keyword = case
                                           when regexp_instr(d1.url, '&') > 0 and
                                                get_str_count(nvl(substr(d1.url, 1, instr(d1.url, '&')), 'unkown')) < 2 then
                                            regexp_substr(regexp_substr(d1.url, '[^?]+', 1, 2), '[^&]+', 1, 1)
                                           when regexp_instr(d1.url, ';') > 0 and
                                                get_str_count(nvl(substr(d1.url, 1, instr(d1.url, ';')), 'unkown')) < 2
                                           
                                            then
                                            regexp_substr(regexp_substr(d1.url, '[^?]+', 1, 2), '[^;]+', 1, 1)
                                         
                                           when regexp_instr(d1.url, '&') > 0 and
                                                get_str_count(nvl(substr(d1.url, 1, instr(d1.url, '&')), 'unkown')) >= 2 then
                                            regexp_substr(regexp_substr(d1.url, '[^?]+', 2, 3), '[^&]+', 1, 1)
                                         
                                           when regexp_instr(d1.url, ';') > 0 and
                                                get_str_count(nvl(substr(d1.url, 1, instr(d1.url, ';')), 'unkown')) >= 2
                                           
                                            then
                                           
                                            regexp_substr(regexp_substr(d1.url, '[^?]+', 2, 3), '[^;]+', 1, 1)
                                         
                                           else
                                            regexp_substr(regexp_substr(d1.url, '[^?]+', 1, 2), '[^&]+', 1, 1)
                                         end),
                                  'unknown')
                           end,
                           'unknown') as level1,
                       case
                         when d1.application_key in (10, 20) then
                          'unknown'
                         else
                          nvl((select distinct d3.level2
                                from dim_promotion d3
                               where d3.keyword = case
                                       when regexp_instr(d1.url, '&') > 0 and
                                            get_str_count(nvl(substr(d1.url, 1, instr(d1.url, '&')), 'unkown')) < 2
                                       
                                        then
                                        regexp_substr(regexp_substr(d1.url, '[^?]+', 1, 2), '[^&]+', 1, 1)
                                       when regexp_instr(d1.url, ';') > 0 and
                                            get_str_count(nvl(substr(d1.url, 1, instr(d1.url, ';')), 'unkown')) < 2
                                       
                                        then
                                        regexp_substr(regexp_substr(d1.url, '[^?]+', 1, 2), '[^;]+', 1, 1)
                                     
                                       when regexp_instr(d1.url, '&') > 0 and
                                            get_str_count(nvl(substr(d1.url, 1, instr(d1.url, '&')), 'unkown')) >= 2 then
                                        regexp_substr(regexp_substr(d1.url, '[^?]+', 2, 3), '[^&]+', 1, 1)
                                     
                                       when regexp_instr(d1.url, ';') > 0 and
                                            get_str_count(nvl(substr(d1.url, 1, instr(d1.url, ';')), 'unkown')) >= 2
                                       
                                        then
                                       
                                        regexp_substr(regexp_substr(d1.url, '[^?]+', 2, 3), '[^;]+', 1, 1)
                                     
                                       else
                                        regexp_substr(regexp_substr(d1.url, '[^?]+', 1, 2), '[^&]+', 1, 1)
                                     end),
                              'unknown')
                       end as level2,
                       case
                         when regexp_instr(d1.agent, 'Windows') != 0 then
                          'Windows'
                         when regexp_instr(d1.agent, 'iPhone') != 0 then
                          'IOS'
                         when regexp_instr(d1.agent, 'Android') != 0 then
                          'Android'
                         when regexp_instr(d1.agent, 'Macintosh') != 0 then
                          'IOS'
                         when regexp_instr(d1.agent, 'iPad') != 0 then
                          'IOS'
                         when regexp_instr(d1.agent, 'Win32') != 0 then
                          'Windows'
                         when regexp_instr(d1.agent, 'spider') != 0 then
                          'spider'
                         when regexp_instr(d1.agent, 'Linux x86_64') != 0 then
                          'Linux'
                         else
                          'unknown'
                       end as os,
                       
                       case
                         when d1.application_key in (10, 20) then
                          d1.ver_key
                         else
                          -1
                       end as ver_key,
                       case
                         when d1.application_key in (10, 20) then
                          d1.ver_name
                         else
                          'unknown'
                       end as ver_name,
                       d1.url,
                       
                       /* case
                         when d1.application_key in (10, 20) then
                          'unknown'
                         else
                          decode(regexp_instr(url, 'utm_campain='),
                                 0,
                                 'unknown',
                                 (case
                                   when regexp_instr(substr(url,
                                                            regexp_instr(url, 'utm_campain=') + 12,
                                                            length(url)),
                                                     '&') > 0 then
                                    regexp_substr(substr(url,
                                                         regexp_instr(url, 'utm_campain=') + 12,
                                                         length(url)),
                                                  '[^&]+',
                                                  1,
                                                  1)
                                   else
                                    regexp_substr(substr(url,
                                                         regexp_instr(url, 'utm_campain=') + 12,
                                                         length(url)),
                                                  '[^;]+',
                                                  1,
                                                  1)
                                 end))
                       end as plan,*/
                       /*plan*/
                       case
                         when d1.application_key in (10, 20) then
                          'unknown'
                         when regexp_instr(url, 'utm_campain=') != 0 then
                          regexp_substr(substr(url,
                                               regexp_instr(url, 'utm_campain=') + 12,
                                               length(url)),
                                        '[^;&]+',
                                        1,
                                        1)
                       
                         when regexp_instr(url, 'utm_campaign=') != 0 then
                          regexp_substr(substr(url,
                                               regexp_instr(url, 'utm_campaign=') + 13,
                                               length(url)),
                                        '[^;&]+',
                                        1,
                                        1)
                         else
                          'unknown'
                       end as plan,
                       /*keyword*/
                       case
                         when d1.application_key in (10, 20) then
                          'unknown'
                         else
                          decode(regexp_instr(url, 'utm_term='),
                                 0,
                                 'unknown',
                                 regexp_substr(substr(url,
                                                      regexp_instr(url, 'utm_term=') + 9,
                                                      length(url)),
                                               '[^;&]+',
                                               1,
                                               1))
                       end as keyword,
                       /*adgroup*/
                       case
                         when d1.application_key in (10, 20) then
                          'unknown'
                         else
                          decode(regexp_instr(d1.url, 'utm_adgroup='),
                                 0,
                                 'unknown',
                                 regexp_substr(substr(d1.url,
                                                      regexp_instr(d1.url, 'utm_adgroup=') + 12,
                                                      length(d1.url)),
                                               '[^;&]+',
                                               1,
                                               1))
                       end as adgroup,
                       d1.member_key
                  from fact_page_view d1
                 where d1.id = var_array(i).id) d2
         where not exists
         (select *
                  from fact_visitor_active d3
                 where d3.visitor_key = d2.device_key
                      and d3.application_key = d2.application_key
                      and d3.level1 = d2.level1
                   and d3.active_date_key = d2.visit_date_key);
    
      update w_active_num set id = var_array(i).id + 1;
    
      commit;
    
    end loop;
    commit;
    insert_rows := var_array.count;
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
  
end processvisitor_active;
/

