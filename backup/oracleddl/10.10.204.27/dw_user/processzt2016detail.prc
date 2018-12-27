???create or replace procedure dw_user.processzt2016detail is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  number;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processzt2016detail'; --需要手工填入所写PROCEDURE的名称
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
    --s_key     number;
    --p_value     number;
    -- p_vid     VARCHAR2(1000);
    -- etime     date
    -- minid     number;
    var_array type_array;
    -- 153659425 and  154616681 154459428 154699781
  begin
    
  
    select * bulk collect
      into var_array
      from fact_page_view
     where visit_date_key =20160622
       and page_key in (36868,36909)
       and page_value != 'undefined';
  
    for i in 1 .. var_array.count loop
    
      insert into fact_ztgoods2016
      
        (goods_code, session_key, vid, visit_date)
        select 
               
               to_number(case
                       when regexp_like(a1.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(a1.page_value, '[[:punct:]]+') then
                        '0'
                       when a1.page_value is null then
                        '0'
                       when a1.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(a1.page_value, '\s', '')
                     end),
                     
              -- to_number(a1.page_value),
               a1.session_key,
               a1.vid,
               a1.visit_date
          from fact_page_view a1
         where a1.session_key = var_array(i).session_key
           and a1.visit_date >= var_array(i).visit_date
           and a1.visit_date <= var_array(i).visit_date + 300 / 86400
           and a1.page_key in (2841, 1924, 6604, 6391)
           and a1.page_value in
('128645',
'140587',
'136160',
'138461',
'140166',
'139175',
'138165',
'140358',
'139362',
'140546',
'139737',
'140124',
'139032');
       
        
       
      commit;
    
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
  
end processzt2016detail;
/

