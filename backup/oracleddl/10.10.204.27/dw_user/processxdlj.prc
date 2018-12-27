???create or replace procedure dw_user.processxdlj(startid in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;

begin

  sp_name          := 'processxdlj'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'tj_dgsx'; --此处需要手工录入该PROCEDURE操作的表格
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
  --crmpostdates := 0;
  select max(member_key) into crmpostdates from tj_xdlj;

  if crmpostdates is null then
    crmpostdates := 0;
  end if;
  insert into tj_xdlj
    (member_key,
     tv_first_date,
     tv_nums,
     ec_first_date,
     ec_nums,
     app_first_date,
     app_nums,
     wx_nums,
     appwx_first_date,
     pc_nums,
     pc_first_date)
    select member_key,
           min(case
                 when o.sales_source_key = 10 then
                  o.posting_date_key
                 else
                  99999999
               end) as tv_first_date,
           sum(case
                 when o.sales_source_key = 10 then
                  1
                 else
                  0
               end) as tv_nums,
           min(case
                 when o.sales_source_key = 20 then
                  o.posting_date_key
                 else
                  99999999
               end) as ec_first_date,
           sum(case
                 when o.sales_source_key = 20 then
                  1
                 else
                  0
               end) as ec_nums,
           min(case
                 when o.sales_source_second_key = 20017 then
                  o.posting_date_key
                 else
                  99999999
               end) as app_first_date,
           sum(case
                 when o.sales_source_second_key = 20017 or
                      o.sales_source_second_key = 20015 then
                  1
                 else
                  0
               end) as app_nums,
           sum(case
                 when o.sales_source_second_key = 20021 or
                      o.sales_source_second_key = 20006 then
                  1
                 else
                  0
               end) as wx_nums,
           min(case
                 when o.sales_source_second_key = 20021 or
                      o.sales_source_second_key = 20017 or
                      o.sales_source_second_key = 20006 or
                      o.sales_source_second_key = 20015 then
                  o.posting_date_key
                 else
                  99999999
               end) as appwx_nums,
           
           sum(case
                 when o.sales_source_second_key = 20001 or
                      o.sales_source_second_key = 20020 then
                  1
                 else
                  0
               end) as pc_nums,
           min(case
                 when o.sales_source_second_key = 20021 or
                      o.sales_source_second_key = 20020 or
                      o.sales_source_second_key = 20006 or
                      o.sales_source_second_key = 20001 then
                  o.posting_date_key
                 else
                  99999999
               end) as pcwx_nums
    
      from fact_order o
     where o.member_key in
           (select member_key from (select member_key
              from ls_member_order
             where member_key > crmpostdates order by member_key asc) where 
                rownum between 0 and 10000 )
       and order_state = 1
     group by member_key;

  commit;
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
end processxdlj;
/

