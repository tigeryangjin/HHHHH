???create or replace procedure dw_user.processmemberpagevalue(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：杜一帆需要用户的活跃度
       
  
  作者时间：bobo  2016-04-06
  */

begin
  sp_name          := 'processmemberpagevalue'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dyf_MEMBER_page_value'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --onetotal         := 50000; --一次取5000记录循环
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  select count(1)
    into total_nums
    from dyf_MEMBER_page_value
   where DATE_KEY = postday;
  if total_nums > 0 then
    s_etl.err_msg := '已经存在数据了';
    sp_sbi_w_etl_log(s_etl);
    return;
  end if;

  --插入APP的行为记录数据
  insert into dyf_member_page_value
    (member_key, date_key, vid, SOURCE,nums)
    (select member_key, Visit_date_key as date_key, vid, 'app' as SOURCE,count(1) as nums
       from fact_page_view
      where application_key in (10, 20) and
            member_key in
            (select member_key from dyf_member where source = 'app')
        and Visit_date_key = postday
      group by Visit_date_key, vid, member_key);
  insert_rows := sql%rowcount;
  --插入微信的行为记录数据
  insert into dyf_member_page_value
    (member_key, date_key, vid, SOURCE,nums)
    (select member_key, Visit_date_key as date_key, vid, 'wx' as SOURCE,count(1) as nums
       from fact_page_view
      where application_key = 50 and
            member_key in
            (select member_key from dyf_member where source = 'wx')
        and Visit_date_key = postday
      group by Visit_date_key, vid, member_key);
  
  insert_rows := insert_rows+sql%rowcount;
  
  /*日志记录模块*/
  s_etl.end_time := sysdate;
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
  
end processmemberpagevalue;
/

