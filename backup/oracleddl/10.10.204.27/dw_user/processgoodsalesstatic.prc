???create or replace procedure dw_user.processgoodsalesstatic(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：计算商品的前一天，7天，15天，1个月的平均订购件数
       单规格商品数量选择功能更新了默认值的规则及周期选择
  
  作者时间：bobo  2016-04-06
  */

begin

  sp_name          := 'processgoodsalesstatic'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_goods_sales_static'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from FACT_goods_sales_static;

  insert into FACT_goods_sales_static
    (item_code, DAY_month, DAY_FIFTEEN, day_seven, day_one)
    (select p.goods_common_key as item_code,
            (case
              when p.DAY_month is not null then
               p.DAY_month
              else
               0
            end) as DAY_month,
            (case
              when p1.DAY_FIFTEEN is not null then
               p.DAY_month
              else
               0
            end) as DAY_FIFTEEN,
            (case
              when p2.day_seven is not null then
               p.DAY_month
              else
               0
            end) as day_seven,
            (case
              when p3.day_one is not null then
               p.DAY_month
              else
               0
            end) as day_one
       from (select goods_common_key, --sum(nums) / count(distinct(order_key)) as DAY_month,
                    sum(case
                          when nums > 1 then
                           1
                          else
                           0
                        end) / count(1) * 100 as DAY_month
               from fact_goods_sales
              where posting_date_key between
                    to_number(to_char(to_date(sysdate) - 31, 'yyyymmdd')) and
                    to_number(to_char(to_date(sysdate) - 1, 'yyyymmdd'))
                and order_state = 1
              group by goods_common_key) p
       left join
     
      (select goods_common_key, --sum(nums) / count(distinct(order_key)) as DAY_FIFTEEN,
             sum(case
                   when nums > 1 then
                    1
                   else
                    0
                 end) / count(1) as DAY_FIFTEEN
        from fact_goods_sales
       where posting_date_key between
             to_number(to_char(to_date(sysdate) - 16, 'yyyymmdd')) and
             to_number(to_char(to_date(sysdate) - 1, 'yyyymmdd'))
         and order_state = 1
       group by goods_common_key) p1
         on p.goods_common_key = p1.goods_common_key
       left join
     
      (select goods_common_key, --sum(nums) / count(distinct(order_key)) as day_seven,
             sum(case
                   when nums > 1 then
                    1
                   else
                    0
                 end) / count(1) as day_seven
        from fact_goods_sales
       where posting_date_key between
             to_number(to_char(to_date(sysdate) - 8, 'yyyymmdd')) and
             to_number(to_char(to_date(sysdate) - 1, 'yyyymmdd'))
         and order_state = 1
       group by goods_common_key) p2
         on p.goods_common_key = p2.goods_common_key
       left join
     
      (select goods_common_key, --sum(nums)/count(distinct(order_key)) as day_one,
             sum(case
                   when nums > 1 then
                    1
                   else
                    0
                 end) / count(1) as day_one
        from fact_goods_sales
       where posting_date_key =
             to_number(to_char(to_date(sysdate) - 1, 'yyyymmdd'))
         and order_state = 1
       group by goods_common_key) p3
         on p.goods_common_key = p3.goods_common_key);

  insert_rows := sql%rowcount;
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
  
end processgoodsalesstatic;
/

