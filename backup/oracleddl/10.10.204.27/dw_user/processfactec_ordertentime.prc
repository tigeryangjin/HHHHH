???create or replace procedure dw_user.processfactec_ordertentime(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：根据factec_order 10分钟计算一次订购
       
  
  作者时间：bobo  2016-07-19
  */

begin

  sp_name          := 'processfactec_ordertentime'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'factec_order_ten_time'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --onetotal         := 50000; --一次取5000记录循环
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  --计算正向订购的数据
  merge into factec_order_ten_total m --fzq1表是需要更新的表
  using (select o.add_time,
                o.app_name,
                g.item_code,
                
                floor(to_number(to_char(TO_DATE('19700101', 'yyyymmdd') +
                                        add_time_int / 86400 +
                                        TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),
                                                         1,
                                                         3)) / 24,
                                        'hh24'))) as sfm_hour,
                
                floor(to_number(to_char(TO_DATE('19700101', 'yyyymmdd') +
                                        add_time_int / 86400 +
                                        TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),
                                                         1,
                                                         3)) / 24,
                                        'mi')) / 10) * 10 as sfm,
                sum(g.goods_num) as nums,
                sum(g.goods_num * GOODS_PAY_PRICE) as amount
           from factec_order_goods g
           left join factec_order o
             on o.order_id = g.order_id
          where o.add_time = postday
          group by o.add_time,
                   g.item_code,
                   floor(to_number(to_char(TO_DATE('19700101', 'yyyymmdd') +
                                           add_time_int / 86400 +
                                           TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),
                                                            1,
                                                            3)) / 24,
                                           'mi')) / 10),
                   floor(to_number(to_char(TO_DATE('19700101', 'yyyymmdd') +
                                           add_time_int / 86400 +
                                           TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),
                                                            1,
                                                            3)) / 24,
                                           'hh24'))),
                   o.app_name) mm -- 关联表
  on (m.DATE_KEY = mm.add_time and m.TIME_KEY = mm.sfm_hour and m.min_key = mm.sfm and m.APP_NAME = mm.APP_NAME and m.item_code = mm.item_code) --关联条件
  when matched then --匹配关联条件，作更新处理
    update
       set m.ORDER_NUMS = mm.nums, m.ORDER_AMOUNT = mm.amount --此处只是说明可以同时更新多个字段。
    
  
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
    insert
      (DATE_KEY,
       min_key,
       TIME_KEY,
       APP_NAME,
       item_code,
       ORDER_NUMS,
       ORDER_AMOUNT)
    values
      (mm.add_time,
       mm.sfm,
       mm.sfm_hour,
       mm.APP_NAME,
       mm.item_code,
       mm.nums,
       mm.amount);
  insert_rows := sql%rowcount;

  --计算取消订购的数据
  merge into factec_order_ten_total m --fzq1表是需要更新的表
  using (select o.follow_up_time_key as add_time,
                o.app_name,
                g.item_code,
                floor(to_number(to_char(TO_DATE('19700101', 'yyyymmdd') +
                                        follow_up_time / 86400 +
                                        TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),
                                                         1,
                                                         3)) / 24,
                                        'mi')) / 10) * 10 as sfm,
                floor(to_number(to_char(TO_DATE('19700101', 'yyyymmdd') +
                                        follow_up_time / 86400 +
                                        TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),
                                                         1,
                                                         3)) / 24,
                                        'hh24'))) as sfm_hour,
                sum(g.goods_num) as qx_nums,
                sum(g.goods_num * GOODS_PAY_PRICE) as qx_amount
           from factec_order_goods g
           left join factec_order o
             on o.order_id = g.order_id
          where o.follow_up_time_key = postday
            and o.order_state = 0
          group by o.follow_up_time_key,
                   g.item_code,
                   floor(to_number(to_char(TO_DATE('19700101', 'yyyymmdd') +
                                           follow_up_time / 86400 +
                                           TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),
                                                            1,
                                                            3)) / 24,
                                           'hh24'))),
                   floor(to_number(to_char(TO_DATE('19700101', 'yyyymmdd') +
                                           follow_up_time / 86400 +
                                           TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),
                                                            1,
                                                            3)) / 24,
                                           'mi')) / 10),
                   o.app_name) mm -- 关联表
  on (m.DATE_KEY = mm.add_time and m.TIME_KEY = mm.sfm_hour and m.min_key = mm.sfm and m.APP_NAME = mm.APP_NAME and m.item_code = mm.item_code) --关联条件
  when matched then --匹配关联条件，作更新处理
    update
       set m.QX_NUMS = mm.qx_nums, m.QX_AMOUNT = mm.qx_amount --此处只是说明可以同时更新多个字段。
    
  
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
    insert
      (DATE_KEY,
       min_key,
       TIME_KEY,
       APP_NAME,
       item_code,
       QX_NUMS,
       QX_AMOUNT)
    values
      (mm.add_time,
       mm.sfm,
       mm.sfm_hour,
       mm.APP_NAME,
       mm.item_code,
       mm.QX_NUMS,
       mm.QX_AMOUNT);
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
end processfactec_ordertentime;
/

