???create or replace procedure dw_user.processgdrealtime is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- s_startpoint fact_session.id%type;
  --s_endpoint   fact_session.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processgdrealtime'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'STATS_ONLINE_GOOD_MINUTE'; --此处需要手工录入该PROCEDURE操作的表格
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
  --select min(a.id) into s_startpoint from fact_session a where a.Visitor_Key = 0;
  --select max(a.id) into s_endpoint from fact_session a where a.Visitor_Key = 0;
  --select  to_char(to_date('2015-09-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')+1/24/60,'yyyy-mm-dd hh24:mi' ) from dual

  declare
    i  date;
    i1 number;
  
  begin
  
    SELECT NVL(A.END_TIME,
               TO_DATE('2016-07-19 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
      INTO I
      FROM STATS_ONLINE_GOOD_MINUTE A
     WHERE EXISTS
     (SELECT 1
              FROM (SELECT MAX(C.ID) ID FROM STATS_ONLINE_GOOD_MINUTE C) B
             WHERE A.ID = B.ID);
  
    select nvl(to_number(to_char(max(e.visit_date), 'yyyymmddhh24miss')),
               20160719000000)
      into i1
      from fact_page_view e
     where e.visit_date_key = to_number(to_char(sysdate, 'yyyymmdd'))
       and e.page_key in (1924, 2841, 24146, 11586, 355, 38629)
       and e.ip_geo_key != 0;
  
    loop
    
      exit when to_number(to_char(i + 10 / 24 / 60, 'yyyymmddhh24miss')) >= i1;
    
      insert into stats_online_good_minute
        (id,
         statdate,
         stathour,
         statminute,
         start_time,
         end_time,
         application_key,
         application_name,
         good_code,
         good_name,
         pv,
         uv,
         rangepv,
         rangeuv)
      
        select w_statgd1_d_s.nextval as id,
               to_number(to_char(i + 10 / 24 / 60, 'yyyymmdd')) as statdate,
               to_number(to_char(i + 10 / 24 / 60, 'hh24')) as stathour,
               to_number(to_char(i + 10 / 24 / 60, 'mi')) as statminute,
               
               to_date(to_char(i, 'yyyy-mm-dd hh24:mi'),
                       'yyyy-mm-dd hh24:mi:ss') as start_time,
               to_date(to_char(i + 10 / 24 / 60, 'yyyy-mm-dd hh24:mi'),
                       'yyyy-mm-dd hh24:mi:ss') as end_time,
               
               x1.application_key,
               x1.application_name,
               /*(select j.item_code
                from dim_ec_good j
               where j.goods_commonid = to_number(case
                                                    when regexp_like(x1.page_value, '.([a-z]+|[A-Z])') then
                                                     '0'
                                                    when regexp_like(x1.page_value, '[[:punct:]]+') then
                                                     '0'
                                                  -- when regexp_like(x1.page_value, '[\u4e00-\u9fa5]+') then
                                                  --  '0'
                                                    when x1.page_value is null then
                                                     '0'
                                                    when x1.page_value like '%null%' then
                                                     '0'
                                                    else
                                                     regexp_replace(x1.page_value, '\s', '')
                                                  end)) as good_code,*/
               (select j.item_code
                  from dim_ec_good j
                 where j.goods_commonid = to_number(x1.page_value)) as good_code,
               
               /*(select j.goods_name
                from dim_ec_good j
               where j.goods_commonid = to_number(case
                                                    when regexp_like(x1.page_value, '.([a-z]+|[A-Z])') then
                                                     '0'
                                                    when regexp_like(x1.page_value, '[[:punct:]]+') then
                                                     '0'
                                                  -- when regexp_like(x1.page_value, '[\u4e00-\u9fa5]+') then
                                                  --  '0'
                                                    when x1.page_value is null then
                                                     '0'
                                                    when x1.page_value like '%null%' then
                                                     '0'
                                                    else
                                                     regexp_replace(x1.page_value, '\s', '')
                                                  end)) as good_name,*/
               (select j.goods_name
                  from dim_ec_good j
                 where j.goods_commonid = to_number(x1.page_value)) as good_name,
               
               x1.rangepv,
               x1.rangeuv,
               x2.pv,
               x2.uv
          from (select n.application_key,
                       n.application_name,
                       --n.page_value,
                       /*剔除非数字字符 by yangjin 2018-09-05*/
                       translate(n.page_value,
                                 '0' ||
                                 translate(n.page_value, '#0123456789', '#'),
                                 '0') page_value,
                       count(vid) as rangepv,
                       count(distinct vid) as rangeuv
                  from fact_page_view n
                 where n.page_key in (1924, 2841, 24146, 11586, 355, 38629)
                   and n.visit_date >= i
                   and n.visit_date < i + 10 / 24 / 60
                   and n.ip_geo_key != 0
                 group by n.application_key,
                          n.application_name,
                          n.page_value) x1,
               
               (select n.application_key,
                       n.application_name,
                       --n.page_value,
                       /*剔除非数字字符 by yangjin 2018-09-05*/
                       translate(n.page_value,
                                 '0' ||
                                 translate(n.page_value, '#0123456789', '#'),
                                 '0') page_value,
                       nvl(count(vid), 0) as pv,
                       nvl(count(distinct vid), 0) as uv
                  from fact_page_view n
                 where n.page_key in (1924, 2841, 24146, 11586, 355, 38629)
                   and n.visit_date >= trunc(sysdate) -- to_date(i, 'yyyy-mm-dd')
                   and n.visit_date < i + 10 / 24 / 60
                   and n.ip_geo_key != 0
                 group by n.application_key,
                          n.application_name,
                          n.page_value) x2
         where x1.application_name = x2.application_name
           and x1.application_key = x2.application_key
           and x1.page_value = x2.page_value;
    
      commit;
    
      i := i + 10 / 24 / 60;
    
    end loop;
  
  end;

  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.err_msg        := '无参数';
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
  
end processgdrealtime;
/

