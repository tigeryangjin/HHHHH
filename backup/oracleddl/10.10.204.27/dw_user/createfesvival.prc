???create or replace procedure dw_user.createfesvival(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'createfesvival'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_wechat'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from tmp_wechart1;
  delete from tmp_wechart2;
  delete from tmp_wechart3;
  delete from tmp_wechart4;
  delete from tmp_wechart5;
  commit;

  declare
    cnt1 number;
    cnt2 number;
  begin
    select min(tt.id), min(tt.id) + 19999
      into cnt1, cnt2
      from dim_wechat tt
     where tt.subscribe_time = startpoint;
  
    insert into tmp_wechart1
      select  substr(tt.open_id,3,length(tt.open_id))
        from dim_wechat tt
       where tt.id between cnt1 and cnt2;
    commit;
  
    insert into tmp_wechart2
      select substr(tt.open_id,3,length(tt.open_id))
        from dim_wechat tt
       where tt.id between cnt2 + 1 and cnt2 + 20000;
    commit;
  
    insert into tmp_wechart3
      select substr(tt.open_id,3,length(tt.open_id))
        from dim_wechat tt
       where tt.id between cnt2 + 20001 and cnt2 + 40000;
    commit;
  
    insert into tmp_wechart4
      select substr(tt.open_id,3,length(tt.open_id))
        from dim_wechat tt
       where tt.id between cnt2 + 40001 and cnt2 + 60000;
    commit;
  
    insert into tmp_wechart5
      select substr(tt.open_id,3,length(tt.open_id))
        from dim_wechat tt
       where tt.id between cnt2 + 60001 and cnt2 + 80000;
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
end createfesvival;
/

