???create or replace procedure dw_happigo.process3gdaily is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'process3gdaily'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_3g'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_daily_3g
    (visit_date_key,
     uvcnt,
     newvtcount,
     pvcnt,
     ipcnt,
     avgpv,
     avglife_time,
     newvtrate,
     bonusrate,
     orderrate
     
     )
  
    select x1.visit_date_key,
           x1.uvcnt,
           x3.newvtcount,
           x1.pvcnt,
           x1.ipcnt,
           trunc(x1.avgpv, 2) as avgpv,
           trunc(x2.avglife_time, 2) as avglife_time,
           trunc((x3.newvtcount / x1.uvcnt), 2) as newvtrate,
           x2.bonusrate,
           trunc((x5.orderrs / x1.uvcnt), 3) as orderrate
      from (select a.visit_date_key,
                   
                   count(distinct a.visitor_key) as uvcnt,
                   (count(a.id) / count(distinct a.visitor_key)) avgpv,
                   count(a.id) as pvcnt,
                   count(distinct a.ip) as ipcnt
              from fact_page_view a
             where a.visit_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and a.application_key = 30
             group by a.visit_date_key) x1,
           
           (select b.start_date_key,
                   trunc((count(case
                                  when b.page_count <= 1 then
                                   1
                                end) / count(b.id)),
                         2) as bonusrate,
                   (sum(b.life_time) / count(b.id)) as avglife_time
            
              from fact_session b
             where b.start_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and b.application_key = 30
             group by b.start_date_key) x2,
           
           (select c.create_date_key, count(c.visitor_key) as newvtcount
              from fact_visitor c
             where c.create_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and c.application_key = 30
             group by c.create_date_key) x3,
           
           (select d.order_date_key, count(distinct d.member_key) as orderrs
              from fact_order d
             where d.order_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and d.channel_key = 4
             group by d.order_date_key) x5
     where x1.visit_date_key = x2.start_date_key
       and x2.start_date_key = x3.create_date_key
       and x3.create_date_key = x5.order_date_key;

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
end process3gdaily;
/

