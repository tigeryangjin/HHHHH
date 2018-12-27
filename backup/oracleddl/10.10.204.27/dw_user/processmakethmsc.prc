???create or replace procedure dw_user.processmakethmsc(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  number;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processmakethmsc'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_hmsc_market'; --此处需要手工录入该PROCEDURE操作的表格
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

  begin
    delete from fact_pv_hmsc;
    delete from fact_uv_hmsc;
    delete from fact_order_hmsc;
    delete from fact_session_hmsc;
    delete from fact_newcust_hmsc;
    commit;
  
    insert into fact_pv_hmsc
      (visit_date_key,
       application_key,
       hmmd,
       hmpl,
       xlflag,
       mcnt,
       vcnt,
       scnt)
      select c1.visit_date_key,
             decode(c1.application_key, 10, 'IOS', 20, 'ANDROID') as application_key,
             (select z1.hmmd from dim_hmsc z1 where z1.hmsc = c1.hmsc) as hmmd,
             (select z1.hmpl from dim_hmsc z1 where z1.hmsc = c1.hmsc) as hmpl,
             case
               when exists
                (select *
                       from fact_visitor_register t1
                      where t1.create_date_key between
                            to_number(to_char(add_months(to_date(to_char(startpoint),
                                                                 'yyyymmdd'),
                                                         -1),
                                              'yyyymmdd')) and startpoint
                        and t1.vistor_key = c1.device_key) then
                '新用户'
               else
                '老用户'
             end as xlflag,
             count(distinct(case
                              when c1.member_key != 0 then
                               c1.member_key
                            end)) as mcnt,
             count(distinct c1.device_key) as vcnt,
             count(distinct c1.session_key) as scnt
        from fact_page_view c1
       where c1.visit_date_key = startpoint
         and c1.application_key in (10, 20)
       group by c1.visit_date_key,
                decode(c1.application_key, 10, 'IOS', 20, 'ANDROID'),
                c1.hmsc,
                case
                  when exists
                   (select *
                          from fact_visitor_register t1
                         where t1.create_date_key between
                               to_number(to_char(add_months(to_date(to_char(startpoint),
                                                                    'yyyymmdd'),
                                                            -1),
                                                 'yyyymmdd')) and startpoint
                           and t1.vistor_key = c1.device_key) then
                   '新用户'
                  else
                   '老用户'
                end;
  
    commit;
  
    insert into fact_uv_hmsc
      (create_date_key, application_key, hmmd, hmpl, xlflag, nvcnt)
      select c2.create_date_key,
             decode(c2.application_key, 10, 'IOS', 20, 'ANDROID') as application_key,
             (select z1.hmmd from dim_hmsc z1 where z1.hmsc = c2.hmsc) as hmmd,
             (select z1.hmpl from dim_hmsc z1 where z1.hmsc = c2.hmsc) as hmpl,
             '新用户' as xlflag,
             count(c2.vistor_key) as nvcnt
        from fact_visitor_register c2
       where c2.create_date_key = startpoint
         and c2.application_key in (10, 20)
       group by c2.create_date_key,
                decode(c2.application_key, 10, 'IOS', 20, 'ANDROID'),
                c2.hmsc,
                '新用户';
  
    commit;
  
    insert into fact_order_hmsc
      (order_create_key,
       application_key,
       hmmd,
       hmpl,
       xlflag,
       orderrs,
       ordercs,
       orderamount,
       ordercgrs,
       ordercgcs,
       ordercgamount)
    
      select c3.add_time as order_create_key,
             decode(c4.application_key, 10, 'IOS', 20, 'ANDROID') as application_key,
             (select z1.hmmd from dim_hmsc z1 where z1.hmsc = c4.hmsc) as hmmd,
             (select z1.hmpl from dim_hmsc z1 where z1.hmsc = c4.hmsc) as hmpl,
             case
               when exists
                (select *
                       from fact_visitor_register t1
                      where t1.create_date_key between
                            to_number(to_char(add_months(to_date(to_char(startpoint),
                                                                 'yyyymmdd'),
                                                         -1),
                                              'yyyymmdd')) and startpoint
                        and t1.vid = c3.vid) then
                '新用户'
               else
                '老用户'
             end as xlflag,
             count(distinct c3.cust_no) as orderrs,
             count(distinct c3.order_sn) as ordercs,
             sum(c3.order_amount) as orderamount,
             count(distinct(case
                              when (c3.payment_code = 'offline' or
                                   c3.order_state in (20, 30, 40, 50)) then
                               c3.cust_no
                            end)) as ordercgrs,
             count(distinct(case
                              when (c3.payment_code = 'offline' or
                                   c3.order_state in (20, 30, 40, 50)) then
                               c3.order_sn
                            end)) as ordercgcs,
             sum(case
                   when (c3.payment_code = 'offline' or
                        c3.order_state in (20, 30, 40, 50)) then
                    c3.order_amount
                 end) as ordercgamount
        from fact_ec_order c3, fact_visitor_register c4
       where c3.vid = c4.vid
         and c3.add_time = startpoint
         and c3.app_name in ('KLGAndroid', 'KLGiPhone')
       group by c3.add_time,
                decode(c4.application_key, 10, 'IOS', 20, 'ANDROID'),
                c4.hmsc,
                c4.hmsc,
                case
                  when exists
                   (select *
                          from fact_visitor_register t1
                         where t1.create_date_key between
                               to_number(to_char(add_months(to_date(to_char(startpoint),
                                                                    'yyyymmdd'),
                                                            -1),
                                                 'yyyymmdd')) and startpoint
                           and t1.vid = c3.vid) then
                   '新用户'
                  else
                   '老用户'
                end;
  
    commit;
  
    insert into fact_session_hmsc
      (start_date_key, application_key, hmmd, hmpl, xlflag, avglife_time)
      select c5.start_date_key,
             decode(c5.application_key, 10, 'IOS', 20, 'ANDROID') as application_key,
             (select z1.hmmd from dim_hmsc z1 where z1.hmsc = c5.hmsc) as hmmd,
             (select z1.hmpl from dim_hmsc z1 where z1.hmsc = c5.hmsc) as hmpl,
             case
               when exists
                (select *
                       from fact_visitor_register t1
                      where t1.create_date_key between
                            to_number(to_char(add_months(to_date(to_char(startpoint),
                                                                 'yyyymmdd'),
                                                         -1),
                                              'yyyymmdd')) and startpoint
                        and t1.vid = c5.vid) then
                '新用户'
               else
                '老用户'
             end as xlflag,
             
             trunc((sum(c5.life_time) / count(c5.id)), 2) as avglife_time
        from fact_session c5
       where c5.start_date_key = startpoint
         and c5.application_key in (10, 20)
       group by c5.start_date_key,
                decode(c5.application_key, 10, 'IOS', 20, 'ANDROID'),
                c5.hmsc,
                c5.hmsc,
                case
                  when exists
                   (select *
                          from fact_visitor_register t1
                         where t1.create_date_key between
                               to_number(to_char(add_months(to_date(to_char(startpoint),
                                                                    'yyyymmdd'),
                                                            -1),
                                                 'yyyymmdd')) and startpoint
                           and t1.vid = c5.vid) then
                   '新用户'
                  else
                   '老用户'
                end;
  
    commit;
  
    insert into fact_newcust_hmsc
      (c_date_key, application_key, hmmd, hmpl, custcnt)
      select startpoint as c_date_key,
             decode(x1.application_key, 10, 'IOS', 20, 'ANDROID') as application_key,
             (select z1.hmmd from dim_hmsc z1 where z1.hmsc = x1.hmsc) as hmmd,
             (select z1.hmpl from dim_hmsc z1 where z1.hmsc = x1.hmsc) as hmpl,
             
             count(x1.member_key) as custcnt
        from fact_visitor_register x1
       where x1.application_key in (10, 20)
         and exists
       (select *
                from dim_vid_mem x2
               where x2.vid = x1.vid
                 and exists
               (select *
                        from fact_ecmember x3
                       where x3.member_time = startpoint
                         and x3.register_appname in
                             ('KLGAndroid', 'KLGiPhone')
                         and x3.member_crmbp = x2.member_key))
       group by startpoint, x1.application_key, x1.hmsc;
  
    commit;
  
    insert into fact_hmsc_market
      (visit_date_key,
       application_key,
       hmmd,
       hmpl,
       xlflag,
       mcnt,
       vcnt,
       scnt,
       avglife_time,
       orderrs,
       ordercs,
       orderamount,
       ordercgrs,
       ordercgcs,
       ordercgamount,
       nvcnt,
       mnewcnt)
    
      select a.visit_date_key,
             a.application_key,
             a.hmmd,
             a.hmpl,
             a.xlflag,
             nvl(a.mcnt, 0) as mcnt,
             nvl(a.vcnt, 0) as vcnt,
             nvl(a.scnt, 0) as scnt,
             nvl(b.avglife_time, 0) as avglife_time,
             nvl(c.orderrs, 0) as orderrs,
             nvl(c.ordercs, 0) as ordercs,
             nvl(c.orderamount, 0) as orderamount,
             nvl(c.ordercgrs, 0) as ordercgrs,
             nvl(c.ordercgcs, 0) as ordercgcs,
             nvl(c.ordercgamount, 0) as ordercgamount,
             nvl(d.nvcnt, 0) as nvcnt,
             nvl(e.custcnt, 0) as custcnt
        from (select * from fact_pv_hmsc where hmmd is not null) a,
             (select * from fact_session_hmsc where hmmd is not null) b,
             (select * from fact_order_hmsc where hmmd is not null) c,
             (select * from fact_uv_hmsc where hmmd is not null) d,
             (select * from fact_newcust_hmsc) e
       where a.visit_date_key = b.start_date_key
         and a.application_key = b.application_key
         and a.hmmd = b.hmmd
         and a.hmpl = b.hmpl
         and a.xlflag = b.xlflag
         and b.start_date_key = c.order_create_key(+)
         and b.application_key = c.application_key(+)
         and b.hmmd = c.hmmd(+)
         and b.hmpl = c.hmpl(+)
         and b.xlflag = c.xlflag(+)
         and b.start_date_key = d.create_date_key(+)
         and b.application_key = d.application_key(+)
         and b.hmmd = d.hmmd(+)
         and b.hmpl = d.hmpl(+)
         and b.xlflag = d.xlflag(+)
         and d.create_date_key = e.c_date_key(+)
         and d.application_key = e.application_key(+)
         and d.hmmd = e.hmmd(+)
         and d.hmpl = e.hmpl(+);
  
    commit;
  
    update fact_hmsc_market k1
       set k1.hmmd = '应用宝视频'
     where k1.visit_date_key = startpoint
       and k1.hmmd = 'yybsp';
  
    update fact_hmsc_market k1
       set k1.hmmd = '应用宝首页卡片'
     where k1.visit_date_key = startpoint
       and k1.hmmd = 'yybsykp';
  
    update fact_hmsc_market k1
       set k1.hmmd = '应用宝三图卡片'
     where k1.visit_date_key = startpoint
       and k1.hmmd = 'yybstkp';
  
    update fact_hmsc_market k1
       set k1.hmmd = '电商腾讯新闻'
     where k1.visit_date_key = startpoint
       and k1.hmmd = 'dstxxw';
  
    update fact_hmsc_market k1
       set k1.hmmd = '电商天天快报'
     where k1.visit_date_key = startpoint
       and k1.hmmd = 'dsttkb';
  
    update fact_hmsc_market k1
       set k1.hmmd = 'Android天天快报'
     where k1.visit_date_key = startpoint
       and k1.hmmd = 'azttkb';
  
    update fact_hmsc_market k1
       set k1.hmmd = 'Android微信'
     where k1.visit_date_key = startpoint
       and k1.hmmd = 'azxywx';
  
    /* select a.visit_date_key,
          a.application_key,
          a.hmmd,
          a.hmpl,
          a.xlflag,
          nvl(a.mcnt, 0) as mcnt,
          nvl(a.vcnt, 0) as vcnt,
          nvl(a.scnt, 0) as scnt,
          nvl(b.avglife_time, 0) as avglife_time,
          nvl(c.orderrs, 0) as orderrs,
          nvl(c.ordercs, 0) as ordercs,
          nvl(c.orderamount, 0) as orderamount,
          nvl(c.ordercgrs, 0) as ordercgrs,
          nvl(c.ordercgcs, 0) as ordercgcs,
          nvl(c.ordercgamount, 0) as ordercgamount,
          nvl(d.nvcnt, 0) as nvcnt
     from (select * from fact_pv_hmsc where hmmd is not null) a,
          (select * from fact_session_hmsc where hmmd is not null) b,
          (select * from fact_order_hmsc where hmmd is not null) c,
          (select * from fact_uv_hmsc where hmmd is not null) d
    where a.visit_date_key = b.start_date_key
      and a.application_key = b.application_key
      and a.hmmd = b.hmmd
      and a.hmpl = b.hmpl
      and a.xlflag = b.xlflag
      and b.start_date_key = c.order_create_key(+)
      and b.application_key = c.application_key(+)
      and b.hmmd = c.hmmd(+)
      and b.hmpl = c.hmpl(+)
      and b.xlflag = c.xlflag(+)
      and b.start_date_key = d.create_date_key(+)
      and b.application_key = d.application_key(+)
      and b.hmmd = d.hmmd(+)
      and b.hmpl = d.hmpl(+)
      and b.xlflag = d.xlflag(+);*/
  
    commit;
  
    insert into fact_daily_hmsc
      select t.visit_date_key,
             t.hmmd,
             sum(t.vcnt) as vcnt,
             sum(t.nvcnt) as nvcnt,
             sum(t.mcnt) as mcnt,
             sum(t.ordercgrs) as ordercgrs,
             sum(t.ordercgcs) as ordercgcs,
             sum(t.ordercgamount) as ordercgamount
        from fact_hmsc_market t
       where t.visit_date_key = startpoint
       group by t.visit_date_key, t.hmmd;
  
    commit;
  
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
  
end processmakethmsc;
/

