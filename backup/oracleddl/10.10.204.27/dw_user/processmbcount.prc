???create or replace procedure dw_user.processmbcount(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processmbcount'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_mb_count'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from tmp_mb_session;
  commit;
  insert into tmp_mb_session
    (member_key, sessioncnt)
    select m1.member_key, count(m1.session_key) as sessioncnt
      from fact_session m1
     where m1.start_date_key = startpoint
       and m1.member_key != 0
       and exists (select *
              from dim_mb_count m2
             where m2.member_key = m1.member_key)
     group by m1.member_key;

  commit;

  declare
  
    type type_array is table of tmp_mb_session%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
  
  begin
  
    select * bulk collect into var_array from tmp_mb_session m1;
  
    for i in 1 .. var_array.count loop
    
      update dim_mb_count m3
         set m3.mbcnt = m3.mbcnt + var_array(i).sessioncnt
       where m3.member_key = var_array(i).member_key;
      commit;
    end loop;
  
    insert into dim_mb_count
      (member_key, mbcnt, insert_date_key, modify_date_key, chg_flag)
      select m1.member_key,
             count(m1.session_key) as sessioncnt,
             startpoint,
             startpoint,
             0
        from fact_session m1
       where m1.start_date_key = startpoint
         and m1.member_key != 0
         and not exists (select *
                from dim_mb_count m2
               where m2.member_key = m1.member_key)
       group by m1.member_key;
    commit;
  
  
  update dim_mb_count l1 set l1.chg_flag=1
  where l1.insert_date_key=startpoint and l1.mbcnt>4 and l1.chg_flag=0;
  commit; 
  
  
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
  
end processmbcount;
/

