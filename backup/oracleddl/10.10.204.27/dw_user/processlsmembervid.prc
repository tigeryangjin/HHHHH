???create or replace procedure dw_user.processlsmembervid(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --member_true number;
  --goods_true  number;
  --insert_ok   number;

  /*
  功能说明：关联商品抽取
       
  
  作者时间：bobo  2016-04-06
  */
begin
  sp_name          := 'processlsmembervid'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'LS_MEMBER_VID'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --member_true      := 0;
  --goods_true       := 0;
  insert_rows      := 0;
  --onetotal         := 50000; --一次取5000记录循环
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  begin
    if  postday<20160101 then
      s_etl.err_msg := '数据过小';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  begin
    if  postday>20160531 then
      s_etl.err_msg := '数据过小';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  merge into LS_MEMBER_VID g --fzq1表是需要更新的表
  using (select device_key, member_key
           from fact_page_view
          where visit_date_key = postday
            and member_key != 0
          group by member_key, device_key) m -- 关联表
  on (m.device_key = g.device_key and m.member_key = g.member_key) --关联条件
  
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
    insert values (m.member_key, m.device_key, postday);

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
end processlsmembervid;
/

