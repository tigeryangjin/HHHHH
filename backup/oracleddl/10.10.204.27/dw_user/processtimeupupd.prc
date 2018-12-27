???create or replace procedure dw_user.processtimeupupd(startpoint number,endpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processtimeupupd'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'tmp_atime_up'; --此处需要手工录入该PROCEDURE操作的表格
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
  delete from tmp_atime_up2;
  delete from tmp_0816;
  commit;
  insert into tmp_atime_up2
    select member_key, atime, cnt
      from (select m1.member_key,
                   count(case
                           when m1.hour between 0 and 2 then
                            1
                         end) as foredawn,
                   count(case
                           when m1.hour between 3 and 5 then
                            1
                         end) as dawn,
                   count(case
                           when m1.hour between 6 and 8 then
                            1
                         end) as morning,
                   count(case
                           when m1.hour between 9 and 11 then
                            1
                         end) as forenoon,
                   count(case
                           when m1.hour between 12 and 14 then
                            1
                         end) as noon,
                   count(case
                           when m1.hour between 15 and 17 then
                            1
                         end) as afternoon,
                   count(case
                           when m1.hour between 18 and 20 then
                            1
                         end) as evening,
                   count(case
                           when m1.hour between 21 and 23 then
                            1
                         end) as midnight
            
              from fact_session m1
             where m1.start_date_key =startpoint-- to_number(to_char(sysdate-1, 'yyyymmdd'))
               and m1.member_key != 0
               and exists (select *
                      from dim_mb_count m2
                     where m2.member_key = m1.member_key
                       and m2.modify_date_key not in (endpoint,
                       startpoint
                       )
                       
                       
                    )
             group by m1.member_key) unpivot(cnt for atime in(foredawn,
                                                              dawn,
                                                              morning,
                                                              forenoon,
                                                              noon,
                                                              afternoon,
                                                              evening,
                                                              midnight)) commit;

  declare
  
    type type_array is table of tmp_atime_up2%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    vcnt      number;
  
  begin
  
    select * bulk collect
      into var_array
      from tmp_atime_up2 e
     where e.cnt > 0;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0816 values (1, var_array(i).member_key);
      commit;
    
      select /*+ index(t1 MEM_ATIME2_IDX) */
       cnt
        into vcnt
      
        from tmp_atime_up2 t1
       where t1.member_key = var_array(i).member_key
         and t1.atime = var_array(i).atime;
    
      update /*+ index(l MEM_ATIME_IDX) */ tmp_atime_up l
         set l.cnt = l.cnt + vcnt,l.m_date_key=endpoint--to_number(to_char(sysdate, 'yyyymmdd'))
      
       where l.member_key = var_array(i).member_key
         and l.atime = var_array(i).atime;
    
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
end processtimeupupd;
/

