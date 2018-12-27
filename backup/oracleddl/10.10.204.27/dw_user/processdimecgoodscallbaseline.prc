???create or replace procedure dw_user.processdimecgoodscallbaseline(date_nums in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：张全扫码购数据统计
       
  
  作者时间：bobo  2016-04-11
  */

begin

  sp_name          := 'processdimecgoodscallbaseline'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_goods_callbaseline'; --此处需要手工录入该PROCEDURE操作的表格
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

  /*IF date_nums<=20150001 then
    SELECT to_number(to_char(to_date(max(SYSDATE),'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd')) into DATE_NUMS FROM DUAL;
  end if;*/

  DELETE FROM oper_goods_callbaseline WHERE day_key = date_nums; --先删除当天数据，在重新导入那天数据

  insert into oper_goods_callbaseline
    select date_nums as day_key,
           g.item_code,
           sum(g.goods_num) as total,
           count(distinct(o.add_time)) as day_nums,
           ceil(sum(g.goods_num) / count(distinct(o.add_time))) as AVERAGE_NUMS
      from factec_order_goods g
      left join factec_order o
        on o.order_id = g.order_id
     where o.add_time between
           to_number(to_char(TO_DATE(date_nums, 'YYYY-MM-DD HH24') - 14,
                             'yyyymmdd')) and date_nums
     group by item_code
     order by sum(g.goods_num) desc;

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
end processdimecgoodscallbaseline;
/

