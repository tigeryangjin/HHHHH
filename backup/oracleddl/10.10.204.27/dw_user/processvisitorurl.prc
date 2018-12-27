???create or replace procedure dw_user.processvisitorurl is
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
  sp_name          := 'processvisitorurl'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_visitor_active'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_visitor_active%rowtype index by binary_integer; --类似二维数组 
    -- a_key     number;
    -- hm        varchar2(20);
    -- d_key     number;
    --minid     number;
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from  fact_visitor_active e
     where e.active_date_key = 20160406  and (e.plan like '%品牌%' or  e.plan like '%移动%'
     or  e.plan like '%pinpaicijihua%')
     and e.plan!='unknown'
     ; --to_number(to_char((sysdate - 1), 'yyyymmdd'));
  
    for i in 1 .. var_array.count loop
      begin
        update fact_visitor_active ll
           set ll.plan = form_url_encode(ll.plan, 'UTF8')
              -- ll.plan    = form_url_encode(ll.plan, 'UTF8'),
               --ll.adgroup = form_url_encode(ll.adgroup, 'UTF8')
         where ll.vid = var_array(i).vid
           and ll.active_date_key = 20160406;
      
    --  utl_url.unescape(e.keyword,'UTF8')
      
        /* update fact_visitor_active g
          set g.keyword = utl_url.unescape(g.keyword, 'UTF-8'),
              g.adgroup = utl_url.unescape(g.adgroup, 'UTF-8'),
              g.plan    = utl_url.unescape(g.plan, 'UTF-8')
        where g.visitor_key = var_array(i).visitor_key
          and g.active_date_key = to_number(to_char((sysdate - 1), 'yyyymmdd'));*/
      
      exception
        when others then
          sp_sbi_w_etl_log(s_etl);
      end;
    
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
  
end processvisitorurl;
/

