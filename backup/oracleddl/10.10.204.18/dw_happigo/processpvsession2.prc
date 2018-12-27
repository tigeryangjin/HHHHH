???create or replace procedure dw_happigo.processpvsession2  (startpoint in fact_page_view.id%type,
                                             endpoint   in fact_page_view.id%type) is
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
  sp_name          := 'processpvsession'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_session'; --此处需要手工录入该PROCEDURE操作的表格
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

  --select min(a.id) into startpoint from fact_page_view a where a.Session_Key = 0
  --and a.id>=233 and a.id<=1000233;

  --select max(a.id) into endpoint from fact_page_view a where a.Session_Key = 0
  --and a.id>=233 and a.id<=1000233;

  declare
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
    count_key number;
    s_key     number;
  
  begin
    s_key := 0;
    select * bulk collect
      into var_array
      from fact_page_view
     where id between startpoint and endpoint
     order by id;
  
 -- insert into TMP_LI3 values(1,'1');
  
    for i in 1 .. var_array.count loop
   
 -- insert into TMP_LI3 values(2,'2');
      select count(b.session_key)
        into count_key
        from fact_session b
       where b.vid = var_array(i).vid
         and b.end_time > var_array(i).visit_date - 1800 / 86400;
  
 -- insert into TMP_LI3 values(3,'3');  
  
      if count_key = 0 then
        insert into fact_session
          (id,
           session_key,
           start_time,
           end_time,
           page_count,
           start_page_key,
           left_page_key,
           start_date_key,
           end_date_key,
           hour,
           fist_ip,
           vid,
           member_key,
           application_key,
           channel_key,
           ver_key,
           ver_name,
           hmsc_key,
           hmsc,
           agent
           )
          select w_session_f_s.nextval,
                 w_session_f_s.nextval,
                 var_array(i).visit_date,
                 var_array(i).visit_date + 10 / 86400,
                 1,
                 var_array(i).page_key,
                 var_array(i).page_key,
                 to_number(to_char(var_array(i).visit_date, 'yyyymmdd')),
                 to_number(to_char((var_array(i).visit_date + 10 / 86400),
                                   'yyyymmdd')),
                 to_number(to_char(var_array(i).visit_date, 'hh24')),
                 var_array(i).ip,
                 var_array(i).vid,
                 var_array(i).member_key,
                 var_array(i).application_key,
                 var_array(i).channel_key,
                 var_array(i).ver_key,
                 var_array(i).ver_name,
                 var_array(i).hmsc_key,
                 var_array(i).hmsc,
                 var_array(i).agent                
            from dual;
    
--  insert into TMP_LI3 values(4,'4'); 
--  commit;   
        select w_session_f_s.currval into s_key from dual;
        update fact_page_view s
           set session_key = s_key
         where id = var_array(i).id;
      
        
 -- insert into TMP_LI3 values(5,'5');   
        commit;
        
        
      else
        select distinct b.session_key
          into s_key
          from fact_session b
         where b.vid = var_array(i).vid
           and b.end_time > var_array(i).visit_date - 1800 / 86400;
        update fact_page_view
           set session_key = s_key
        
         where id = var_array(i).id;
      
        update fact_session
           set end_time      = var_array(i).visit_date + 10 / 86400,
               end_date_key  = to_number(to_char((var_array(i)
                                                 .visit_date + 10 / 86400),
                                                 'yyyymmdd')),
               page_count    = page_count + 1,
               bonus_flag    = 1,
               left_page_key = var_array(i).page_key,
               member_key    = var_array(i).member_key
         where session_key = s_key;
        commit;
      end if;
    
    end loop;
  
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
  
end processpvsession2;
/

