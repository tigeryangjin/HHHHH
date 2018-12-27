???create or replace procedure dw_user.processdimmemberactive is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmemberactive'; --需要手工填入所写PROCEDURE的名称
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
    minday    number;
    maxday    number;
    daycount  number;
    timecount number;
    app_day   number;
    wap_day   number;
    pc_day    number;
    wx_day    number;
    cycle     number;
    m_count   number;
  begin
  
    select * bulk collect
      into var_array
      from dim_member e
     where e.member_insert_date='00000000';-- between '20160101' and '20160830';
    --order by e.member_insert_date;
  
    for i in 1 .. var_array.count loop
      select count(n1.member_key)
        into m_count
        from fact_session n1
       where n1.member_key = var_array(i).member_bp
         and n1.start_date_key<20160831;
    
      if m_count = 0 then
      
        update dim_member k1
           set k1.first_active_date_key = 0,
               k1.end_active_date_key   = 0,
               k1.active_days           = 0,
               k1.active_times          = 0,
               k1.app_last_date_key     = 0,
               k1.wx_last_date_key      = 0,
               k1.pc_last_date_key      = 0,
               k1.wap_last_date_key     = 0,
               k1.avg_active_cycle      = 0,
               k1.flag                  = 1
         where k1.member_bp = var_array(i).member_bp;
      
        commit;
      
      else
      
        select k.mindays,
               k.maxdays,
               k.daycounts,
               k.timecounts,
               k.app_last_date_key,
               k.wap_last_date_key,
               k.pc_last_date_key,
               k.wx_last_date_key,
               trunc((to_number(to_date(to_char(k.maxdays), 'yyyymmdd') -
                                to_date(to_char(k.mindays), 'yyyymmdd')) /
                     k.daycounts),
                     2)
          into minday,
               maxday,
               daycount,
               timecount,
               app_day,
               wap_day,
               pc_day,
               wx_day,
               cycle
        
          from (select n1.member_key,
                       nvl(min(n1.start_date_key), 0) as mindays,
                       nvl(max(n1.start_date_key), 0) as maxdays,
                       nvl(count(distinct n1.start_date_key), 0) as daycounts,
                       nvl(count(distinct n1.session_key), 0) as timecounts,
                       
                       (select nvl(max(nn.start_date_key), 0)
                          from fact_session nn
                         where nn.member_key = n1.member_key
                           and nn.application_key in (10, 20)) as app_last_date_key,
                       (select nvl(max(nn.start_date_key), 0)
                          from fact_session nn
                         where nn.member_key = n1.member_key
                           and nn.application_key = 30) as wap_last_date_key,
                       (select nvl(max(nn.start_date_key), 0)
                          from fact_session nn
                         where nn.member_key = n1.member_key
                           and nn.application_key = 40) as pc_last_date_key,
                       (select nvl(max(nn.start_date_key), 0)
                          from fact_session nn
                         where nn.member_key = n1.member_key
                           and nn.application_key = 50) as wx_last_date_key
                  from fact_session n1
                 where n1.member_key = var_array(i).member_bp
                  and  n1.start_date_key<20160831
                 group by n1.member_key) k;
      
        update dim_member k1
           set k1.first_active_date_key = minday,
               k1.end_active_date_key   = maxday,
               k1.active_days           = daycount,
               k1.active_times          = timecount,
               k1.app_last_date_key     = app_day,
               k1.wx_last_date_key      = wx_day,
               k1.pc_last_date_key      = pc_day,
               k1.wap_last_date_key     = wap_day,
               k1.avg_active_cycle      = cycle,
               k1.flag                  = 1
         where k1.member_bp = var_array(i).member_bp;
      
        -- insert_rows := sql%rowcount;
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
end processdimmemberactive;
/

