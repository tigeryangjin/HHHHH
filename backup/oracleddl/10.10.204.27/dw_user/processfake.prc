???create or replace procedure dw_user.processfake(startpoint in date) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processfake'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'top_alltime1020'; --此处需要手工录入该PROCEDURE操作的表格
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
    cnt1 number;
  begin
    select max(total)
      into cnt1
      from top_alltime1020
     where member_id not in (113, 474619, 271575);
  
    -- update tmp_fake_2 k1 set k1.total=cnt1+1327 where k1.member_id=113;
    --  update tmp_fake_2 k1 set k1.total=cnt1+3762 where k1.member_id=474619;
    --   update tmp_fake_2 k1 set k1.total=cnt1+5165 where k1.member_id=271575;
  
    update top_alltime1020 k2
       set k2.total = cnt1 + 327
     where k2.member_id = 113;
    update top_alltime1020 k2
       set k2.total = cnt1 + 762
     where k2.member_id = 474619;
    update top_alltime1020 k2
       set k2.total = cnt1 + 1065
     where k2.member_id = 271575;
  
    update top_alltime1020 k2
       set k2.createdate = startpoint
     where member_id in (113, 474619, 271575);
  
    commit;
  
    /* insert into top_alltime1020
     select x.member_id,
      (select xx.member_name from dim_memid xx where xx.member_id=x.member_id and rownum=1),
     x.total,startpoint from  tmp_fake_2 x ;
    commit;*/
  
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
end processfake;
/

