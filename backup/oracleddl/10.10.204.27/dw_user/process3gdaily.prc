???create or replace procedure dw_user.process3gdaily is
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
     orderrate,
     mcnt,
     hbpv,
     hbuv,
     hbzc)
  
    select x1.visit_date_key,
           x1.uvcnt,
           x3.newvtcount,
           x1.pvcnt,
           x1.ipcnt,
           trunc(x1.avgpv, 2) as avgpv,
           trunc(x2.avglife_time, 2) as avglife_time,
           trunc((x3.newvtcount / x1.uvcnt), 2) as newvtrate,
           x2.bonusrate,
           trunc((x5.orderrs / x1.uvcnt), 3) as orderrate,
           x4.mcnt,
           x6.hbpv,
           x6.hbuv,
           x6.hbzc
      from (select a.visit_date_key,
                   
                   count(distinct a.device_key) as uvcnt,
                   (count(a.id) / count(distinct a.device_key)) avgpv,
                   count(a.id) as pvcnt,
                   count(distinct a.ip) as ipcnt
              from fact_page_view a
             where a.visit_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and a.application_key = 30
               and a.agent not like '%spider%'
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
               and b.agent not like '%spider%'
             group by b.start_date_key) x2,
           
           (select c.create_date_key, count(c.vistor_key) as newvtcount
              from fact_visitor_register c
             where c.create_date_key =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and c.application_key = 30
               and c.agent not like '%spider%'
             group by c.create_date_key) x3,
           
           (select v.member_time, count(v.member_crmbp) as mcnt
              from fact_ecmember v
             where v.member_time =
                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and v.register_appname = 'KLGMPortal'
             group by v.member_time) x4,
           
           (select e.add_time, count(distinct e.cust_no) as orderrs
              from fact_ec_order e
             where e.add_time = to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and e.app_name = 'KLGMPortal'
               and (e.payment_code = 'offline' or
                   e.order_state in (20, 30, 40, 50))
             group by e.add_time) x5,
           
           (select nvl(sum(hbpv), 0) as hbpv,
                   nvl(sum(hbuv), 0) as hbuv,
                   nvl(sum(hbzc), 0) as hbzc,
                   to_number(to_char(sysdate - 1, 'yyyymmdd')) as visit_date_key
              from (select count(ip) hbpv,
                           count(distinct ip) hbuv,
                           count(distinct c.member_key) hbzc,
                           visit_date_key
                      from (select vid, ip, visit_date_key
                              from fact_page_view
                             where visit_date_key =
                                   to_number(to_char(sysdate - 1, 'yyyymmdd'))
                               and page_name = 'MobileHome'
                               and application_key = 30
                               and agent not like '%spider%'
                             group by vid, ip, visit_date_key) a
                      left join
                    
                     (select vid, fist_ip, start_date_key, member_key
                       from (select vid, fist_ip, start_date_key, member_key
                               from fact_session
                              where start_date_key =
                                    to_number(to_char(sysdate - 1, 'yyyymmdd'))
                                and agent not like '%spider%'
                                and application_key = 30) s
                       join (select member_crmbp, member_time
                              from fact_ecmember
                             where member_time =
                                   to_number(to_char(sysdate - 1, 'yyyymmdd'))) ss
                         on s.member_key = ss.member_crmbp
                        and s.start_date_key = ss.member_time
                      group by vid, fist_ip, start_date_key, member_key) c
                        on
                    
                     (a.ip = c.fist_ip and
                     a.visit_date_key = c.start_date_key)
                    
                     group by visit_date_key) o) x6
    
    /*(SELECT 
    count(ip) hbpv,
    COUNT(DISTINCT IP) hbuv,
                           COUNT(DISTINCT C.MEMBER_KEY) hbzc,
                           VISIT_DATE_KEY
                      FROM (SELECT VID, IP, VISIT_DATE_KEY
                              FROM FACT_PAGE_VIEW
                             WHERE VISIT_DATE_KEY = to_number(to_char(sysdate - 2, 'yyyymmdd'))
                               AND PAGE_NAME = 'MobileHome'
                               AND APPLICATION_KEY = 30
                               and agent not like '%spider%' 
                             GROUP BY VID, IP, VISIT_DATE_KEY) A
                      LEFT JOIN
                    
                     (SELECT VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                       FROM (SELECT VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                               FROM FACT_SESSION
                              WHERE START_DATE_KEY = to_number(to_char(sysdate - 2, 'yyyymmdd'))
                                and agent not like '%spider%' 
                                AND APPLICATION_KEY = 30) S
                       JOIN (SELECT MEMBER_CRMBP, MEMBER_TIME
                              FROM FACT_ECMEMBER
                             WHERE MEMBER_TIME = to_number(to_char(sysdate - 2, 'yyyymmdd'))) SS
                         ON S.MEMBER_KEY = SS.MEMBER_CRMBP
                        AND S.START_DATE_KEY = SS.MEMBER_TIME
                      GROUP BY VID, FIST_IP, START_DATE_KEY, MEMBER_KEY) C
                        ON
                    
                     (A.IP = C.FIST_IP AND A.VISIT_DATE_KEY = C.START_DATE_KEY)
                    
                     GROUP BY VISIT_DATE_KEY) x6*/
    
     where x1.visit_date_key = x2.start_date_key
       and x1.visit_date_key = x6.visit_date_key
       and x2.start_date_key = x3.create_date_key
       and x3.create_date_key = x4.member_time
       and x4.member_time = x5.add_time;

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

