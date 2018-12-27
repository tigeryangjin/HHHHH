???create or replace procedure dw_user.process_ec_kpi_mon/*(w_startpoint in varchar2,
                                               w_endpoint   in varchar2)*/ is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
w_startpoint varchar2(100);
w_endpoint varchar2(100);
  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'process_ec_kpi_mon'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'KPI_EC_TBL'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  w_startpoint:='20180201';
  w_endpoint:='20180301' ;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010018',
           '整体SKU数(在架)',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           hh2.totsku,
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select count(distinct hh1.item_code) as totsku
              from fact_daily_goodzaijia hh1
             where to_char(hh1.insert_date, 'yyyymmdd') >= w_startpoint
               and to_char(hh1.insert_date, 'yyyymmdd') < w_endpoint
               and hh1.store_id=1
               ) hh2;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010019',
           '自营SKU数(在架)',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           hh2.zysku,
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select count(distinct hh1.item_code) as zysku
              from fact_daily_goodzaijia hh1
             where to_char(hh1.insert_date, 'yyyymmdd') >= w_startpoint
               and to_char(hh1.insert_date, 'yyyymmdd') < w_endpoint
               and hh1.store_id = 1 and hh1.is_tv!='非电商提报组'
               ) hh2;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010020',
           'TV SKU数(在架)',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           hh2.tvsku,
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select count(distinct hh1.item_code) as tvsku
              from fact_daily_goodzaijia hh1
             where to_char(hh1.insert_date, 'yyyymmdd') >= w_startpoint
               and to_char(hh1.insert_date, 'yyyymmdd') < w_endpoint
               and hh1.is_tv = '非电商提报组') hh2;

  insert into kpi_ec_tbl
  
    select w_kpi_d_s.nextval, x1.*
      from (select '01' as deno,
                   '新媒体中心' as dept,
                   '0101' as deno_1,
                   '新媒体' as dept_1,
                   '01010021' as item_no,
                   '自营新品上架数' as item,
                   w_startpoint as b_date,
                   w_endpoint as e_date,
                   0.00 as item_value1,
                   0.00 as item_value2,
                   count(distinct n.item_code) as item_value3,
                   '1508833' as insert_id,
                   'M' as item_type,
                   'Y' as data_type,
                   '' as note,
                   sysdate
              from fact_daily_goodzaijia n
             where to_char(n.goods_addtime, 'yyyymmdd') >= w_startpoint
               and to_char(n.goods_addtime, 'yyyymmdd') < w_endpoint
               and store_id = 1 and is_tv!='非电商提报组') x1;




 insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010036',
           '扫码人数',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
          trunc(h5.tot/to_number(to_char(last_day(trunc(SYSDATE-1)), 'DD'))),
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select sum(t.item_value3) as tot
              from kpi_ec_tbl t
             where t.b_date >= to_number(w_startpoint)
               and t.b_date < to_number(w_endpoint)
               and t.item_no = 01010036
               and t.item_type = 'D') h5;





 insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010044',
           '整体日活',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
          trunc(h5.tot/to_number(to_char(last_day(trunc(SYSDATE-1)), 'DD'))),
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select sum(t.item_value3) as tot
              from kpi_ec_tbl t
             where t.b_date >= to_number(w_startpoint)
               and t.b_date < to_number(w_endpoint)
               and t.item_no = 01010044
               and t.item_type = 'D') h5;





  /*insert into kpi_ec_tbl
    select w_kpi_d_s.nextval, x2.*
      from (select '01' as deno,
                   '新媒体中心' as dept,
                   '0101' as deno_1,
                   '新媒体' as dept_1,
                   '01010036' as item_no,
                   '扫码人数' as item,
                   w_startpoint as b_date,
                   w_endpoint as e_date,
                   0.00 as item_value1,
                   0.00 as item_value2,
                   count(distinct v1.vid) as item_value3,
                   '1508833' as insert_id,
                   'M' as item_type,
                   'Y' as data_type,
                   '' as note,
                   sysdate
              from dim_vid_scan v1
             where v1.scan_date_key >= to_number(w_startpoint)
               and v1.scan_date_key < to_number(w_endpoint)
            
            ) x2;*/

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010037',
           '扫码转化率',
           w_startpoint,
           w_endpoint,
           xx.odrs,
           yy.scantot,
           trunc((xx.odrs / yy.scantot), 2),
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select count(distinct(case
                                    when exists
                                     (select *
                                            from dim_vid_scan w1
                                           where w1.scan_date_key >= to_number(w_startpoint)
                                             and w1.scan_date_key < to_number(w_endpoint)
                                             and w1.vid = ccc.vid) then
                                     ccc.member_key
                                  end)) as odrs,
                   to_number(w_startpoint) as date_key
              from factec_order ccc
             where ccc.add_time >= to_number(w_startpoint)
               and ccc.add_time < to_number(w_endpoint)
               and ccc.order_state > 10) xx,
           (select count(distinct w1.vid) as scantot,
                   to_number(w_startpoint) as date_key
              from dim_vid_scan w1
             where w1.scan_date_key >= to_number(w_startpoint)
               and w1.scan_date_key < to_number(w_endpoint)) yy
     where xx.date_key = yy.date_key;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010038',
           '自营新品月动销率',
           w_startpoint,
           w_endpoint,
           xx.dx,
           yy.sj,
           trunc((xx.dx / yy.sj), 2),
           '1508833',
           'W',
           'Y',
           '',
           sysdate
      from (select count(distinct n6.item_code) as dx,
                   to_number(w_startpoint) as date_key
              from order_good n6
             where to_char(n6.addtime, 'yyyymmdd') >=
                   to_number(w_startpoint)
               and to_char(n6.addtime, 'yyyymmdd') < to_number(w_endpoint)
               and n6.iscg = 1
               and exists (select n.*
                      from fact_daily_goodzaijia n
                     where to_char(n.goods_addtime, 'yyyymmdd') >=
                           to_number(w_startpoint)
                       and to_char(n.goods_addtime, 'yyyymmdd') <
                           to_number(w_endpoint)
                       and store_id = 1 and is_tv!='非电商提报组'
                       and n.item_code = n6.item_code)) xx,
           
           (select count(distinct n.item_code) as sj,
                   to_number(w_startpoint) as date_key
              from fact_daily_goodzaijia n
             where to_char(n.goods_addtime, 'yyyymmdd') >=
                   to_number(w_startpoint)
               and to_char(n.goods_addtime, 'yyyymmdd') <
                   to_number(w_endpoint)
               and store_id = 1 and is_tv!='非电商提报组') yy
     where xx.date_key = yy.date_key;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0102',
           'APP',
           '01020004',
           '下载数',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           h5.tot,
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select trunc(count(distinct h3.vistor_key) / 0.95) as tot
              from fact_visitor_register h3
             where h3.create_date_key >= to_number(w_startpoint)
               and h3.create_date_key < to_number(w_endpoint)
               and h3.application_key in (10, 20)) h5;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0102',
           'APP',
           '01020005',
           '激活数',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           h5.tot,
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select count(distinct h3.vistor_key) as tot
              from fact_visitor_register h3
             where h3.create_date_key >= to_number(w_startpoint)
               and h3.create_date_key < to_number(w_endpoint)
               and h3.application_key in (10, 20)) h5;

 /* insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0102',
           'APP',
           '01020006',
           '注册用户',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           h2.tot,
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select count(distinct h1.member_crmbp) as tot
              from fact_ecmember h1
             where member_time >= to_number(w_startpoint)
               and member_time < to_number(w_endpoint)
               and h1.register_appname in ('KLGAndroid', 'KLGiPhone')) h2;*/


 insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0102',
           'APP',
           '01020006',
           '注册用户',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
          trunc(h5.tot/to_number(to_char(last_day(trunc(SYSDATE-1)), 'DD'))),
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select sum(t.item_value3) as tot
              from kpi_ec_tbl t
             where t.b_date >= to_number(w_startpoint)
               and t.b_date < to_number(w_endpoint)
               and t.item_no = 01020006
               and t.item_type = 'D') h5;









 /* insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0102',
           'APP',
           '01020007',
           '日活',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           h5.tot,
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select count(distinct h3.device_key) as tot
              from fact_page_view h3
             where h3.visit_date_key >= to_number(w_startpoint)
               and h3.visit_date_key < to_number(w_endpoint)
               and h3.application_key in (10, 20)) h5;

  insert into kpi_ec_tbl
  select w_kpi_d_s.nextval,
         '01',
         '新媒体中心',
         '0102',
         'APP',
         '01020007',
         '日活',
         w_startpoint,
         w_endpoint,
         0.00,
         0.00,
         h5.tot,
         '1508833',
         'M',
         'Y',
         '',
         sysdate
    from (select count(distinct h3.device_key) as tot
            from fact_page_view h3
           where h3.visit_date_key >= to_number(w_startpoint)
             and h3.visit_date_key < to_number(w_endpoint)
             and h3.application_key in (10, 20)) h5;*/

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0102',
           'APP',
           '01020007',
           '日活',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
          trunc(h5.tot/to_number(to_char(last_day(trunc(SYSDATE-1)), 'DD'))),
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select sum(t.item_value3) as tot
              from kpi_ec_tbl t
             where t.b_date >= to_number(w_startpoint)
               and t.b_date < to_number(w_endpoint)
               and t.item_no = 01020007
               and t.item_type = 'D') h5;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0103',
           '微信端',
           '01030004',
           '访客数',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
          trunc(h5.tot/to_number(to_char(last_day(trunc(SYSDATE-1)), 'DD'))),
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select sum(t.item_value3) as tot
              from kpi_ec_tbl t
             where t.b_date >= to_number(w_startpoint)
               and t.b_date < to_number(w_endpoint)
               and t.item_no = 01030004
               and t.item_type = 'D') h5;

  /*insert into kpi_ec_tbl
  select w_kpi_d_s.nextval,
         '01',
         '新媒体中心',
         '0103',
         '微信端',
         '01030004',
         '访客数',
         w_startpoint,
         w_endpoint,
         0.00,
         0.00,
         h5.tot,
         '1508833',
         'M',
         'Y',
         '',
         sysdate
    from (select count(distinct h3.device_key) as tot
            from fact_page_view h3
           where h3.visit_date_key >= to_number(w_startpoint)
             and h3.visit_date_key < to_number(w_endpoint)
             and h3.application_key = 50) h5;*/

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval, x3.*
      from (select '01' as deno,
                   '新媒体中心' as dept,
                   '0103' as deno_1,
                   '微信端' as dept_1,
                   '01030005' as item_no,
                   '新增关注数' as item,
                   w_startpoint as b_date,
                   w_endpoint as e_date,
                   0.00 as item_value1,
                   0.00 as item_value2,
                   count(distinct h6.open_id) as item_value3,
                   '1508833' as insert_id,
                   'M' as item_type,
                   'Y' as data_type,
                   '' as note,
                   sysdate
              from dim_wechat h6
             where h6.subscribe_time >= to_number(w_startpoint)
               and h6.subscribe_time < to_number(w_endpoint)) x3;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0103',
           '微信端',
           '01030006',
           '净增关注数',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           (subtot - cantot),
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select to_number(w_startpoint) as datekey, count(1) as subtot
              from dim_wechat h7
             where h7.subscribe_time >= to_number(w_startpoint)
               and h7.subscribe_time < to_number(w_endpoint)) a,
           
           (select to_number(w_startpoint) as datekey, count(1) as cantot
              from dim_wechat h7
             where h7.cancel_subscribe_time >= to_number(w_startpoint)
               and h7.cancel_subscribe_time < to_number(w_endpoint)) b
     where a.datekey = b.datekey;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0103',
           '微信端',
           '01030007',
           '月累计粉丝数',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           x6.ljtot,
           '1508833',
           'M',
           'Y',
           '',
           sysdate
      from (select (count(n2.open_id) - count(case
                                                when n2.cancel_subscribe_time != 19700101 then
                                                 1
                                              end)) as ljtot
              from dim_wechat n2
             where n2.creat_time <= to_number(w_endpoint)) x6;

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
end process_ec_kpi_mon;
/

