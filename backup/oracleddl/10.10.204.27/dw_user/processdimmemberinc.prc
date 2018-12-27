???create or replace procedure dw_user.processdimmemberinc(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmemberinc'; --需要手工填入所写PROCEDURE的名称
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

  delete from tmp_session_count;
  commit;

  insert into tmp_session_count
    (member_key, date_key, daycount, times)
  
    select j.member_key,
          -- to_number(to_char(sysdate - 8, 'yyyymmdd')) as date_key,
           startpoint as date_key,
           1 as daycount,
           count(j.session_key) as times
      from fact_session j
     where j.start_date_key =startpoint-- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and j.member_key != 0
       and exists
     (select * from dim_member j4 where j4.member_bp = j.member_key)
     group by j.member_key;
  commit;

  declare
  
    type type_array is table of tmp_session_count%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    --minday    number;
    --maxday    number;
    --daycount  number;
    --timecount number;
  
    m_count number;
  begin
  
    select * bulk collect into var_array from tmp_session_count j1;
  
    for i in 1 .. var_array.count loop
    
      select /*+ index(k1 MEMBER_BP_IDX) */ k1.first_active_date_key
        into m_count
        from dim_member k1
       where k1.member_bp = var_array(i).member_key;
    
      if m_count = 0 then
      
        update /*+ index(k1 MEMBER_BP_IDX) */ dim_member k1
           set k1.first_active_date_key = var_array(i).date_key,
               k1.end_active_date_key   = var_array(i).date_key,
               k1.active_days           = 1,
               k1.active_times          = var_array(i).times,
               k1.avg_active_cycle      = 0,
               k1.ch_date_key           = var_array(i).date_key
         where k1.member_bp = var_array(i).member_key;
      
        commit;
      
      else
      
        update /*+ index(k1 MEMBER_BP_IDX) */ dim_member k1
           set k1.end_active_date_key = var_array(i).date_key,
               k1.active_days         = k1.active_days + 1,
               k1.active_times        = k1.active_times + var_array(i).times,
               k1.avg_active_cycle    = trunc((to_number(to_date(to_char(var_array(i)
                                                                         .date_key),
                                                                 'yyyymmdd') -
                                                         to_date(to_char(k1.first_active_date_key),
                                                                 'yyyymmdd')) /
                                              (k1.active_days + 1)),
                                              2),
               k1.ch_date_key           = var_array(i).date_key
         where k1.member_bp = var_array(i).member_key;
      
       
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
end processdimmemberinc;
/

