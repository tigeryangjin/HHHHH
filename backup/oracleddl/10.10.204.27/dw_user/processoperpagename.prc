???create or replace procedure dw_user.processoperpagename(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：根据计算日报表里面的行为记录的name
       
  
  作者时间：bobo  2016-07-19
  */

begin

  sp_name          := 'processoperpagename'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_page_name'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from oper_page_name where visit_date_key = postday;

  insert into oper_page_name
    (page_name, page_value, visit_date_key)
    (select page_name, page_value, postday as visit_date_key
       from fact_page_view
      where visit_date_key = postday
        and lower(page_name) in ('channel',
                                 'zt_detail2',
                                 'brand_details',
                                 'category_goodsList',
                                 'brand_goodslist')
      group by page_name, page_value);

  insert_rows := sql%rowcount;

  --ec_app_cms_homegroup
  merge into oper_page_name m --fzq1表是需要更新的表
  using (select to_char(group_id) as page_value,
                group_name as name,
                'Channel' as page_name
           from dim_ec_app_cms_homegroup) mm -- 关联表
  on (m.page_value = mm.page_value and m.page_name = mm.page_name) --关联条件
  when matched then --匹配关联条件，作更新处理
    update set m.name = mm.name; --此处只是说明可以同时更新多个字段。
  insert_rows := insert_rows + sql%rowcount;

  --ec_app_cms_zt2
  merge into oper_page_name m --fzq1表是需要更新的表
  using (select to_char(id) as page_value,
                name as name,
                'ZT_Detail2' as page_name
           from dim_ec_app_cms_zt2) mm -- 关联表
  on (m.page_value = mm.page_value and m.page_name = mm.page_name) --关联条件
  when matched then --匹配关联条件，作更新处理
    update set m.name = mm.name; --此处只是说明可以同时更新多个字段。
  insert_rows := insert_rows + sql%rowcount;

  --ec_app_cms_brand_zt
  merge into oper_page_name m --fzq1表是需要更新的表
  using (select to_char(id) as page_value,
                brand_name as name,
                'Brand_details' as page_name
           from dim_ec_app_cms_brand_zt) mm -- 关联表
  on (m.page_value = mm.page_value and m.page_name = mm.page_name) --关联条件
  when matched then --匹配关联条件，作更新处理
    update set m.name = mm.name; --此处只是说明可以同时更新多个字段。
  insert_rows := insert_rows + sql%rowcount;

  --ec_goods_class
  merge into oper_page_name m --fzq1表是需要更新的表
  using (select to_char(gc_id) as page_value,
                gc_name as name,
                'Category_GoodsList' as page_name
           from dim_ec_goods_class) mm -- 关联表
  on (m.page_value = mm.page_value and m.page_name = mm.page_name) --关联条件
  when matched then --匹配关联条件，作更新处理
    update set m.name = mm.name; --此处只是说明可以同时更新多个字段。
  insert_rows := insert_rows + sql%rowcount;

  --ec_brand
  merge into oper_page_name m --fzq1表是需要更新的表
  using (select to_char(brand_id) as page_value,
                brand_name as name,
                'Brand_GoodsList' as page_name
           from dim_ec_brand) mm -- 关联表
  on (m.page_value = mm.page_value and m.page_name = mm.page_name) --关联条件
  when matched then --匹配关联条件，作更新处理
    update set m.name = mm.name; --此处只是说明可以同时更新多个字段。
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
end processoperpagename;
/

