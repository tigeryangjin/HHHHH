???create or replace procedure bihappigo.sp_sbi_visitor_f is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  s_startpoint fact_session.id%type;
  s_endpoint   fact_session.id%type;
  p_startpoint fact_page_view.id%type;
  p_endpoint   fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'SP_SBI_VISITOR_F'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'W_VISITOR_F'; --此处需要手工录入该PROCEDURE操作的表格
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

  select min(a.id) into s_startpoint from fact_session a where a.flag = 0;
  select max(a.id) into s_endpoint from fact_session a where a.flag = 0;
  select min(a.id) into p_startpoint from fact_page_view a where a.flag = 0;
  select max(a.id) into p_endpoint from fact_page_view a where a.flag = 0;

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
         hmsr_key,
         application_key,
         device_key,
         member_key,
         create_date_key,
         create_date)
         
         
         
      
        select w_visitor_f_s.nextval,
               w_visitor_f_s.nextval,
               e.vid,
               e.fist_ip,
               e.hmsr_key,
               e.application_key,
               e.device_key,
               e.member_key,
               e.create_date_key,
               e.create_date
          from (select distinct p2.vid,
                p2.fist_ip,
                p2.hmsr_key,
                p2.application_key,
                p2.device_key,
                p2.member_key,
                to_number(to_char(sysdate, 'yyyymmdd')) as create_date_key,
                sysdate as create_date
  from (select l.vid, min(l.id) as minid from fact_session l
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
  
    update /*+ index(hh) rule*/ fact_page_view hh
       set hh.visitor_key =
           (select /*+ index(k) rule*/
             k.visitor_key
              from fact_visitor k
             where k.vid = hh.vid)
     where hh.id between p_startpoint and p_endpoint;
  
    update /*+ index(aa) rule*/ fact_session aa
       set aa.visitor_key =
           (select /*+ index(k) rule*/
             k.visitor_key
              from fact_visitor k
             where k.vid = aa.vid)
     where aa.id between s_startpoint and s_endpoint;
  
    update fact_session
       set flag = 1
     where id between s_startpoint and s_endpoint;
    update fact_page_view
       set flag = 1
     where id between p_startpoint and p_endpoint;
  
    update process_flag j
       set j.start_point = s_startpoint, j.end_point = s_endpoint
     where j.flag_name = 'fact_session';
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
  
end sp_sbi_visitor_f;
/

