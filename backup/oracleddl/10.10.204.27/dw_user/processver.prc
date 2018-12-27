???create or replace procedure dw_user.processver(startpoint in fact_page_view.id%type,
                                       endpoint   in fact_page_view.id%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  fact_page_view.id%type;
  --endpoint    fact_page_view.id%type;

begin

  sp_name          := 'processver'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_ver'; --此处需要手工录入该PROCEDURE操作的表格
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

  /*  select min(a.id)
    into startpoint
    from fact_page_view a
   where a.ver_key = 0;
  
  select max(a.id)
    into endpoint
    from fact_page_view a
   where a.ver_key = 0;*/

  declare
  
    v_count number;
  begin
    select count(a.ver_key)
      into v_count
      from fact_page_view a
     where a.id between startpoint and endpoint
       and a.application_key <> 0
       and not exists
     (select 1
              from dim_ver b
             where b.ver_name = a.ver_name
               and b.application_key = a.application_key);
  
    if v_count > 0
    then
      insert into dim_ver
        (id,
         ver_key,
         ver_name,
         application_key,
         application_name,
         insert_date)
      
        select w_ver_s.nextval,
               w_ver_s.nextval,
               c.ver_name,
               c.application_key,
               c.application_name,
               c.insert_date
          from (select distinct a.ver_name,
                                a.application_key,
                                a.application_name,
                                sysdate as insert_date
                  from fact_page_view a
                 where a.id between startpoint and endpoint
                   and not exists
                 (select *
                          from dim_ver b
                         where b.ver_name = a.ver_name
                           and b.application_key = a.application_key)) c;
    
      insert_rows := sql%rowcount;
    
      commit;
    else
    
      insert_rows := 0;
    end if;
  
  end;

  update fact_page_view d
     set d.ver_key =
         (select distinct e.ver_key
            from dim_ver e
           where e.ver_name = d.ver_name
             and e.application_key = d.application_key)
   where d.id between startpoint and endpoint;
  commit;

  update fact_session d
     set d.ver_key =
         (select distinct e.ver_key
            from dim_ver e
           where e.ver_name = d.ver_name
             and e.application_key = d.application_key)
   where d.ver_key = 0;

  commit;

  update FACT_VISITOR_REGISTER d
     set d.ver_key =
         (select distinct e.ver_key
            from dim_ver e
           where e.ver_name = d.ver_name
             and e.application_key = d.application_key)
   where d.ver_key = 0;
  commit;

  /* update fact_visitor d
  set d.ver_key =
      (select distinct e.ver_key
         from dim_ver e
        where e.ver_name = d.ver_name
          and e.application_key = d.application_key)
          where d.ver_key=0;
       commit;   */

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
  
end processver;
/

