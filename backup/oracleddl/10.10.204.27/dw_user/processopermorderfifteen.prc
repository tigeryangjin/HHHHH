???create or replace procedure dw_user.processopermorderfifteen(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：有且只在电商2.0订购过一次，切第一次订购后15天内无订购
       
  
  作者时间：bobo  2016-06-27
  */

begin

  sp_name          := 'processopermorderfifteen'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_m_order_fifteen'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from oper_m_order_fifteen where record_date_key = postday;
  insert into oper_m_order_fifteen
    (member_key, order_time, record_date_key)
    (select pp.member_key, pp.order_time, pp.record_date_key
       from (select p.member_key,
                    count(1) as nums,
                    to_number(to_char(to_date(postday, 'yyyy-mm-dd') - 15,
                                      'yyyymmdd')) as order_time,
                    postday as record_date_key
               from (select distinct (member_key) as member_key
                       from fact_order
                      where order_state = 1
                        and sales_source_second_key in
                            (20022, 20021, 20020, 20018, 20017)
                        and posting_date_key =
                            to_number(to_char(to_date(postday, 'yyyy-mm-dd') - 15,
                                              'yyyymmdd'))
                      group by member_key) p
               left join fact_order o
                 on o.member_key = p.member_key
                 where o.sales_source_second_key in
                            (20022, 20021, 20020, 20018, 20017) and o.order_state = 1
              group by p.member_key) pp
      where pp.nums = 1);

  merge into oper_member m --fzq1表是需要更新的表
  using (select * from oper_m_order_fifteen where record_date_key = postday) mm -- 关联表
  on (m.member_key = mm.member_key) --关联条件
  when matched then --匹配关联条件，作更新处理
    update
       set m.FIFTEEN_ORDER_TIME      = mm.order_time,
           m.fifteen_record_date_key = mm.record_date_key --此处只是说明可以同时更新多个字段。
    
  
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
    insert
      (member_key, FIFTEEN_ORDER_TIME, fifteen_record_date_key)
    values
      (mm.member_key, mm.order_time, mm.record_date_key);
  insert_rows := sql%rowcount;

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
end processopermorderfifteen;
/

