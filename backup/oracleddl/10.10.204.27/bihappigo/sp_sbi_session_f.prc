???create or replace procedure bihappigo.sp_sbi_session_f is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  startpoint  fact_page_view.id%type;
  endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'SP_SBI_SESSION_F'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'W_SESSION_F'; --此处需要手工录入该PROCEDURE操作的表格
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

--448998
--459000

  select min(a.id) into startpoint from fact_page_view a where a.flag = 0;

  select max(a.id) into endpoint from fact_page_view a where a.flag = 0;

  declare
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
    s_key     number;
  
  begin
  
    select * bulk collect
      into var_array
      from fact_page_view
     where id between startpoint and endpoint
     order by id;
  
    for i in 1 .. var_array.count loop
    
      select count(b.session_key)
        into s_key
        from fact_session b
       where b.vid = var_array(i).vid
         and b.end_date > var_array(i).visit_date - 1800 / 86400;
    
      if s_key = 0 then
        insert into fact_session
          (id,
           session_key,
           start_date,
           end_date,
           page_count,
           start_page_key,
           left_page_key,
           fist_ip,
           vid,
           member_key,
           application_key,
           device_key,
           hmsr_key)
          select w_session_f_s.nextval,
                 w_session_f_s.nextval,
                 var_array            (i).visit_date,
                 var_array            (i).visit_date + 10 / 86400,
                 1,
                 var_array            (i).page_key,
                 var_array            (i).page_key,
                 var_array            (i).ip,
                 var_array            (i).vid,
                 var_array            (i).member_key,
                 var_array            (i).application_key,
                 var_array            (i).device_key,
                 var_array            (i).hmsr_key
            from dual;
      
        select w_session_f_s.currval into s_key from dual;
        update fact_page_view s
           set session_key = s_key
         where id = var_array(i).id;
         
      commit;
      else
        select distinct b.session_key
          into s_key
          from fact_session b
         where b.vid = var_array(i).vid
           and b.end_date > var_array(i).visit_date - 1800 / 86400;
      
        update fact_page_view
           set session_key = s_key
        
         where id = var_array(i).id;
      
        update fact_session
           set end_date      = var_array(i).visit_date + 10 / 86400,
               page_count    = page_count + 1,
               left_page_key = var_array(i).page_key,
               member_key    = var_array(i).member_key
         where session_key = s_key;
         commit;
      end if;
    
    end loop;
  
   /*update fact_page_view
       set flag = 1
     where id between startpoint and endpoint
       and flag = 0;*/
       
       
     update process_flag j set j.start_point= start_point, j.end_point=end_point
 where j.flag_name='fact_page_view';
 
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
  
end sp_sbi_session_f;
/

