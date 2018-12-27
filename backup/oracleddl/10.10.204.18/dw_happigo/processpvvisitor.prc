???create or replace procedure dw_happigo.processpvvisitor(s_startpoint in fact_session.id%type,
                                             s_endpoint   in fact_session.id%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- s_startpoint fact_session.id%type;
  --s_endpoint   fact_session.id%type;
  p_startpoint fact_page_view.id%type;
  p_endpoint   fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processpvvisitor'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_visitor'; --此处需要手工录入该PROCEDURE操作的表格
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
  --select min(a.id) into s_startpoint from fact_session a where a.Visitor_Key = 0;
  --select max(a.id) into s_endpoint from fact_session a where a.Visitor_Key = 0;

  select min(a.id)
    into p_startpoint
    from fact_page_view a
   where a.visitor_key = 0;
  select max(a.id)
    into p_endpoint
    from fact_page_view a
   where a.visitor_key = 0;

  declare
  
    v_count number;
  
  begin
  
    select count(a.vid)
      into v_count
      from fact_session a
     where a.id between s_startpoint and s_endpoint
       and not exists
     (select * from fact_visitor b where b.vid = a.vid);
  
    if v_count > 0 then
      insert into fact_visitor
        (id,
         visitor_key,
         vid,
         first_ip,
         hmsc_key,
         hmsc,
         application_key,
         member_key,
         create_date_key,
         create_date,
         hour,
         channel_key,
         ver_key,
         ver_name,
         agent)
      
        select w_visitor_f_s.nextval,
               w_visitor_f_s.nextval,
               e.vid,
               e.fist_ip,
               e.hmsc_key,
               e.hmsc,
               e.application_key,
               e.member_key,
               e.create_date_key,
               e.create_date,
               e.hour,
               e.channel_key,
               e.ver_key,
               e.ver_name,
               e.agent
          from (select p2.vid,
                       p2.fist_ip,
                       p2.hmsc_key,
                       p2.hmsc,
                       p2.application_key,
                       p2.member_key,
                       to_number(to_char(p2.start_time, 'yyyymmdd')) as create_date_key,
                       p2.start_time as create_date,
                       to_number(to_char(p2.start_time, 'HH24')) as hour,
                       p2.channel_key,
                       p2.ver_key,
                       p2.ver_name,
                       p2.agent
                  from (select l.vid, min(l.id) as minid
                          from fact_session l
                         where l.id between s_startpoint and s_endpoint
                         group by l.vid) p1,
                       fact_session p2
                 where p1.vid = p2.vid
                   and p1.minid = p2.id
                   and p2.id between s_startpoint and s_endpoint
                   and not exists
                 (select * from fact_visitor b where b.vid = p2.vid)) e;
    
      insert_rows := sql%rowcount;
    
      commit;
    else
      insert_rows := 0;
    end if;
  
    update fact_page_view hh
       set hh.visitor_key =
           (select k.visitor_key from fact_visitor k where k.vid = hh.vid)
     where hh.id between p_startpoint and p_endpoint;
  
    update fact_session aa
       set aa.visitor_key =
           (select k.visitor_key from fact_visitor k where k.vid = aa.vid)
     where aa.id between s_startpoint and s_endpoint;
  
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
  
end processpvvisitor;
/

