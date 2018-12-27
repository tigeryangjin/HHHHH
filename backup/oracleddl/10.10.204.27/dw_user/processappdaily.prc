???create or replace procedure dw_user.processappdaily is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processappdaily'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_app'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  insert into fact_daily_app
    (visit_date_key,
     iosnewvt,
     aznewvt,
     newvtcount,
     iosvt,
     azvt,
     uvcnt,
     iosmembercnt,
     andmembercnt,
     cntstart,
     lcrate,
     tvsmrs,
     zbsmrs,
     pvcnt,
     avgpv,
     avglife_time,
     newvtrate,
     bonusrate,
     orderrate
     
     )
    select x1.visit_date_key,
           x2.iosnewvt,
           x2.aznewvt,
           x2.newvtcount,
           x1.iosvt,
           x1.azvt,
           x1.uvcnt,
           x4.iosmembercnt,
           x4.andmembercnt,
           x3.cntstart,
           --trunc((x1.lccnt / x1.uvcnt), 2) as lcrate,
           round(((select count(distinct visitor_key)
                     from (select visitor_key
                             from fact_session
                            where start_date_key =
                                  to_number(to_char(sysdate - 1, 'yyyymmdd'))
                              and application_key in (10, 20)
                           intersect
                           select vistor_key
                             from fact_visitor_register
                            where create_date_key =
                                  to_number(to_char(sysdate - 2, 'yyyymmdd'))
                              and application_key in (10, 20))) /
                 (select count(distinct vistor_key)
                     from fact_visitor_register
                    where create_date_key =
                          to_number(to_char(sysdate - 2, 'yyyymmdd'))
                      and application_key in (10, 20))),
                 2) as lcrate,
           x6.tvsmrs,
           x7.zbsmrs,
           x1.pvcnt,
           round(x1.avgpv, 2) as avgpv,
           round(x3.avglife_time, 2) as avglife_time,
           round((x2.newvtcount / x1.uvcnt), 2) as newvtrate,
           x3.bonusrate,
           round((x5.orderrs / x1.uvcnt), 3) as orderrate
      from (select a.visit_date_key,
                   count(distinct(case
                                    when a.application_key = 10 then
                                     a.device_key
                                  end)) as iosvt,
                   count(distinct(case
                                    when a.application_key = 20 then
                                     a.device_key
                                  end)) as azvt,
                   count(distinct a.device_key) as uvcnt,
                   (count(a.id) / count(distinct a.device_key)) avgpv,
                   count(a.id) as pvcnt
            
            /* count(distinct(case
              when exists
               (select *
                      from fact_session n3
                     where n3.visitor_key = a.visitor_key
                          --and n3.start_date_key=a.visit_date_key
                       and n3.start_date_key =
                           to_number(to_char(sysdate - 2, 'yyyymmdd'))) then
               a.visitor_key
            end)) as lccnt*/
            
              from fact_page_view a
             where a.visit_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and a.application_key in (10, 20)
             group by a.visit_date_key) x1,
           
           (select c.create_date_key,
                   count(case
                           when c.application_key = 10 then
                            1
                         end) as iosnewvt,
                   count(case
                           when c.application_key = 20 then
                            1
                         end) as aznewvt,
                   count(c.vistor_key) as newvtcount
              from fact_visitor_register c
             where c.create_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and c.channel_key = 3
             group by c.create_date_key) x2,
           
           (select b.start_date_key,
                   trunc((count(case
                                  when b.page_count <= 2 then
                                   1
                                end) / count(b.id)),
                         2) as bonusrate /*跳出率*/,
                   (sum(b.life_time) / count(b.id)) as avglife_time,
                   count(b.session_key) as cntstart
              from fact_session b
             where b.start_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and b.channel_key = 3
             group by b.start_date_key) x3,
           
           (select d.member_time,
                   count(case
                           when d.register_appname = 'KLGiPhone' then
                            1
                         end) as iosmembercnt,
                   count(case
                           when d.register_appname = 'KLGAndroid' then
                            1
                         end) as andmembercnt
              from fact_ecmember d
             where d.register_appname in ('KLGiPhone', 'KLGAndroid')
               and d.member_time =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
             group by d.member_time) x4,
           (select e.add_time, count(distinct e.cust_no) as orderrs
              from fact_ec_order e
             where e.add_time = to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and e.app_name in ('KLGAndroid', 'KLGiPhone')
               and (
                   (e.payment_code = 'offline' and e.order_state!=0) or
                   e.order_state in (20, 30, 40, 50))
             group by e.add_time) x5,
           
           /* (select f.visit_date_key, count(distinct f.device_key) as tvsmrs
            from fact_page_view f
           where f.visit_date_key =
                 to_number(to_char(sysdate - 1, 'yyyymmdd'))
                  and  f.page_key=24084
                  --and  f.page_name='Tvdownload' 
           group by f.visit_date_key) x6,*/
           
           (select to_number(to_char(sysdate - 1, 'yyyymmdd')) as visit_date_key,
                   nvl(max(tvsmrs), 0) as tvsmrs
              from (select f.visit_date_key,
                           nvl(count(distinct f.device_key), 0) as tvsmrs /*TV扫码人数*/
                      from fact_page_view f
                     where f.visit_date_key =
                           to_number(to_char(sysdate - 1, 'yyyymmdd'))
                       and f.page_key = 24084
                    --and  f.page_name='Tvdownload' 
                     group by f.visit_date_key)) x6,
           
           (select f.visit_date_key, count(distinct f.device_key) as zbsmrs
              from fact_page_view f
             where f.visit_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and f.page_key = 39910
             group by f.visit_date_key) x7
     where x1.visit_date_key = x2.create_date_key
       and x2.create_date_key = x3.start_date_key
       and x3.start_date_key = x4.member_time
       and x4.member_time = x5.add_time
       and x5.add_time = x6.visit_date_key(+)
       and x6.visit_date_key = x7.visit_date_key(+);

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
end processappdaily;
/

