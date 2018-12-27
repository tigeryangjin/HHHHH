???create or replace procedure dw_user.processdimmemberinc3(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmemberinc3'; --需要手工填入所写PROCEDURE的名称
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

delete from tmp_session_yingyong;
commit;

insert into tmp_session_yingyong
( member_key,
  application_key,
  start_date_key
)

select distinct j.member_key,j.application_key,j.start_date_key
      from fact_session j
     where j.start_date_key =startpoint-- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and j.member_key != 0
       and exists
     (select * from dim_member j4 where j4.member_bp = j.member_key);

commit;



  declare
  
    type type_array is table of tmp_session_yingyong%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    m_count1  number;
    m_count2  number;
    m_count3  number;
    m_count4  number;
  begin
  
    select * bulk collect into var_array from tmp_session_yingyong j;
  
    /*select * bulk collect
     into var_array
     from fact_session j
    where j.start_date_key = to_number(to_char(sysdate - 1, 'yyyymmdd'))
      and j.member_key != 0
      and exists
    (select * from dim_member j4 where j4.member_bp = j.member_key);*/
  
    insert into test values (1, sysdate);
    commit;
  
    for i in 1 .. var_array.count loop
    
      select
      /*+ index(m1 MEMSTART_IDX) */
       count(case
               when k1.application_key in (10, 20) then
                1
             end),
       count(case
               when k1.application_key = 30 then
                1
             end),
       count(case
               when k1.application_key = 40 then
                1
             end),
       count(case
               when k1.application_key = 50 then
                1
             end)
        into m_count1, m_count2, m_count3, m_count4
        from tmp_session_yingyong k1
       where k1.member_key = var_array(i).member_key
         and k1.start_date_key =startpoint;
            -- to_number(to_char(sysdate - 8, 'yyyymmdd'));
    
      if m_count1 > 0 then
        update /*+ index(m1 MEMBER_BP_IDX) */ dim_member m1
           set m1.app_last_date_key = var_array(i).start_date_key,
               m1.ch_date_key=var_array(i).start_date_key
         where m1.member_bp = var_array(i).member_key;
        commit;
      
      end if;
    
      if m_count2 > 0 then
        update /*+ index(m1 MEMBER_BP_IDX) */ dim_member m1
           set m1.wap_last_date_key = var_array(i).start_date_key,
               m1.ch_date_key=var_array(i).start_date_key
         where m1.member_bp = var_array(i).member_key;
        commit;
      
      end if;
    
      if m_count3 > 0 then
        update /*+ index(m1 MEMBER_BP_IDX) */ dim_member m1
           set m1.pc_last_date_key = var_array(i).start_date_key,
               m1.ch_date_key=var_array(i).start_date_key
         where m1.member_bp = var_array(i).member_key;
        commit;
      
      end if;
    
      if m_count4 > 0 then
        update /*+ index(m1 MEMBER_BP_IDX) */ dim_member m1
           set m1.wx_last_date_key = var_array(i).start_date_key,
               m1.ch_date_key=var_array(i).start_date_key
         where m1.member_bp = var_array(i).member_key;
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
end processdimmemberinc3;
/

