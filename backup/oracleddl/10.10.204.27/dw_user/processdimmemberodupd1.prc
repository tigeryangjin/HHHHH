???create or replace procedure dw_user.processdimmemberodupd1(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmemberodupd1'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_member'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_order_reverse%rowtype index by binary_integer; --类似二维数组 
    var_array            type_array;
    valid_amount         number;
    valid_count          number;
    valid_max_amount     number;
    fist_order_date      number;
    last_order_date      number;
    tv_valid_count       number;
    web_valid_count      number;
    ob_valid_count       number;
    web_validamount      number;
    web_validcount       number;
    web_valid_max_amount number;
    web_first_order_date number;
    web_last_order_date  number;
    apporder_count       number;
    wxorder_count        number;
    waporder_count       number;
    pcorder_count        number;
  
  begin
  
    select * bulk collect
      into var_array
      from fact_order_reverse e
     where e.posting_date_key = startpoint -- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and e.cancel_state = 0; -- between '20160101' and '20160904';
  
    delete from tmp_0902;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, var_array(i).member_key);
      commit;
    
      select /*+ index(t1 MEMBER_ORDER_KEY) */
       nvl(sum(case
                 when t1.order_state = 1 then
                  t1.order_amount
               end),
           0),
       nvl(count(case
                   when t1.order_state = 1 then
                    t1.order_key
                 end),
           0),
       nvl(max(case
                 when t1.order_state = 1 then
                  t1.order_amount
               end),
           0),
       nvl(min(case
                 when t1.order_state = 1 then
                  t1.order_date_key
               end),
           0),
       nvl(max(case
                 when t1.order_state = 1 then
                  t1.order_date_key
               end),
           0),
       nvl(count(case
                   when t1.sales_source_key = 10 and t1.order_state = 1 then
                    1
                 end),
           0),
       nvl(count(case
                   when t1.sales_source_key = 20 and
                        t1.sales_source_second_key not in
                        (20003，20013，20016，20018，20019，20023) and t1.order_state = 1 then
                    1
                 end),
           0),
       nvl(count(case
                   when t1.sales_source_key = 30 and t1.order_state = 1 then
                    1
                 end),
           0),
       nvl(sum(case
                 when t1.sales_source_key = 20 and
                      t1.sales_source_second_key not in
                      (20003，20013，20016，20018，20019，20023) and t1.order_state = 1 then
                  t1.order_amount
               end),
           0),
       nvl(count(case
                   when t1.sales_source_key = 20 and
                        t1.sales_source_second_key not in
                        (20003，20013，20016，20018，20019，20023) and t1.order_state = 1 then
                    1
                 end),
           0),
       nvl(max(case
                 when t1.sales_source_key = 20 and
                      t1.sales_source_second_key not in
                      (20003，20013，20016，20018，20019，20023) and t1.order_state = 1 then
                  t1.order_amount
               end),
           0),
       nvl(min(case
                 when t1.sales_source_key = 20 and
                      t1.sales_source_second_key not in
                      (20003，20013，20016，20018，20019，20023) and t1.order_state = 1 then
                  t1.order_date_key
               end),
           0),
       nvl(max(case
                 when t1.sales_source_key = 20 and
                      t1.sales_source_second_key not in
                      (20003，20013，20016，20018，20019，20023) and t1.order_state = 1 then
                  t1.order_date_key
               end),
           0),
       nvl(count(case
                   when t1.sales_source_key = 20 and
                        t1.sales_source_second_key in (20015, 20017) and
                        t1.order_state = 1 then
                    1
                 end),
           0),
       nvl(count(case
                   when t1.sales_source_key = 20 and
                        t1.sales_source_second_key in (20006, 20021) and
                        t1.order_state = 1 then
                    1
                 end),
           0),
       nvl(count(case
                   when t1.sales_source_key = 20 and
                        t1.sales_source_second_key in (20007, 20022) and
                        t1.order_state = 1 then
                    1
                 end),
           0),
       nvl(count(case
                   when t1.sales_source_key = 20 and
                        t1.sales_source_second_key not in
                        (20006,
                         20021,
                         20007,
                         20022,
                         20015,
                         20017,
                         20003,
                         20013,
                         20016,
                         20018,
                         20019,
                         20023) and t1.order_state = 1 then
                    1
                 end),
           0)
      
        into valid_amount,
             valid_count,
             valid_max_amount,
             fist_order_date,
             last_order_date,
             tv_valid_count,
             web_valid_count,
             ob_valid_count,
             web_validamount,
             web_validcount,
             web_valid_max_amount,
             web_first_order_date,
             web_last_order_date,
             apporder_count,
             wxorder_count,
             waporder_count,
             pcorder_count
      
        from fact_order t1
       where t1.member_key = var_array(i).member_key
            --and t1.order_state = 1
         and t1.order_date_key <=startpoint;
             --to_number(to_char(sysdate - 1, 'yyyymmdd'));
    
      update /*+ index(l MEMBER_BP_IDX) */ dim_member l
         set l.valid_orderamount     = valid_amount,
             l.valid_ordercount      = valid_count,
             l.max_unit_price        = valid_max_amount,
             l.first_order_date_key  = fist_order_date,
             l.last_order_date_key   = last_order_date,
             l.tv_order_count        = tv_valid_count,
             l.web_order_count       = web_valid_count,
             l.ob_order_count        = ob_valid_count,
             l.validw_orderamount    = web_validamount,
             l.validw_ordercount     = web_validcount,
             l.maxw_unit_price       = web_valid_max_amount,
             l.firstw_order_date_key = web_first_order_date,
             l.lastw_order_date_key  = web_last_order_date,
             l.app_order_count       = apporder_count,
             l.wx_order_count        = wxorder_count,
             l.wap_order_count       = waporder_count,
             l.pc_order_count        = pcorder_count,
             l.ch_date_key           = var_array(i).posting_date_key
       where l.member_bp = var_array(i).member_key;
    
      commit;
    
    end loop;
  
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
end processdimmemberodupd1;
/

