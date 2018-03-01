create or replace procedure processdailygoodszjstat(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：计算商品的上下架情况做统计
       
  
  作者时间：bobo  2016-04-06
  */

begin

  sp_name          := 'processdailygoodszjstat'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_goodszj_stat'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_daily_goodszj_stat
    (item_code, goods_name, matdl, matdlt, brand_id, brand_name)
    (select item_code,
            max(goods_name) as goods_name,
            max(matdl) as matdl,
            max(matdlt) as matdlt,
            max(brand_id) as brand_id,
            max(brand_name) as brand_name
       from dim_good
      where item_code not in
            (select item_code from fact_daily_goodszj_stat)
      group by item_code);

  update fact_daily_goodszj_stat t
     set (t.zj_state, t.xj_time, t.zj_time) =
         (select p.zj_state, p.xj_time, p.zj_time
            from (select z.item_code,
                         (case
                           when zj.item_code is null then
                            0
                           else
                            1
                         end) as zj_state, --在架 
                         (case
                           when z.zj_state = 1 and zj.item_code is null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 1 and zj.item_code is not null and
                                z.xj_time is null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 1 and zj.item_code is not null and
                                z.xj_time is not null then
                            z.xj_time
                           when z.zj_state = 0 and z.xj_time is null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 0 and z.xj_time is not null then
                            z.xj_time
                         end) as xj_time,
                         (case
                           when z.zj_state = 1 then
                            z.zj_time
                           when z.zj_state = 0 and zj.item_code is not null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 0 and zj.item_code is null and
                                z.zj_time is null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 0 and zj.item_code is null and
                                z.zj_time is not null then
                            z.zj_time
                         
                         end) as zj_time
                  
                    from fact_daily_goodszj_stat z
                    left join fact_daily_goodzj zj
                      on zj.item_code = z.item_code) p
           where t.item_code = p.item_code
           group by p.zj_state, p.xj_time, p.zj_time)
   where exists
   (select 1
            from (select z.item_code,
                         (case
                           when zj.item_code is null then
                            0
                           else
                            1
                         end) as zj_state, --在架 
                         (case
                           when z.zj_state = 1 and zj.item_code is null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 1 and zj.item_code is not null and
                                z.xj_time is null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 1 and zj.item_code is not null and
                                z.xj_time is not null then
                            z.xj_time
                           when z.zj_state = 0 and z.xj_time is null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 0 and z.xj_time is not null then
                            z.xj_time
                         end) as xj_time,
                         (case
                           when z.zj_state = 1 then
                            z.zj_time
                           when z.zj_state = 0 and zj.item_code is not null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 0 and zj.item_code is null and
                                z.zj_time is null then
                            to_number(to_char(sysdate, 'yyyymmdd'))
                           when z.zj_state = 0 and zj.item_code is null and
                                z.zj_time is not null then
                            z.zj_time
                         
                         end) as zj_time
                  
                    from fact_daily_goodszj_stat z
                    left join fact_daily_goodzj zj
                      on zj.item_code = z.item_code) p
           where p.item_code = t.item_code);

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
  
end processdailygoodszjstat;
/
