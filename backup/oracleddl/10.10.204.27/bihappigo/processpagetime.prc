???create or replace procedure bihappigo.processpagetime is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processpagetime'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view'; --此处需要手工录入该PROCEDURE操作的表格
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

  --select min(a.id) into startpoint from fact_page_view a where a.flag = 0;

  -- select max(a.id) into endpoint from fact_page_view a where a.flag = 0;

  declare
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
    p_key number;
    --ptimekey number;
    etime date;
  
    var_array type_array;
  begin
  
    select  * bulk collect
      into var_array
      from fact_page_view
     where id between 1300240 and 1500240;
  
  
  
    for i in 1 .. var_array.count loop
    
      select /*+ index(z) rule*/
       z.page_key
        into p_key
        from fact_page_view z
       where z.id =nvl((select/*+ index(a) rule*/ max(a.id)
                  from fact_page_view a
                  where a.id < var_array(i).id
                    and a.application_key = var_array(i).application_key
                    and a.visitor_key = var_array(i).visitor_key),
                 var_array(i).id);
    
      select /*+ index(h) rule*/ min(h.visit_date)
        into etime
        from fact_page_view h
       where h.id > var_array(i).id
         and h.application_key = var_array(i).application_key
         and h.visitor_key = var_array(i).visitor_key
         and h.visit_date < var_array(i).visit_date + 600 / 86400;
    
     update /*+ index(s) rule*/ fact_page_view s
       set s.last_page_key =p_key,
           s.pageend_time=nvl(etime, s.visit_date + 600 / 86400),
           s.page_staytime = case
                                 when ((nvl(etime, s.visit_date + 600 / 86400) -
                                      s.visit_date) * 24 * 60 * 60) between 0 and 599 then
                                  ((nvl(etime, s.visit_date + 600 / 86400) -
                                  s.visit_date) * 24 * 60 * 60)
                                 else
                                  600
                               end
      
       where id = var_array(i).id;
    
     -- if mod(i, 1000) = 0 then
     --   commit;
     -- end if;
    
    end loop;
    commit;
  
     update /*+ index(z) rule*/ fact_page_view z
      set z.page_staytime_key =
          (select y.pagestaytimekey
             from dim_pagestaytime y
            where y.mintime <= z.page_staytime
              and y.maxtime >= z.page_staytime)
    where
    z.id  between 1300240 and 1500240;
  
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
  
end processpagetime;
/

