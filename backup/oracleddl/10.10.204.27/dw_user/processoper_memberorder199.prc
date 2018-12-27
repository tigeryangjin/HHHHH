???create or replace procedure dw_user.processoper_memberorder199(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：后有有效订购记录的用户，取计算之日7天前倒数30天内有效订购金额大于等于199的总计有3次以上的会员
       
  
  作者时间：bobo  2016-06-27
  */

begin

  sp_name          := 'processoper_memberorder199'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_member_order_3_199'; --此处需要手工录入该PROCEDURE操作的表格
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

  --处理一月内3次199
  delete from oper_member_order_3_199 where record_date_key = postday;
  insert into oper_member_order_3_199
    (member_key, last_date_key, order_total, record_date_key)
    (select member_key,
            posting_date_key as last_date_key,
            nums             as order_total,
            postday          as record_date_key
       from (select member_key,
                    count(1) as nums,
                    max(posting_date_key) as posting_date_key
               from fact_order
              where posting_date_key between
                    to_number(to_char(to_date(postday, 'yyyy-mm-dd') - 37,
                                      'yyyymmdd')) and
                    to_number(to_char(to_date(postday, 'yyyy-mm-dd') - 7,
                                      'yyyymmdd'))
                and sales_source_second_key in
                    (20022, 20021, 20020, 20018, 20017)
                and order_state = 1
                and order_amount >= 199
              group by member_key) p
      where p.posting_date_key =
            to_number(to_char(to_date(postday, 'yyyy-mm-dd') - 7,
                              'yyyymmdd'))
        and p.nums >= 3);

  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
                last_date_key as last_order_TIME,
                8             as rule_key,
                8             as rule_group_key,
                order_total   as VAILD_NUMS,
                --reverse_last_time,
                to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
           from oper_member_order_3_199
          where record_date_key = postday) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
    insert
      (member_key,
       last_order_Time,
       Rule_Key,
       Rule_Group_Key,
       VAILD_NUMS,
       add_time,
       POSTING_DATE)
    values
      (mm.member_key,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.VAILD_NUMS,
       mm.add_time,
       mm.POSTING_DATE);
  insert_rows := sql%rowcount;

  --处理自然年内10次199
  delete from oper_member_order_10_199 where record_date_key = postday;
  insert into oper_member_order_10_199
    (member_key, last_date_key, order_total, record_date_key)
    (select member_key,
            posting_date_key as last_date_key,
            nums             as order_total,
            postday          as record_date_key
       from (select member_key,
                    count(1) as nums,
                    max(posting_date_key) as posting_date_key
               from fact_order
              where posting_date_key between
                    to_number(to_char(trunc(sysdate, 'yy'), 'yyyymmdd')) and
                    to_number(to_char(to_date(postday, 'yyyy-mm-dd') - 7,
                                      'yyyymmdd'))
                and sales_source_second_key in
                    (20022, 20021, 20020, 20018, 20017)
                and order_state = 1
                and order_amount >= 199
              group by member_key) p
      where p.posting_date_key =
            to_number(to_char(to_date(postday, 'yyyy-mm-dd') - 7,
                              'yyyymmdd'))
        and p.nums >= 10);

  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
                last_date_key as last_order_TIME,
                9             as rule_key,
                9             as rule_group_key,
                order_total   as VAILD_NUMS,
                --reverse_last_time,
                to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
           from oper_member_order_10_199
          where record_date_key = postday) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
    insert
      (member_key,
       last_order_Time,
       Rule_Key,
       Rule_Group_Key,
       VAILD_NUMS,
       add_time,
       POSTING_DATE)
    values
      (mm.member_key,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.VAILD_NUMS,
       mm.add_time,
       mm.POSTING_DATE);
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
end processoper_memberorder199;
/

