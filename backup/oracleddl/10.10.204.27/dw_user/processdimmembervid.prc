???create or replace procedure dw_user.processdimmembervid is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmembervid'; --需要手工填入所写PROCEDURE的名称
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
    minvid    varchar2(1000);
    maxvid    varchar2(1000);
    m_count   number;
  begin
  
    select * bulk collect
      into var_array
      from dim_member e
     where e.member_insert_date between '20160101' and '20160830';
    --order by e.member_insert_date;
  
    for i in 1 .. var_array.count loop
      select count(n1.member_key)
        into m_count
        from fact_session n1
       where n1.member_key = var_array(i).member_bp
         and n1.start_date_key < 20160831;
    
      if m_count = 0 then
      
        update dim_member k1
           set k1.first_active_vid = 'unknown',
               k1.end_active_vid   = 'unknown',
               k1.flag             = 2
         where k1.member_bp = var_array(i).member_bp;
      
        commit;
      
      else
      
        select p1.vid
          into minvid
          from fact_session p1
         where p1.member_key = var_array(i).member_bp
           and p1.start_date_key = var_array(i).first_active_date_key
           and rownum=1;
           
      
        select p2.vid
          into maxvid
          from fact_session p2
         where p2.member_key = var_array(i).member_bp
           and p2.start_date_key = var_array(i).end_active_date_key
           and rownum=1;
        update dim_member k1
           set k1.first_active_vid = minvid,
               k1.end_active_vid   = maxvid,
               k1.flag             = 2
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
end processdimmembervid;
/

