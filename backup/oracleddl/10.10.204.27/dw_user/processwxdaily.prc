???create or replace procedure dw_user.processwxdaily is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processwxdaily'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_wx'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_daily_wx
    (visit_date_key,
     uvcnt,
     newvtcount,
     pvcnt,
     avgpv,
     avglife_time,
     newvtrate,
     bonusrate,
     orderrate,
     mcnt,
     noscan_orderrate,
     noscan_orderrs,
     liteuvcnt,
     litepvcnt,
     litenewvtcount,
     liteorderrs,
     litenewvtrate,
     liteorderrate
     
     )
  
    select x1.visit_date_key,
           x1.uvcnt,
           x3.newvtcount,
           x1.pvcnt,
           trunc(x1.avgpv, 2) as avgpv,
           trunc(x2.avglife_time, 2) as avglife_time,
           trunc((x3.newvtcount / x1.uvcnt), 2) as newvtrate,
           x2.bonusrate,
           trunc((x4.orderrs / x1.uvcnt), 3) as orderrate,
           x5.mcnt,
           (x4.noscan_orderrs+x4.liteorderrs) /
           (x1.uvcnt -
           (select count(distinct w1.vid)
               from dim_vid_scan w1
              where w1.scan_date_key =
                    to_number(to_char(sysdate - 1, 'yyyymmdd')))+x1.liteuvcnt),
           x4.noscan_orderrs,
           x1.liteuvcnt,
           x1.litepvcnt,
           x3.litenewvtcount,
           x4.liteorderrs,
           trunc((x3.litenewvtcount / x1.liteuvcnt), 2) as litenewvtrate,
           trunc((x4.liteorderrs / x1.liteuvcnt), 3) as liteorderrate
    
      from (select a.visit_date_key,
                   
                   count(distinct(case
                                    when a.application_key = 50 then
                                     a.device_key
                                  end)) as uvcnt,
                   (count(case
                            when a.application_key = 50 then
                             a.id
                          end) / count(distinct(case
                                                   when a.application_key = 50 then
                                                    a.device_key
                                                 end))) avgpv,
                   count(case
                           when a.application_key = 50 then
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
               and b.application_key = 50
             group by b.start_date_key) x2,
           
           (select c.create_date_key,
                   count(case
                           when c.application_key = 50 then
                            c.vistor_key
                         end) as newvtcount,
                   count(case
                           when c.application_key = 70 then
                            c.vistor_key
                         end) as litenewvtcount
              from fact_visitor_register c
             where c.create_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
            --and c.application_key = 50
             group by c.create_date_key) x3,
           
           (select v.member_time, count(v.member_crmbp) as mcnt
              from fact_ecmember v
             where v.member_time =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and v.register_appname = 'KLGWX'
             group by v.member_time) x5,
           -- wxlite
           (select e.add_time,
                   count(distinct(case
                                    when e.vid like 'wxoe%' then
                                     e.member_key
                                  end)) as orderrs,
                   count(distinct(case
                                    when e.order_from != 76 and e.vid like 'wxoe%' then
                                     e.member_key
                                  end)) as noscan_orderrs,
                   count(distinct(case
                                    when e.vid like 'wxlite%' or
                                    e.vid like 'wxlitebargain%'
                                      then
                                     e.member_key
                                  end)) as liteorderrs
              from factec_order e
             where e.add_time = to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and e.app_name = 'KLGWX'
               and (e.payment_code = 'offline' or
                   e.order_state in (20, 30, 40, 50))
                 group by e.add_time) x4
           
           
         /* (select e.add_time,
                   count(distinct(case
                                    when e.vid like 'wxoe%' then
                                     e.cust_no
                                  end)) as orderrs,
                   count(distinct(case
                                    when e.order_from != 76 and e.vid like 'wxoe%' then
                                     e.cust_no
                                  end)) as noscan_orderrs,
                   count(distinct(case
                                    when e.vid like 'wxlite%' or
                                    e.vid like 'wxlitebargain%'
                                      then
                                     e.cust_no
                                  end)) as liteorderrs
              from fact_ec_order e
             where e.add_time = to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and e.app_name = 'KLGWX'
               and (e.payment_code = 'offline' or
                   e.order_state in (20, 30, 40, 50))
               and not exists
               (select * from FACT_EC_ORDERgoods p1 where p1.goods_commonid=181034
               and p1.order_id=e.order_id and p1.is_kjg=e.is_kjg
               )
               
             group by e.add_time) x4*/
    
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
end processwxdaily;
/

