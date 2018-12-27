???create or replace procedure dw_user.processrejectreturn(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
begin
  sp_name          := 'processrejectreturn'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_ORDER_REVERSE'; --此处需要手工录入该PROCEDURE操作的表格
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
  --修改goods
  update fact_goods_sales_reverse r
     set (r.REJECT_RETURN) =
         (select max(to_number(o.ZTCMC008))
            from odshappigo.ods_order o
           where o.crmpostdat = to_char(postday)
             and o.crm_obj_id = to_number(r.order_h_key)
             and (o.CRM_PRCTYP = 'ZB01' or o.CRM_PRCTYP = 'ZA08'))
   where r.posting_date_key = postday;
  --修改order
  update fact_order_reverse r
     set (r.REJECT_RETURN) =
         (select max(to_number(o.ZTCMC008))
            from odshappigo.ods_order o
           where o.crmpostdat = to_char(postday)
             and o.crm_obj_id = to_number(r.Order_obj_ID)
             and (o.CRM_PRCTYP = 'ZB01' or o.CRM_PRCTYP = 'ZA08'))
   where r.posting_date_key = postday;
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
end processrejectreturn;
/

