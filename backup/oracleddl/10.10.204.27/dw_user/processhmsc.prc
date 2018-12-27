???create or replace procedure dw_user.processhmsc is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  startpoint  fact_page_view.id%type;
  endpoint    fact_page_view.id%type;

begin

  sp_name          := 'processhmsc'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_hmsc'; --此处需要手工录入该PROCEDURE操作的表格
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

  select min(a.id)
    into startpoint
    from fact_page_view a
   where a.hmsc_key = 0
     and a.visit_date_key= to_number(to_char(sysdate-1,'yyyymmdd'))
     and a.hmsc is not null;

  select max(a.id)
    into endpoint
    from fact_page_view a
   where a.hmsc_key = 0
     and a.visit_date_key= to_number(to_char(sysdate-1,'yyyymmdd'))
      and a.hmsc is not null;

  declare
  
    v_count number;
  begin
    select count(a.hmsc_key)
      into v_count
      from fact_page_view a
     where a.id between startpoint and endpoint
       and a.hmsc is not null
       and not exists
     (select * from dim_hmsc b where b.hmsc = a.hmsc);
  
  
  
    if v_count > 0 then
      insert into dim_hmsc
        (id,hmsc_key, hmsc, hmmd,insert_date,hmpl)
      
        select w_hmsc_d_s.nextval, w_hmsc_d_s.nextval,c.hmsc, nvl(c.hmmd,c.hmsc),sysdate,'推广'
          from (select distinct a.hmsc,a.hmmd --, a.hmpl, a.hmkw, a.hmci
                  from fact_page_view a
                 where a.id between startpoint and endpoint
                   and a.hmsc is not null
                   and not exists
                 (select * from dim_hmsc b where b.hmsc = a.hmsc)) c;
    
      insert_rows := sql%rowcount;
    
      commit;
    else
    
      insert_rows := 0;
    end if;
  
  end;

  update fact_page_view d
     set d.hmsc_key =
         (select distinct e.hmsc_key from dim_hmsc e where e.hmsc = d.hmsc)
   where d.id between startpoint and endpoint
     and d.hmsc is not null;
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
  
end processhmsc;
/

