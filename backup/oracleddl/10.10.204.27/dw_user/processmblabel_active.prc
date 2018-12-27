???create or replace procedure dw_user.processmblabel_active(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processmblabel_active'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'member_label_link'; --此处需要手工录入该PROCEDURE操作的表格
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
  delete from tmp_scount_max;
  commit;
  insert into tmp_scount_max
    select t2.member_key,
           max(t2.cnt) as mcnt,
           min(t2.c_date_key) as c_date_key
      from tmp_atime_up t2
     where exists (select *
              from tmp_atime_up t
             where t.m_date_key = startpoint -- to_number(to_char(sysdate, 'yyyymmdd'))
               and t.member_key = t2.member_key)
     group by t2.member_key;

  commit;

  delete from member_label_link m1
   where m1.m_label_id between 10 and 17
     and exists (select *
            from tmp_atime_up t
           where t.m_date_key = startpoint -- to_number(to_char(sysdate, 'yyyymmdd'))
             and t.member_key = m1.member_key);
  commit;

  declare
  
    type type_array is table of tmp_scount_max%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    cnt       number;
  
  begin
  
    select * bulk collect into var_array from tmp_scount_max e;
  
    for i in 1 .. var_array.count loop
    
      select /*+ index(b1 MEM_UPCNT_IDX) */
       decode(b1.atime,
              'FOREDAWN',
              10,
              'DAWN',
              11,
              'MORNING',
              12,
              'FORENOON',
              13,
              'NOON',
              14,
              'AFTERNOON',
              15,
              'EVENING',
              16,
              'MIDNIGHT',
              17)
        into cnt
        from tmp_atime_up b1
       where b1.member_key = var_array(i).member_key
         and b1.cnt = var_array(i).mcnt
         and rownum = 1;
    
      insert into member_label_link
        (member_key,
         m_label_id,
         m_label_type_id,
         create_date,
         create_user_id,
         last_update_date,
         last_update_user_id,
         row_id)
      
        select var_array(i).member_key,
               cnt,
               1,
               to_date(to_char(var_array(i).c_date_key),
                       'yyyymmdd hh:mi:ss'),
               'liqiao',
               sysdate,
               'liqiao',
               member_label_link_seq.nextval
          from dual;
    
      commit;
    
    end loop;
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
end processmblabel_active;
/

