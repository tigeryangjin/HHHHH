???create or replace procedure dw_user.processdimmembertypeinc (startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmembertypeinc'; --需要手工填入所写PROCEDURE的名称
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
  
    type type_array is table of tmp_mbp%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
  
  begin
  
    select ee.* bulk collect
      into var_array
      from (select e.member_key
              from fact_order e
             where e.order_date_key =startpoint
                   --to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and e.order_state = 1
            union
            select cc.member_key
              from fact_order_reverse cc
             where cc.cancel_state = 0
               and cc.posting_date_key =startpoint
                   --to_number(to_char(sysdate - 1, 'yyyymmdd'))
                   ) ee;
  
    delete from tmp_0902;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, var_array(i).member_key);
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
                          end,
               v.ch_date_key=startpoint          
       where v.member_bp = var_array(i).member_key;
    
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
end processdimmembertypeinc;
/

