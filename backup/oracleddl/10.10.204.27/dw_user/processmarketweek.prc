???create or replace procedure dw_user.processmarketweek(startpoint in number, endpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processmarketweek'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_weekly_market'; --此处需要手工录入该PROCEDURE操作的表格
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

  declare
    mcnt number;
  
    odcnt number;
  
  begin
  
    delete from tmp_message;
    delete from tmp_weikang;
    delete from tmp_dm;
    delete from tmp_remind;
    delete from tmp_scan;
    delete from tmp_interact;
    delete from tmp_tot;
    delete from tmp_nature;
    delete from tmp_0907_1;
    delete from tmp_0907_2;
    delete from tmp_0907_3;
    delete from tmp_0907_4;
    commit;
  
    insert into tmp_0907_1
      select c2.vid
        from fact_session c2
       where c2.start_date_key between
             to_number(startpoint) and
             to_number(endpoint)
         and application_key in (10, 20)
         and exists (select *
                from dim_hmsc g1
               where hmpl = '推广'
                 and g1.hmsc = c2.hmsc);
    commit;
    insert into tmp_0907_2
      select c3.vid
        from fact_daily_pcpromotion c3
       where c3.active_date_key between
             to_number(startpoint) and
             to_number(endpoint);
  
    commit;
    insert into tmp_0907_3
      select c3.vid
        from fact_daily_3gpromotion c3
       where c3.active_date_key between
             to_number(startpoint) and
             to_number(endpoint);
    commit;
  
    insert into tmp_0907_4
      select c5.vid
        from dim_vid_scan c5
       where c5.scan_date_key between
             to_number(startpoint) and
             to_number(endpoint);
  
    commit;
  
    insert into tmp_message
      select to_number(to_char(sysdate, 'yyyymmdd')) as date_key,
             trunc(avg(日活)) as message_uv,
             trunc(avg(注册)) as message_reg,
             trunc(avg(订购)) as message_od
        from (select count(distinct ip) 日活,
                     count(distinct c.vid) 注册,
                     count(distinct b.vid) 订购,
                     visit_date_key
                from (select vid, ip, visit_date_key
                        from fact_page_view
                       where visit_date_key between
                             startpoint and
                             endpoint
                         and (url like '%DXTX%')
                       group by vid, ip, visit_date_key) a
                left join
              
               (select vid, fist_ip, start_date_key
                 from (select vid, fist_ip, start_date_key, member_key
                         from fact_session
                        where start_date_key between
                              startpoint and
                              endpoint
                          and application_key > 20) s
                 join (select member_crmbp, member_time
                        from fact_ecmember
                       where member_time between
                             startpoint and
                             endpoint) ss
                   on s.member_key = ss.member_crmbp
                  and s.start_date_key = ss.member_time
                group by vid, fist_ip, start_date_key) c
                  on
              
               (a.ip = c.fist_ip and a.visit_date_key = c.start_date_key)
                left join
              
               (select vid, order_ip, add_time
                 from factec_order
                where add_time between startpoint and
                      endpoint
                  and order_state > 10
                group by vid, order_ip, add_time) b
                  on (a.ip = b.order_ip and a.visit_date_key = b.add_time)
               group by visit_date_key);
  
    commit;
  
    insert into tmp_weikang
      select to_number(to_char(sysdate, 'yyyymmdd')) as date_key,
             trunc(avg(日活)) as weikang_uv,
             trunc(avg(注册)) as weikang_reg,
             trunc(avg(订购)) as weikang_od
        from (select count(distinct ip) 日活,
                     count(distinct c.vid) 注册,
                     count(distinct b.vid) 订购,
                     visit_date_key
                from (select vid, ip, visit_date_key
                        from fact_page_view
                       where visit_date_key between
                             startpoint and
                             endpoint
                         and (url like '%wkzt%' or url like '%wksp%')
                       group by vid, ip, visit_date_key) a
                left join
              
               (select vid, fist_ip, start_date_key
                 from (select vid, fist_ip, start_date_key, member_key
                         from fact_session
                        where start_date_key between
                              startpoint and
                              endpoint
                          and application_key > 20) s
                 join (select member_crmbp, member_time
                        from fact_ecmember
                       where member_time between
                             startpoint and
                             endpoint) ss
                   on s.member_key = ss.member_crmbp
                  and s.start_date_key = ss.member_time
                group by vid, fist_ip, start_date_key) c
                  on
              
               (a.ip = c.fist_ip and a.visit_date_key = c.start_date_key)
                left join
              
               (select vid, order_ip, add_time
                 from factec_order
                where add_time between startpoint and
                      endpoint
                  and order_state > 10
                group by vid, order_ip, add_time) b
                  on (a.ip = b.order_ip and a.visit_date_key = b.add_time)
               group by visit_date_key);
  
    commit;
  
    insert into tmp_dm
      select to_number(to_char(sysdate, 'yyyymmdd')) as date_key,
             trunc(avg(日活)) as dm_uv,
             trunc(avg(注册)) as dm_reg,
             trunc(avg(订购)) as dm_od
        from (select count(distinct a.vid) 日活,
                      count(distinct c.vid) 注册,
                      count(distinct b.vid) 订购,
                      visit_date_key
                 from (select vid, start_date_key as visit_date_key
                         from (select *
                                 from (select vid,
                                              substr(vid, 3, 200) vid1,
                                              start_date_key
                                         from fact_session
                                        where start_date_key between
                                              startpoint and
                                              endpoint
                                          and application_key = 50
                                        group by substr(vid, 3, 200),
                                                 start_date_key,
                                                 vid) a
                                 left join (select openid, create_time
                                             from fact_wx_excode
                                            where create_time between
                                                  startpoint and
                                                  endpoint) b
                                   on a.vid1 = b.openid
                                  and a.start_date_key = b.create_time)
                        where openid is not null) a
                 left join
               
                (select vid, fist_ip, start_date_key
                  from (select vid, fist_ip, start_date_key, member_key
                          from fact_session
                         where start_date_key between
                               startpoint and
                               endpoint
                           and application_key > 20) s
                  join (select member_crmbp, member_time
                         from fact_ecmember
                        where member_time between
                              startpoint and
                              endpoint) ss
                    on s.member_key = ss.member_crmbp
                   and s.start_date_key = ss.member_time
                 group by vid, fist_ip, start_date_key) c
                   on
               
                a.vid = c.vid
             and a.visit_date_key = c.start_date_key
                 left join
               
                (select vid, order_ip, add_time
                  from factec_order
                 where add_time between startpoint and
                       endpoint
                   and order_state > 10
                 group by vid, order_ip, add_time) b
                   on (a.vid = b.vid and a.visit_date_key = b.add_time)
                group by visit_date_key);
  
    commit;
  
    insert into tmp_remind
      select to_number(to_char(sysdate, 'yyyymmdd')) as date_key,
             trunc(avg(日活)) as remind_uv,
             trunc(avg(注册)) as remind_reg,
             trunc(avg(订购)) as remind_od
        from (select count(distinct ip) 日活,
                     count(distinct c.vid) 注册,
                     count(distinct b.vid) 订购,
                     visit_date_key
                from (select vid, ip, visit_date_key
                        from fact_page_view
                       where visit_date_key between
                             startpoint and
                             endpoint
                         and (url like '%fo=YYTX%')
                       group by vid, ip, visit_date_key) a
                left join
              
               (select vid, fist_ip, start_date_key
                 from (select vid, fist_ip, start_date_key, member_key
                         from fact_session
                        where start_date_key between
                              startpoint and
                              endpoint
                          and application_key > 20) s
                 join (select member_crmbp, member_time
                        from fact_ecmember
                       where member_time between
                             startpoint and
                             endpoint) ss
                   on s.member_key = ss.member_crmbp
                  and s.start_date_key = ss.member_time
                group by vid, fist_ip, start_date_key) c
                  on
              
               (a.vid = c.vid and a.visit_date_key = c.start_date_key)
                left join
              
               (select vid, order_ip, add_time
                 from factec_order
                where add_time between startpoint and
                      endpoint
                  and order_state > 10
                group by vid, order_ip, add_time) b
                  on (a.vid = b.vid and a.visit_date_key = b.add_time)
               group by visit_date_key);
  
    commit;
  
    insert into tmp_scan
      select to_number(to_char(sysdate, 'yyyymmdd')) as date_key,
             trunc((select avg(num1)
                     from (select count(distinct device_key) num1, visit_date_key
                             from fact_page_view
                            where visit_date_key between
                                  startpoint and
                                  endpoint
                              and page_name in ('TV_QRC','Scan_live_gd',
                             'Scan_live_order',
                             'Scan_broadcast',
                             'Scan_recommend_gd')
                            group by visit_date_key))) as scan_uv,
             
             trunc((select count(distinct member_key) / 7
                     from fact_session
                    where start_date_key between
                         startpoint and
                         endpoint
                      and vid in
                          (select vid
                             from dim_vid_scan
                            where scan_date_key between
                                  startpoint and
                                  endpoint)
                      and member_key in
                          (select member_crmbp
                             from fact_ecmember
                            where member_time between
                                  startpoint and
                                  endpoint))) as scan_reg,
             
             trunc((select avg(num2)
                     from (select count(distinct member_key) num2, add_time
                             from factec_order
                            where add_time between
                                  startpoint and
                                  endpoint
                              and order_state > 10
                              and order_from in ('995',
                                                  '993',
                                                  '990',
                                                  '806',
                                                  '805',
                                                  '804',
                                                  '803',
                                                  '802',
                                                  '801',
                                                  '800',
                                                  '76')
                            group by add_time))) as scan_od
        from dual;
  
    commit;
  
  
  
insert into tmp_lite
  select sum(rh.liteuvcnt),
         sum(rh.mcnt),
         sum(rh.liteorderrs),
         to_number(to_char(sysdate, 'yyyymmdd'))
    from fact_daily_wx_new rh
   where rh.visit_date_key between startpoint and endpoint;


commit;

  
  
  
  
  
  
    insert into tmp_interact
      select to_number(to_char(sysdate, 'yyyymmdd')) as date_key,
             trunc(avg(日活)) as interact_uv,
             trunc(avg(注册)) as interact_reg,
             trunc(avg(订购)) as interact_od
        from (select count(distinct ip) 日活,
                     count(distinct c.vid) 注册,
                     count(distinct b.vid) 订购,
                     visit_date_key
                from (select vid, ip, visit_date_key
                        from fact_page_view
                       where visit_date_key between
                             startpoint and
                             endpoint
                         and url like '%SPHD%'
                       group by vid, ip, visit_date_key) a
                left join
              
               (select vid, fist_ip, start_date_key
                 from (select vid, fist_ip, start_date_key, member_key
                         from fact_session
                        where start_date_key between
                              startpoint and
                             endpoint
                          and application_key > 20) s
                 join (select member_crmbp, member_time
                        from fact_ecmember
                       where member_time between
                             startpoint and
                             endpoint) ss
                   on s.member_key = ss.member_crmbp
                  and s.start_date_key = ss.member_time
                group by vid, fist_ip, start_date_key) c
                  on
              
               (a.ip = c.fist_ip and a.visit_date_key = c.start_date_key)
                left join
              
               (select vid, order_ip, add_time
                 from factec_order
                where add_time between startpoint and
                      endpoint
                  and order_state > 10
                group by vid, order_ip, add_time) b
                  on (a.ip = b.order_ip and a.visit_date_key = b.add_time)
               group by visit_date_key);
  
    commit;
  
    insert into tmp_tot
      select to_number(to_char(sysdate, 'yyyymmdd')) as date_key,
             trunc((select avg(num1)
                     from (select count(distinct vid) num1, start_date_key
                             from fact_session
                            where start_date_key between
                                  startpoint and
                                  endpoint
                              and application_key != -1
                              and agent not like '%spider%'
                            group by start_date_key))) as tot_uv,
             trunc((select count(1) / 7
                     from fact_ecmember
                    where member_time between
                         startpoint and
                          endpoint)) as tot_reg,
             trunc((select avg(num2)
                     from (select count(distinct member_key) num2, add_time
                             from factec_order
                            where add_time between
                                  startpoint and
                                  endpoint
                              and order_state > 10
                            group by add_time))) as tot_od
        from dual;
  
    commit;
  
    insert into tmp_nature
      select to_number(to_char(sysdate, 'yyyymmdd')) as date_key,
             trunc(avg(nature_uv)) as nature_uv,
             0,
             0
        from (select c1.visit_date_key,
                     count(distinct c1.device_key) as nature_uv
                from fact_page_view c1
               where c1.visit_date_key between
                     to_number(startpoint) and
                     to_number(endpoint)
                 and c1.application_key != -1
                 and c1.agent not like '%spider%'
                 and not exists
               (select * from tmp_0907_1 c2 where c2.vid = c1.vid)
                 and not exists
               (select * from tmp_0907_2 c3 where c3.vid = c1.vid)
                 and not exists
               (select * from tmp_0907_3 c3 where c3.vid = c1.vid)
                 and not exists
               (select * from tmp_0907_4 c5 where c5.vid = c1.vid)
               group by c1.visit_date_key)
             
             commit;
  
    select trunc(count(distinct c1.member_key) / 7)
      into mcnt
      from fact_session c1
     where c1.start_date_key between
           to_number(startpoint) and
           to_number(endpoint)
       and c1.agent not like '%spider%'
       and not exists
     (select * from tmp_0907_1 c2 where c2.vid = c1.vid)
       and not exists
     (select * from tmp_0907_2 c3 where c3.vid = c1.vid)
       and not exists
     (select * from tmp_0907_3 c3 where c3.vid = c1.vid)
       and not exists
     (select * from tmp_0907_4 c5 where c5.vid = c1.vid)
          
       and exists (select *
              from fact_ecmember c6
             where member_time between
                   to_number(startpoint) and
                   to_number(endpoint)
               and c6.member_crmbp = c1.member_key);
  
    select trunc(count(distinct c1.vid) / 7)
      into odcnt
      from factec_order c1
     where c1.add_time between startpoint and
           endpoint
       and not exists
     (select c2.vid from tmp_0907_1 c2 where c2.vid = c1.vid)
       and not exists
     (select * from tmp_0907_2 c3 where c3.vid = c1.vid)
       and not exists
     (select * from tmp_0907_3 c3 where c3.vid = c1.vid)
       and not exists
     (select * from tmp_0907_4 c5 where c5.vid = c1.vid);
  
    update tmp_nature u set u.nature_reg = mcnt, u.nature_od = odcnt;
  
    commit;
  
    insert into fact_weekly_market
      select distinct b1.date_key,
                      b1.message_uv,
                      b1.message_reg,
                      b1.message_od,
                      b2.weikang_uv,
                      b2.weikang_reg,
                      b2.weikang_od,
                      b3.dm_uv,
                      b3.dm_reg,
                      b3.dm_od,
                      b4.remind_uv,
                      b4.remind_reg,
                      b4.remind_od,
                      b5.scan_uv,
                      b5.scan_reg,
                      b5.scan_od,
                      b6.interact_uv,
                      b6.interact_reg,
                      b6.interact_od,
                      b8.nature_uv,
                      b8.nature_reg,
                      b8.nature_od,
                      b7.tot_uv,
                      b7.tot_reg,
                      b7.tot_od,
                      b9.liteuvcnt,
                      b9.mcnt,
                      b9.liteorderrs
        from tmp_message  b1,
             tmp_weikang  b2,
             tmp_dm       b3,
             tmp_remind   b4,
             tmp_scan     b5,
             tmp_lite     b9,
             tmp_interact b6,
             tmp_tot      b7,
             tmp_nature   b8
       where b1.date_key = b2.date_key
         and b2.date_key = b3.date_key
         and b3.date_key = b4.date_key
         and b4.date_key = b5.date_key
         and b5.date_key = b9.date_key
         and b9.date_key = b6.date_key
         and b6.date_key = b7.date_key
         and b7.date_key = b8.date_key;
    commit;
  
    insert_rows := sql%rowcount;
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
end processmarketweek;
/

