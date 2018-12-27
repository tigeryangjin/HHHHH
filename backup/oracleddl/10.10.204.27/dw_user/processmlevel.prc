???create or replace procedure dw_user.processmlevel(startpoint varchar) is
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
  sp_name          := 'processmlevel'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_member_register'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of ods_zbpartner%rowtype index by binary_integer; --类似二维数组
  
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from ods_zbpartner e
     where e.ch_on = startpoint;
  
    for i in 1 .. var_array.count loop
    
      update /*+ index(n MR_RDK) */ fact_member_register n
         set n.member_level = var_array(i).ztcmc016,
             n.ch_date_key=to_number(var_array(i).ch_on)
       where n.member_key = to_number(case
                                        when regexp_like(var_array(i).zbpartner, '.([a-z]+|[A-Z])') then
                                         '0'
                                        when regexp_like(var_array(i).zbpartner, '[[:punct:]]+') then
                                         '0'
                                        when var_array(i).zbpartner is null then
                                         '0'
                                        when var_array(i).zbpartner like '%null%' then
                                         '0'
                                        else
                                         regexp_replace(var_array(i).zbpartner, '\s', '')
                                      end);
    
      commit;
    
      update /*+ index(nn MEMBER_BP_IDX) */ dim_member nn
         set nn.member_level = var_array(i).ztcmc016,
             nn.ch_date_key=to_number(var_array(i).ch_on)
       where nn.member_bp = to_number(case
                                        when regexp_like(var_array(i).zbpartner, '.([a-z]+|[A-Z])') then
                                         '0'
                                        when regexp_like(var_array(i).zbpartner, '[[:punct:]]+') then
                                         '0'
                                        when var_array(i).zbpartner is null then
                                         '0'
                                        when var_array(i).zbpartner like '%null%' then
                                         '0'
                                        else
                                         regexp_replace(var_array(i).zbpartner, '\s', '')
                                      end)    ;
    
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
  
end processmlevel;
/

