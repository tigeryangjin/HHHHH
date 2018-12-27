???create or replace procedure dw_user.processweekstats(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processweekstats'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_week_stats
    (visit_date_key,
     application_name,
     uvcnt,
     ipcnt,
     newvtcount,
     pvcnt,
     avgpv,
     avglife_time,
     newvtrate,
     bonusrate)
    select a1.visit_date_key, --as "统计日期",
           decode(a1.channel_key,
                  1,
                  '官网+商城',
                  2,
                  '微信',
                  3,
                  'APP',
                  4,
                  '3G') as application_name, --as "渠道",
           a1.uvcnt, -- as "访客数量",
           a1.ipcnt, -- as "ip数量",
           c1.newvtcount, --as "新访客数量",
           a1.pvcnt, -- as "浏览数量",
           trunc(a1.avgpv, 2) as avgpv, -- as "平均浏览量",
           trunc(b1.avglife_time, 2) as avglife_time, -- as "平均浏览时长",
           trunc((c1.newvtcount / a1.uvcnt) * 100, 2) || '%' as newvtrate, --as "新访客率",
           b1.bonusrate --as "跳出率",
    -- b1.bonusrate1 -- as "跳出率2",
    -- b1.cntstart --   as "会话数(APP启动次数)"
      from (select a.visit_date_key,
                   a.channel_key,
                   count(distinct a.device_key) as uvcnt,
                   count(distinct a.ip) as ipcnt,
                   count(a.id) as pvcnt,
                   (count(a.id) / count(distinct a.device_key)) avgpv
            --(sum(a.page_staytime)/count(a.id)) as avgstaytime
              from fact_page_view a
             where a.visit_date_key=startpoint-- to_number(to_char((sysdate - 1), 'yyyymmdd')) 
             group by a.visit_date_key, a.channel_key) a1,
           
           (select b.start_date_key,
                   b.channel_key,
                   
                   trunc((count(case
                                  when b.page_count = 1 and
                                       b.application_key not in (10, 20) then
                                   1
                                  when b.page_count <= 2 and b.application_key in (10, 20) then
                                   1
                                
                                end) / count(b.id)) * 100,
                         2) || '%' as bonusrate,
                   
                   (sum(b.life_time) / count(b.id)) as avglife_time
            -- count(b.session_key) as cntstart
              from fact_session b
             where b.start_date_key=startpoint--to_number(to_char((sysdate - 1), 'yyyymmdd'))
             group by b.start_date_key, b.channel_key) b1,
           
           (select c.create_date_key,
                   c.channel_key,
                   count(c.vistor_key) as newvtcount
              from fact_visitor_register c
             where c.create_date_key=startpoint--to_number(to_char((sysdate - 1), 'yyyymmdd'))
             group by c.create_date_key, c.channel_key) c1
     where a1.visit_date_key = b1.start_date_key
       and b1.start_date_key = c1.create_date_key
       and a1.channel_key = b1.channel_key
       and b1.channel_key = c1.channel_key;

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
end processweekstats;
/

