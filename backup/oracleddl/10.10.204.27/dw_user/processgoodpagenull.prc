???create or replace procedure dw_user.processgoodpagenull is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processgoodpagenull'; --需要手工填入所写PROCEDURE的名称
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

  declare
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    g_id      number;
    gcid      number;
    gcname    varchar2(100);
    cnt       number;
  begin
  
    select * bulk collect
      into var_array
      from fact_page_view e
     where e.visit_date_key =to_number(to_char(sysdate-1, 'yyyymmdd'))
       and e.page_key in (1924, 2841, 24146, 11586, 355, 38629)
       and e.ip_geo_key = 0
     order by e.id;
  
    -- between 20160411 and 20160424;
  
    for i in 1 .. var_array.count loop
    
      select nvl(count(1), 0)
        into cnt
        from fact_page_view
       where session_key = var_array(i).session_key
         and visit_date <= var_array(i).visit_date
         and page_key in (select page_key from dim_page_gn);
    
      if cnt > 0 then
      
        select max(id)
          into g_id
          from fact_page_view
         where session_key = var_array(i).session_key
           and visit_date <= var_array(i).visit_date
           and page_key in (select page_key from dim_page_gn);
      
        select page_key into gcid from fact_page_view where id = g_id;
        select page_value into gcname from fact_page_view where id = g_id;
      
        update fact_page_view
           set ip_geo_key = gcid, hmci = gcname
         where id = var_array(i).id;
      
        commit;
      
      else
      
        update fact_page_view
           set ip_geo_key = -1, hmci = 'nopage'
         where id = var_array(i).id;
      
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
  
end processgoodpagenull;
/

