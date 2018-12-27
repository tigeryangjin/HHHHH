???create or replace procedure dw_user.processdgsx(startid in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  crmpostdates number;
  --total_nums number;
  
begin

  sp_name          := 'processdgsx'; --需要手工填入所写PROCEDURE的名称
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
  select max(member_key) into crmpostdates from tj_dgsx;

  if crmpostdates is null then
    crmpostdates := 0;
  end if;
  declare
  type type_arrays is record(member_key number(20));

  type type_array is table of type_arrays index by binary_integer; --类似二维数组 

  var_array type_array;
  
  begin
  select * bulk collect
      into var_array
      from (select p.member_key
              from (select member_key, rownum rn
                      from ls_member_order
                     where member_key > crmpostdates order by member_key asc) p
             where p.rn between 0 and startid);
  
  for i in 1 .. var_array.count loop
    insert into tj_dgsx (
    member_key,
    ec_nums,
    ec_order_amount,
    ec_sku_nums,
    ec_nums_yx,
    ec_order_amount_yx,
    ec_sku_nums_yx,
    ec_Counpos_amount_yx,
    ec_Discount_amount_yx,
    last_cancel_date,
    ec_last_time,
    sales_source_last,
    app_nums,
    app_order_amount,
    app_sku_nums,
    app_nums_yx,
    app_order_amount_yx,
    app_sku_nums_yx,
    app_Counpos_amount_yx,
    app_Discount_amount_yx
    ) select max(o.member_key) as member_key,sum(case when o.sales_source_key=20 then 1 else 0 end) as ec_nums,
sum(case when o.sales_source_key=20 then o.order_amount else 0 end) as ec_order_amount,--全部ec通路订单，预订购也算
sum(case when o.sales_source_key=20 then o.sku_nums else 0 end) as ec_sku_nums,
sum(case when o.sales_source_key=20 and o.order_state=1 then 1 else 0 end) as ec_nums_yx,
sum(case when o.sales_source_key=20 and o.order_state=1 then o.order_amount else 0 end) as ec_order_amount_yx,--有效订单和部分预订购未取消
sum(case when o.sales_source_key=20 and o.order_state=1 then o.sku_nums else 0 end) as ec_sku_nums_yx,
sum(case when o.sales_source_key=20 and o.order_state=1 then o.Counpos_amount else 0 end) as ec_Counpos_amount_yx,
sum(case when o.sales_source_key=20 and o.order_state=1 then o.Discount_amount else 0 end) as ec_Discount_amount_yx,
max(r.date_key) as last_cancel_date,
max(case when o.sales_source_key=20 then o.posting_date_key else 0 end) as ec_last_time,
max(s.sales_source_second_key) as sales_source_last,

 sum(case when o.sales_source_second_key=20017 or o.sales_source_second_key=20015 then 1 else 0 end) as app_nums,
sum(case when o.sales_source_second_key=20017 or o.sales_source_second_key=20015 then o.order_amount else 0 end) as app_order_amount,
sum(case when (o.sales_source_second_key=20017 or o.sales_source_second_key=20015) then o.sku_nums else 0 end) as app_sku_nums,--同上处理逻辑
sum(case when (o.sales_source_second_key=20017 or o.sales_source_second_key=20015) and o.order_state=1 then 1 else 0 end) as app_nums_yx,
sum(case when (o.sales_source_second_key=20017 or o.sales_source_second_key=20015) and o.order_state=1 then o.order_amount else 0 end) as app_order_amount_yx,
sum(case when (o.sales_source_second_key=20017 or o.sales_source_second_key=20015) and o.order_state=1 then o.sku_nums else 0 end) as app_sku_nums_yx,
sum(case when (o.sales_source_second_key=20017 or o.sales_source_second_key=20015) and o.order_state=1 then o.Counpos_amount else 0 end) as app_Counpos_amount_yx,
sum(case when (o.sales_source_second_key=20017 or o.sales_source_second_key=20015) and o.order_state=1 then o.Discount_amount else 0 end) as app_Discount_amount_yx

 from fact_order o
 left join (select max(posting_date_key) as date_key,member_key from fact_order_reverse where Order_type=0 and Cancel_state=0 and member_key=var_array(i).member_key group by member_key) r
 on r.member_key=o.member_key
 left join (
 select * from (select sales_source_second_key,member_key from fact_order where member_key=var_array(i).member_key and sales_source_key=20 order by posting_date_key desc
 ) where rownum=1) s on s.member_key=o.member_key
  where o.member_key=var_array(i).member_key;
  commit;
      insert_rows := insert_rows+1;
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
end processdgsx;
/

