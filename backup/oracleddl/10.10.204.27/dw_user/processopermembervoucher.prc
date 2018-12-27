???create or replace procedure dw_user.processopermembervoucher(postday in number) is
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

  sp_name          := 'processopermembervoucher'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_member'; --此处需要手工录入该PROCEDURE操作的表格
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

  --注册送券的核算
  update oper_member m
     set (register_voucher_time, register_state) =
         (select v.voucher_active_date as register_voucher_time,
                 1                     as register_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1242
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1242
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.register_state = 0
     and m.register_record_date_key is not null;
  insert_rows := sql%rowcount;

  --订购一次15内无订购
  update oper_member m
     set (fifteen_voucher_time, fifteen_state) =
         (select v.voucher_active_date as fifteen_voucher_time,
                 1                     as fifteen_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1244
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1244
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.fifteen_state = 0
     and m.fifteen_record_date_key is not null;
  insert_rows := insert_rows + sql%rowcount;

  --订购两次30天内无订购
  update oper_member m
     set (thirty_voucher_time, thirty_state) =
         (select v.voucher_active_date as thirty_voucher_time,
                 1                     as thirty_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1245
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1245
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.thirty_state = 0
     and m.thirty_record_date_key is not null;
  insert_rows := insert_rows + sql%rowcount;

  --订购有效金额大于等于850小1000
  update oper_member m
     set (D850_voucher_time, D850_state) =
         (select v.voucher_active_date as D850_voucher_time, 1 as D850_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1246
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1246
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.D850_state = 0
     and m.D850_record_date_key is not null;
  insert_rows := insert_rows + sql%rowcount;

  --订购有效金额大于等于2600小3000
  update oper_member m
     set (D2600_voucher_time, D2600_state) =
         (select v.voucher_active_date as D2600_voucher_time,
                 1                     as D2600_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1248
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1248
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.D2600_state = 0
     and m.D2600_record_date_key is not null;
  insert_rows := insert_rows + sql%rowcount;

  --有效订购4次的用户
  update oper_member m
     set (FOUR_voucher_time, FOUR_state) =
         (select v.voucher_active_date as FOUR_voucher_time, 1 as FOUR_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1247
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1247
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.FOUR_state = 0
     and m.four_record_date_key is not null;
  insert_rows := insert_rows + sql%rowcount;

  --REVERSE_ORDER_TIME

  --20160614后有效订购大于等于2且最后一次退货(车队回收，用户回寄)15天内无订购
  update oper_member m
     set (REVERSE_voucher_time, REVERSE_state) =
         (select v.voucher_active_date as REVERSE_voucher_time,
                 1                     as REVERSE_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1249
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1249
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.REVERSE_state = 0
     and m.REVERSE_record_date_key is not null;
  insert_rows := insert_rows + sql%rowcount;

  --20160501后有效订购大于等于2且最后一次订购后60天内无订购
  update oper_member m
     set (no60_voucher_time, no60_state) =
         (select v.voucher_active_date as no60_voucher_time, 1 as no60_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1250
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1250
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.no60_state = 0
     and m.no60_record_date_key is not null;
  insert_rows := insert_rows + sql%rowcount;

  --20160627后有有效订购记录的用户，取计算之日7天前倒数30天内有效订购金额大于等于199的总计有3次以上的会员（无法获取确认收货时间）
  update oper_member m
     set (three199_voucher_time, three199_state) =
         (select v.voucher_active_date as three199_voucher_time,
                 1                     as three199_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1251
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1251
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.three199_state = 0
     and m.three199_record_date_key is not null;
  insert_rows := insert_rows + sql%rowcount;

  --20160627后有订购记录的用户，取计算之日7天前倒数自然年内有效订购金额大于等于199的次数大于等于10的用户
  update oper_member m
     set (ten199_voucher_time, ten199_state) =
         (select v.voucher_active_date as ten199_voucher_time,
                 1                     as ten199_state
            from fact_voucher v
           where v.member_key = m.member_key
             and voucher_t_id = 1252
             and voucher_active_date >= postday)
   where exists (select 1
            from fact_voucher v
           where voucher_t_id = 1252
             and voucher_active_date >= postday
             and m.member_key = v.member_key)
     and m.ten199_state = 0
     and m.ten199_record_date_key is not null;

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
end processopermembervoucher;
/

