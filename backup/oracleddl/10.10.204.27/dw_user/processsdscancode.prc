???create or replace procedure dw_user.processsdscancode(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  min_day     number;
  max_day     number;
  garde_num   number;
  lsi         number;
  ls_total    number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：系统部扫码购数据
       
  
  作者时间：bobo  2016-07-19
  */

begin

  sp_name          := 'processsdscancode'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'sd_scancode_device'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from sd_scancode_device where VISIT_DATE_KEY = postday;

  insert into sd_scancode_device
    (VID, IP, VISIT_DATE, VISIT_DATE_KEY)
    (select VID, IP, VISIT_DATE, visit_date_key
       from fact_page_view a
      where a.visit_date_key = postday
        and a.page_name in
            ('Tvdownload', 'ScanTvlist', 'TV_QRC', 'ScanGoods')
        and a.page_value not in
            ('from_wx_list', 'from_else_list', 'from_ali_list'));
  insert_rows := sql%rowcount;
  delete from sd_scancode_order where ADD_TIME_KEY = postday;
  insert into sd_scancode_order
    (order_key, order_ip, add_time_key, app_name, add_time, order_id)
    (select crm_ORDER_NO order_key,
            ORDER_IP,
            ADD_TIME as ADD_TIME_key,
            APP_NAME,
            (ADD_TIME_int / (60 * 60 * 24) +
            TO_DATE('1970-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss') +
            TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone), 1, 3)) / 24) AS add_time,
            order_id
       from factec_order
      where ORDER_IP in
            (select ip
               from fact_page_view a
              where a.visit_date_key = postday
                and a.page_name in
                    ('Tvdownload', 'ScanTvlist', 'TV_QRC', 'ScanGoods')
                and a.page_value not in
                    ('from_wx_list', 'from_else_list', 'from_ali_list'))
        and ADD_TIME = postday
        and crm_ORDER_NO is not null);
  insert_rows := insert_rows + sql%rowcount;
  commit;
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
end processsdscancode;
/

