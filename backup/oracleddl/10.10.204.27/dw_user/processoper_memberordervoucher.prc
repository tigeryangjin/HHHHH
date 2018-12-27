???create or replace procedure dw_user.processoper_memberordervoucher(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：订购金额大等于2600小于3000的用户进行抽取
       
  
  作者时间：bobo  2016-06-27
  */

begin

  sp_name          := 'processoper_memberordervoucher'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_member_order_voucher'; --此处需要手工录入该PROCEDURE操作的表格
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

  --计算7天无注册用户的数据
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
                REGISTER_TIME,
         last_order_TIME,
         1 as rule_key,
         1 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         (order_nums - reverse_order_nums) as VAILD_NUMS,
         reverse_last_time,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
           from oper_member_order
          where order_nums - reverse_order_nums = 0
            and register_time = to_number(to_char(to_date(postday,'yyyy-mm-dd') - 7, 'yyyymmdd'))
            --and update_time = postday
            ) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    insert
      (member_key,REGISTER_TIME, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS,reverse_last_time, add_time,POSTING_DATE)
    values
      (mm.member_key,
      mm.REGISTER_TIME,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.reverse_last_time,
       mm.add_time,
       mm.POSTING_DATE);
       /*insert
      (member_key, Register_Time, Rule_Key, Rule_Group_Key, add_time,posting_date)
    values
      (mm.member_key,
       mm.Register_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.add_time,
       mm.posting_date);*/

  insert_rows := sql%rowcount;

  --计算首单15天后无订购用户
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
                REGISTER_TIME,
         last_order_TIME,
         2 as rule_key,
         2 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         (order_nums - reverse_order_nums) as VAILD_NUMS,
         reverse_last_time,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
           from oper_member_order
          where order_nums - reverse_order_nums = 1
            and last_order_time =
                to_number(to_char(to_date(postday,'yyyy-mm-dd') - 15, 'yyyymmdd'))
            --and update_time = postday
            ) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    insert
      (member_key,REGISTER_TIME, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS,reverse_last_time, add_time,POSTING_DATE)
    values
      (mm.member_key,
      mm.REGISTER_TIME,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.reverse_last_time,
       mm.add_time,
       mm.POSTING_DATE);
       /*insert
      (member_key, last_order_Time, Rule_Key, Rule_Group_Key, add_time,POSTING_DATE)
    values
      (mm.member_key,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.add_time,
       mm.POSTING_DATE);*/

  insert_rows := insert_rows + sql%rowcount;

  --计算次单后，30天无订购的
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
                REGISTER_TIME,
         last_order_TIME,
         3 as rule_key,
         3 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         (order_nums - reverse_order_nums) as VAILD_NUMS,
         reverse_last_time,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
           from oper_member_order
          where order_nums - reverse_order_nums = 2
            and last_order_time =
                to_number(to_char(to_date(postday,'yyyy-mm-dd') - 30, 'yyyymmdd'))
            --and update_time = postday
            ) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    insert
      (member_key,REGISTER_TIME, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS,reverse_last_time, add_time,POSTING_DATE)
    values
      (mm.member_key,
      mm.REGISTER_TIME,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.reverse_last_time,
       mm.add_time,
       mm.POSTING_DATE);
       /*insert
      (member_key, last_order_Time, Rule_Key, Rule_Group_Key, add_time,POSTING_DATE)
    values
      (mm.member_key,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.add_time,
       mm.POSTING_DATE);*/

  insert_rows := insert_rows + sql%rowcount;
  
  /*
  --计算订购金额850—1000: 累计订购金额-累计消退金额 between  850,1000
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
         last_order_TIME,
         4 as rule_key,
         4 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time
    from oper_member_order
   where order_amount - reverse_amount between 850 and 999
            and update_time = postday) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_key = mm.rule_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    insert
      (member_key, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount, add_time)
    values
      (mm.member_key,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.add_time);

  insert_rows := insert_rows + sql%rowcount;
  
  
  --计算订购金额2600—3000: 累计订购金额-累计消退金额 between  2600,3000
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
         last_order_TIME,
         5 as rule_key,
         4 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time
    from oper_member_order
   where order_amount - reverse_amount between 2600 and 2999
            and update_time = postday) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_key = mm.rule_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    insert
      (member_key, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount, add_time)
    values
      (mm.member_key,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.add_time);

  insert_rows := insert_rows + sql%rowcount;
  
  */
  
  --计算有效订购等于3次的
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
         REGISTER_TIME,
         last_order_TIME,
         4 as rule_key,
         4 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         (order_nums - reverse_order_nums) as VAILD_NUMS,
         reverse_last_time,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
    from oper_member_order
   where order_nums - reverse_order_nums=3
   and last_order_time =
                to_number(to_char(to_date(postday,'yyyy-mm-dd') - 15, 'yyyymmdd'))
            --and update_time = postday
            ) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    insert
      (member_key,REGISTER_TIME, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS,reverse_last_time, add_time,POSTING_DATE)
    values
      (mm.member_key,
      mm.REGISTER_TIME,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.reverse_last_time,
       mm.add_time,
       mm.POSTING_DATE);
    /*insert
      (member_key, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS, add_time,POSTING_DATE)
    values
      (mm.member_key,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.add_time,
       mm.POSTING_DATE);*/

  insert_rows := insert_rows + sql%rowcount;
  
  
  --计算有效订购等于4次的
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
         REGISTER_TIME,
         last_order_TIME,
         5 as rule_key,
         5 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         (order_nums - reverse_order_nums) as VAILD_NUMS,
         reverse_last_time,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
    from oper_member_order
   where order_nums - reverse_order_nums=4
   and last_order_time =
                to_number(to_char(to_date(postday,'yyyy-mm-dd') - 15, 'yyyymmdd'))
            --and update_time = postday
            ) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    /*insert
      (member_key, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS, add_time,POSTING_DATE)
    values
      (mm.member_key,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.add_time,
       mm.POSTING_DATE);*/
       insert
      (member_key,REGISTER_TIME, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS,reverse_last_time, add_time,POSTING_DATE)
    values
      (mm.member_key,
      mm.REGISTER_TIME,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.reverse_last_time,
       mm.add_time,
       mm.POSTING_DATE);

  insert_rows := insert_rows + sql%rowcount;
  
  
  
  --计算有效订购大于等于2且最后一次退货(车队回收，用户回寄)15天内无订购
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
        REGISTER_TIME,
         last_order_TIME,
         6 as rule_key,
         6 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         (order_nums - reverse_order_nums) as VAILD_NUMS,
         reverse_last_time,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
    from oper_member_order
   where order_nums - reverse_order_nums>=2 and reverse_last_time>last_order_time
   and reverse_last_time=to_number(to_char(to_date(postday,'yyyy-mm-dd')-15,'yyyymmdd'))
            --and update_time = postday
            ) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    insert
      (member_key,REGISTER_TIME, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS,reverse_last_time, add_time,POSTING_DATE)
    values
      (mm.member_key,
      mm.REGISTER_TIME,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.reverse_last_time,
       mm.add_time,
       mm.POSTING_DATE);

  insert_rows := insert_rows + sql%rowcount;
  
  
  --计算有效订购大于等于2且最后一次退货(车队回收，用户回寄)60天内无订购
  merge into oper_member_order_voucher m --fzq1表是需要更新的表
  using (select member_key,
        REGISTER_TIME,
         last_order_TIME,
         7 as rule_key,
         7 as rule_group_key,
         order_amount,
         reverse_amount,
         (order_amount - reverse_amount) as amount,
         (order_nums - reverse_order_nums) as VAILD_NUMS,
         reverse_last_time,
         to_number(to_char(sysdate, 'yyyymmdd')) as add_time,
                postday as POSTING_DATE
    from oper_member_order
   where order_nums - reverse_order_nums>=2 --and reverse_last_time>last_order_time
   and last_order_time=to_number(to_char(to_date(postday,'yyyy-mm-dd')-60,'yyyymmdd'))
            --and update_time = postday
            ) mm -- 关联表
  on (m.member_key = mm.member_key and m.rule_group_key = mm.rule_group_key) --关联条件
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
  --insert into Oper_member_order_voucher (member_key,Register_Time,Rule_Key,Rule_Group_Key)
    insert
      (member_key,REGISTER_TIME, last_order_Time, Rule_Key, Rule_Group_Key,order_amount,reverse_amount,amount,VAILD_NUMS,reverse_last_time, add_time,POSTING_DATE)
    values
      (mm.member_key,
      mm.REGISTER_TIME,
       mm.last_order_Time,
       mm.Rule_Key,
       mm.Rule_Group_Key,
       mm.order_amount,
       mm.reverse_amount,
       mm.amount,
       mm.VAILD_NUMS,
       mm.reverse_last_time,
       mm.add_time,
       mm.POSTING_DATE);

  insert_rows := insert_rows + sql%rowcount;

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
end processoper_memberordervoucher;
/

