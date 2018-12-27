???create or replace procedure dw_user.processvidmbinc(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processvidmbinc'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_vid_mem'; --此处需要手工录入该PROCEDURE操作的表格
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
  
  begin
  
    insert into dim_vid_mem
      (vid, member_key, create_date_key, application_key)
      select distinct j1.vid,
                      j1.member_key,
                      j1.start_date_key,
                      case
                        when j1.vid like '%iphone%' then
                         10
                        when j1.vid like '%android%' then
                         20
                        when j1.vid like '%webmportal%' then
                         30
                        when j1.vid like '%webportal%' then
                         40
                        when j1.vid like '%wx%' then
                         50
                        else
                         -1
                      end
        from fact_session j1
       where j1.start_date_key = startpoint --to_number(to_char(sysdate - 1, 'yyyymmdd'))
            --to_number(to_char(sysdate - 1, 'yyyymmdd'))
         and j1.member_key != 0
         and not exists (select *
                from dim_vid_mem j2
               where j2.vid = j1.vid
                 and j2.member_key = j1.member_key);
  
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
end processvidmbinc;
/

