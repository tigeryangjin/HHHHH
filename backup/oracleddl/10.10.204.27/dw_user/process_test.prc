???create or replace procedure dw_user.process_test is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'process_test'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'test0718'; --此处需要手工录入该PROCEDURE操作的表格
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
  --= '00000000';

delete from test0718;
commit;

  declare
  
    type type_array is table of fact_page_view_ck%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    --minday    number;
    --maxday    number;
    --daycount  number;
    --timecount number;
  
  begin
  
    select * bulk collect
      into var_array
      from fact_page_view_ck j1
     order by j1.id asc;
  
    for i in 1 .. var_array.count loop
    
      insert into test0718
      values
        (var_array(i).id,
         to_number(case
                     when regexp_like(var_array(i).page_value, '.([a-z]+|[A-Z])') then
                      '0'
                     when regexp_like(var_array(i).page_value, '[[:punct:]]+') then
                      '0'
                     when regexp_like(var_array(i).page_value, '[^x00-xff]') then
                      '0'
                     when var_array(i).page_value is null then
                      '0'
                     when var_array(i).page_value like '%null%' then
                      '0'
                   
                     else
                      regexp_replace(var_array(i).page_value, '\s', '')
                   end)
         
         );
      
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
end process_test;
/

