???create or replace procedure dw_user.processwxdaily2 is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processwxdaily2'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_wx_new'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from tmp_1210saoma;

  commit;
  insert into tmp_1210saoma
    select a.vid, a.visit_date_key
      from fact_page_view a
     where a.visit_date_key = to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and (a.page_key in (39910, 46809) or
           a.page_name in ('Click_live_gd',
                            'Click_live_order',
                            'Click_broadcast',
                            'Click_recommend_gd'));
  commit;

  insert into fact_daily_wx_new
    (visit_date_key,
     uvcnt,
     newvtcount,
     pvcnt,
     avgpv,
     avglife_time,
     newvtrate,
     bonusrate,
     orderrs,
     orderrate,
     mcnt,
     wscorderrate,
     noscan_orderrs,
     wscuvcnt,
     wscnewvtcount,
     liteuvcnt,
     litepvcnt,
     litenewvtcount,
     liteorderrs,
     litenewvtrate,
     liteorderrate,
     smuvcnt,
     sm_orderrs,
     smyj,
     smcnt,
     liteyj
     
     )
    select x1.visit_date_key,
           x1.uvcnt,
           x3.newvtcount,
           x1.pvcnt,
           trunc(x1.avgpv, 2) as avgpv,
           trunc(x2.avglife_time, 2) as avglife_time,
           trunc((x3.newvtcount / x1.uvcnt), 2) as newvtrate,
           x2.bonusrate,
           (x4.noscan_orderrs + x4.liteorderrs) as orderrs,
           trunc(((x4.noscan_orderrs + x4.liteorderrs) / x1.uvcnt2), 3) as orderrate,
           x5.mcnt,
           trunc((x4.noscan_orderrs / x1.wscuvcnt), 3) as wscorderrate, --
           x4.noscan_orderrs,
           x1.wscuvcnt, --
           x3.wscnewvtcount, --wscnewvtcount
           x1.liteuvcnt,
           x1.litepvcnt,
           x3.litenewvtcount,
           x4.liteorderrs,
           trunc((x3.litenewvtcount / x1.liteuvcnt), 2) as litenewvtrate,
           trunc((x4.liteorderrs / x1.liteuvcnt), 3) as liteorderrate,
           
           -- x4.wscorderrs,--wscorderrs
           
           x1.smuvcnt,
           x4.sm_orderrs,
           x4.smyj,
           x5.smcnt,
           x4.liteyj
    
      from (select a.visit_date_key,
                   
                   count(distinct(case
                                    when a.application_key in (50, 70) then
                                     a.device_key
                                  end)) as uvcnt,
                   count(distinct(case
                                    when a.application_key in (50, 70) and
                                         a.page_key != 46809 then
                                     a.device_key
                                  end)) as uvcnt2,
                   
                   count(distinct(case
                                    when a.application_key = 50 and a.page_key != 46809 then
                                     a.device_key
                                  end)) as wscuvcnt, --wscuvcnt
                   count(distinct(case
                                    when --a.application_key = 50  and
                                     a.page_key = 39910 or
                                     a.page_name in ('Click_live_gd',
                                                     'Click_live_order',
                                                     'Click_broadcast',
                                                     'Click_recommend_gd') then
                                     a.device_key
                                  end)) as smuvcnt, --  smuvcnt
                   
                   (count(case
                            when a.application_key in (50, 70) then
                             a.id
                          end) / count(distinct(case
                                                   when a.application_key in (50, 70) then
                                                    a.device_key
                                                 end))) avgpv,
                   count(case
                           when a.application_key in (50, 70) then
                            a.id
                         end) as pvcnt,
                   
                   count(distinct(case
                                    when a.application_key = 70 then
                                     a.device_key
                                  end)) as liteuvcnt,
                   /* (count(case
                     when a.application_key = 70 then
                      a.id
                   end) / count(distinct(case
                                            when a.application_key = 70 then
                                             a.device_key
                                          end))) liteavgpv,*/
                   count(case
                           when a.application_key = 70 then
                            a.id
                         end) as litepvcnt
            
              from fact_page_view a
             where a.visit_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
            -- and a.application_key = 50
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
               and b.application_key in (50, 70)
            
             group by b.start_date_key) x2,
           
           (select c.create_date_key,
                   count(case
                           when c.application_key in (50, 70) then
                            c.vistor_key
                         end) as newvtcount,
                   
                   count(case
                           when c.application_key = 50 and not exists
                            (select *
                                   from fact_page_view p
                                  where p.visit_date_key =
                                        to_number(to_char(sysdate - 1, 'yyyymmdd'))
                                    and p.application_key = 50
                                    and p.page_key != 46809
                                    and p.vid = c.vid) then
                            c.vistor_key
                         end) as wscnewvtcount, --wscnewvtcount
                   
                   count(case
                           when c.application_key = 70 then
                            c.vistor_key
                         end) as litenewvtcount
              from fact_visitor_register c
             where c.create_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
            --and c.application_key = 50
             group by c.create_date_key) x3,
           
           (select v.member_time,
                   count(v.member_crmbp) as mcnt,
                   count(distinct(case
                                    when exists (select *
                                            from (select pp.member_key
                                                    from dim_vid_mem pp
                                                   where pp.create_date_key =
                                                         to_number(to_char(sysdate - 1,
                                                                           'yyyymmdd'))
                                                     and exists
                                                   (select *
                                                            from tmp_1210saoma a
                                                           where a.vid = pp.vid)) xx
                                           where xx.member_key = v.member_crmbp) then
                                    
                                     v.member_crmbp
                                  end)) smcnt
              from fact_ecmember v
             where v.member_time =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and v.register_appname = 'KLGWX'
             group by v.member_time) x5,
           -- wxlite       
           
           (select e.add_time,
                   /* count(distinct(case
                     when (e.vid like 'wxoe%' or e.vid like 'wxlite%' or
                          e.vid like 'wxlitebargain%') and e.order_from != 76 then
                      e.member_key
                   end)) as orderrs, and e.order_from not in ('76','807','990','993','995','997')*/
                   
                   count(distinct(case
                                    when e.order_from not in ('995',
                                                              '993',
                                                              '990',
                                                              '806',
                                                              '805',
                                                              '804',
                                                              '803',
                                                              '802',
                                                              '801',
                                                              '800',
                                                              '76') and e.vid like 'wxoe%' then
                                     e.member_key
                                  end)) as noscan_orderrs, --wscorderrs
                   
                   count(distinct(case
                                    when (e.vid like 'wxlite%' or
                                         e.vid like 'wxlitebargain%') and
                                         e.order_from not in ('995',
                                                              '993',
                                                              '990',
                                                              '806',
                                                              '805',
                                                              '804',
                                                              '803',
                                                              '802',
                                                              '801',
                                                              '800',
                                                              '76') then
                                     e.member_key
                                  end)) as liteorderrs,
                   
                   count(distinct(case
                                    when e.order_from in ('995',
                                                          '993',
                                                          '990',
                                                          '806',
                                                          '805',
                                                          '804',
                                                          '803',
                                                          '802',
                                                          '801',
                                                          '800',
                                                          '76') then
                                     e.member_key
                                  end)) as sm_orderrs,
                   sum(case
                         when e.order_from in ('995',
                                               '993',
                                               '990',
                                               '806',
                                               '805',
                                               '804',
                                               '803',
                                               '802',
                                               '801',
                                               '800',
                                               '76') then
                          e.order_amount
                       end) as smyj,
                   
                   sum(case
                         when (e.vid like 'wxlite%' or
                              e.vid like 'wxlitebargain%') and
                              e.order_from not in ('995',
                                                   '993',
                                                   '990',
                                                   '806',
                                                   '805',
                                                   '804',
                                                   '803',
                                                   '802',
                                                   '801',
                                                   '800',
                                                   '76') then
                          e.order_amount
                       end) as liteyj
            
              from factec_order e
             where e.add_time = to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and e.app_name = 'KLGWX'
               and e.order_state >= 20
             group by e.add_time) x4
    
     where x1.visit_date_key = x2.start_date_key
       and x2.start_date_key = x3.create_date_key
       and x3.create_date_key = x5.member_time(+)
       and x3.create_date_key = x4.add_time(+);

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
end processwxdaily2;
/

