???create or replace procedure dw_user.processdimmembertype is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmembertype'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_member'; --此处需要手工录入该PROCEDURE操作的表格
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
  declare
  
    type type_array is table of dim_member%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    --last_return_date number;
    --last_refuse_date number;
    --return_cnt       number;
    --refuse_cnt       number;
    --cancel_count number;
  begin
  
    select * bulk collect
      into var_array
      from dim_member e
     where e.member_insert_date ='20170103';
  
    delete from tmp_0903;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0903 values (1, var_array(i).member_bp);
      commit;
    
      update /*+ index(v MEMBER_BP_IDX) */ dim_member v
        
      set v.clv_type = case
                            when valid_orderamount > 2000 and
                                 valid_ordercount > 4 then
                             '好朋友'
                            when valid_orderamount <= 2000 and
                                 valid_ordercount > 4 then
                             '寄居蟹'
                            when valid_orderamount <= 2000 and
                                 valid_ordercount <= 4 and valid_ordercount>0 then
                             '陌生人'
                            when valid_orderamount > 2000 and
                                 valid_ordercount <= 4 and valid_ordercount>0 then
                             '蝴蝶型'
                            when valid_ordercount=0 then
                             '0单用户'
                          end,
              v.clv_type_w = case
                            when validw_orderamount > 2000 and
                                 validw_ordercount > 4 then
                             '好朋友'
                            when validw_orderamount <= 2000 and
                                 validw_ordercount > 4 then
                             '寄居蟹'
                            when validw_orderamount <= 2000 and
                                 validw_ordercount <= 4 and validw_ordercount>0 then
                             '陌生人'
                            when validw_orderamount > 2000 and
                                 validw_ordercount <= 4 and validw_ordercount>0 then
                             '蝴蝶型'
                            when validw_ordercount=0 then
                             '0单用户'
                          end
   
      
      
      
      
       where v.member_bp = var_array(i).member_bp;
    
    
    
    
    
    
    
    
    
    
    
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
end processdimmembertype;
/

