???create or replace procedure dw_user.processgoodspageview(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  now_day     number;
  now_days    number;
  now_hour    number;
  now_hours   number;
  insert_total number;

  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：商品维度计算表
       
  
  作者时间：bobo  2016-07-19
  */

begin

  sp_name          := 'processgoodspageview'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_goods_page_view'; --此处需要手工录入该PROCEDURE操作的表格
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

  select to_number(to_char(sysdate, 'yyyymmdd')) into now_day from dual;
  select to_number(to_char(sysdate - postday / 24, 'yyyymmdd'))
    into now_days
    from dual;
  select to_number(to_char(sysdate, 'hh24')) as now_hour
    into now_hour
    from dual;
  select to_number(to_char(sysdate - postday / 24, 'hh24'))
    into now_hours
    from dual;
  --先清除数据
  if now_hours = now_days then 
    select to_number(sum(p.pv_nums)) into insert_total
         from (select
                      count(1) as pv_nums
                 from fact_page_view
                where visit_date_key = now_day
                  and VISIT_HOUR_KEY between now_hours and now_hour
                  and page_name = 'Good'
                  and trim(translate(nvl(page_value, 'x'), '0123456789', ' ')) is NULL
                group by page_value) p;
   else
     select to_number(sum(p.pv_nums)) into insert_total from (
  select count(1) as pv_nums
                 from fact_page_view
                where (visit_date_key = now_day and
                      VISIT_HOUR_KEY <= now_hour)
                   or (visit_date_key = now_days and
                      VISIT_HOUR_KEY > now_hours)
                  and page_name = 'Good'
                  and trim(translate(nvl(page_value, 'x'), '0123456789', ' ')) is NULL
                group by page_value) p;
  end if;
  
  if insert_total>0 then
    begin
      EXECUTE IMMEDIATE 'truncate table fact_goods_page_view';
    end;
    if now_day = now_days then
      --4小时内如果是同一天的话
      now_hours := now_hours + 1;
      insert into fact_goods_page_view
        (ITEM_CODE, GOODS_COMMON_KEY, PV_NUMS)
        (select g.item_code, g.goods_commonid as GOODS_COMMON_KEY, p.pv_nums
           from (select to_number(page_value) as page_value,
                        count(1) as pv_nums
                   from fact_page_view
                  where visit_date_key = now_day
                    and VISIT_HOUR_KEY between now_hours and now_hour
                    and page_name = 'Good'
                    and trim(translate(nvl(page_value, 'x'), '0123456789', ' ')) is NULL
                  group by page_value) p
          inner join dim_ec_good g
             on g.goods_commonid = p.page_value);
    else
      --4小时内不是同一天那就计算两次
      insert into fact_goods_page_view
        (ITEM_CODE, GOODS_COMMON_KEY, PV_NUMS)
        (select g.item_code, g.goods_commonid as GOODS_COMMON_KEY, p.pv_nums
           from (select to_number(page_value) as page_value,
                        count(1) as pv_nums
                   from fact_page_view
                  where ((visit_date_key = now_day and
                        VISIT_HOUR_KEY <= now_hour)
                     or (visit_date_key = now_days and
                        VISIT_HOUR_KEY > now_hours))
                    and page_name = 'Good'
                    and trim(translate(nvl(page_value, 'x'), '0123456789', ' ')) is NULL
                  group by page_value) p
          inner join dim_ec_good g
             on g.goods_commonid = p.page_value);
    end if;
  end if;
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
end processgoodspageview;
/

