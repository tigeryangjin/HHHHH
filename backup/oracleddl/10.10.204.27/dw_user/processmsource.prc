???create or replace procedure dw_user.processmsource(startpoint in number ) is
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
  sp_name          := 'processmsource'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_MEMBER_REGISTER'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_member_register%rowtype index by binary_integer; --类似二维数组 
    a_key     number;
    hm        varchar2(20);
    d_key     number;
    minid     number;
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from fact_member_register e
     where e.media_key = 20
        and e.application_key = 0
        and e.register_date_key=startpoint;-- between 20160411 and 20160424; 20160428
  
    for i in 1 .. var_array.count loop
    
      select
       /*+ index(e1 MEMBER_IDX) */ nvl(min(id), 0)
        into minid
        from fact_session e1
       where e1.member_key = var_array(i).member_key;
    
      if minid = 0 then
        update  /*+ index(e3 MR_MK) */ fact_member_register e3
           set e3.application_key = 40, e3.hmsc = null, e3.device_key = -1
         where e3.member_key = var_array(i).member_key;
        commit;
      
      else
      
        select 
         e2.application_key
          into a_key
          from fact_session e2
         where e2.id = minid;
      
        select 
         e2a.hmsc
          into hm
          from fact_session e2a
         where e2a.id = minid;
      
        select 
         e2b.visitor_key
          into d_key
          from fact_session e2b
         where e2b.id = minid;
      
        update /*+ index(e4 MR_MK) */ fact_member_register e4
           set e4.application_key = a_key,
               e4.hmsc            = hm,
               e4.device_key      = d_key
        
         where e4.member_key = var_array(i).member_key;
      
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
  
end processmsource;
/

