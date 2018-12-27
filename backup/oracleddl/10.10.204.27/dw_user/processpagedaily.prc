???create or replace procedure dw_user.processpagedaily(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processpagedaily'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_goodorder'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from fact_daily_goodpage_1;
  commit;

  delete from temp_page_total;
  commit;

  delete from fact_daily_goodorder where visit_date_key = startpoint;
  commit;
  delete from fact_daily_goodpage where visit_date_key = startpoint;
  delete from fact_daily_topic where visit_date_key = startpoint;
  delete from fact_daily_topic_goods where visit_date_key = startpoint;
  commit;

  insert into fact_daily_goodorder
    (visit_date_key,
     application_nm,
     page_key,
     page_name,
     page_value,
     item_code,
     goods_name,
     matdlt,
     brand_name,
     is_tv,
     goods_price,
     goodpv,
     gooduv,
     goodnum,
     goodamount,
     create_date_key)
    select y1.visit_date_key,
           decode(y1.application_key,
                  10,
                  'IOS',
                  20,
                  'ANDROID',
                  30,
                  '3G',
                  40,
                  'PC',
                  50,
                  'WEIXIN') as application_nm,
           y1.page_key,
           y1.page_name,
           y1.page_value,
           y1.item_code,
           y1.goods_name,
           y1.matdlt,
           y1.brand_name,
           y1.is_tv,
           y1.goods_price,
           y1.goodpv,
           y1.gooduv,
           nvl(y2.goodnum, 0) as goodnum,
           nvl(y2.goodamount, 0) as goodamount,
           startpoint
      from (select y.visit_date_key,
                   y.application_key,
                   y.page_key,
                   y.page_name,
                   y.page_value,
                   y.goodcode,
                   y.item_code,
                   y.goods_name,
                   y.matdlt,
                   y.brand_name,
                   decode(y.is_tv, 0, '电商提报组', 1, '非电商提报组') as is_tv,
                   y.goods_price,
                   y.goodpv,
                   y.gooduv
              from (select to_number(to_char(w1.visit_date, 'yyyymmdd')) as visit_date_key,
                           w1.application_key,
                           w1.page_key,
                           w1.page_name,
                           w1.page_value,
                           w1.goodcode,
                           (select x2.item_code
                              from dim_ec_good x2
                             where x2.goods_commonid = w1.goodcode) as item_code,
                           (select x2.goods_name
                              from dim_ec_good x2
                             where x2.goods_commonid = w1.goodcode) as goods_name,
                           (select x2.matdlt
                              from dim_ec_good x2
                             where x2.goods_commonid = w1.goodcode) as matdlt,
                           (select x2.brand_name
                              from dim_ec_good x2
                             where x2.goods_commonid = w1.goodcode) as brand_name,
                           (select x2.is_tv
                              from dim_ec_good x2
                             where x2.goods_commonid = w1.goodcode) as is_tv,
                           (select x2.goods_price
                              from dim_ec_good x2
                             where x2.goods_commonid = w1.goodcode) as goods_price,
                           count(vid) as goodpv,
                           count(distinct vid) as gooduv
                      from fact_pagegoods w1
                     where w1.page_key not in (-1, 0, 6376, 7081)
                     group by to_number(to_char(w1.visit_date, 'yyyymmdd')),
                              w1.application_key,
                              w1.page_key,
                              w1.page_name,
                              w1.page_value,
                              w1.goodcode) y
             where y.item_code is not null) y1,
           
           (select y3.add_time,
                   y3.application_key,
                   y3.page_key,
                   y3.page_name,
                   y3.page_value,
                   y3.goodcode,
                   nvl(sum(y3.goods_num), 0) as goodnum,
                   trunc(nvl(sum(y3.goods_num * y3.goods_pay_price), 0), 2) as goodamount
              from fact_pagegoods_detail y3
             group by y3.add_time,
                      y3.application_key,
                      y3.page_key,
                      y3.page_name,
                      y3.page_value,
                      y3.goodcode) y2
     where y1.visit_date_key = y2.add_time(+)
       and y1.application_key = y2.application_key(+)
       and y1.page_key = y2.page_key(+)
       and y1.page_name = y2.page_name(+)
       and y1.page_value = y2.page_value(+)
       and y1.goodcode = y2.goodcode(+);

  insert_rows := sql%rowcount;
  commit;

  /*select z1.*,z2.* from
  (select k1.page_key,k1.page_name,count(k1.vid),count(distinct k1.vid) from fact_page_view k1 where
  k1.visit_date_key=20160712
  and exists (select * from  fact_daily_goodpage k2 where k2.page_key=k1.page_key and k2.visit_date_key=k1.visit_date_key)
  group by k1.page_key,k1.page_name) z1, (select * from fact_daily_goodpage z12 where z12.visit_date_key=20160712) z2 
  where z1.page_key=z2.page_key*/

  insert into fact_daily_goodpage_1
    (page_key,
     page_name,
     page_value,
     visit_date_key,
     application_key,
     application_nm,
     pagepv,
     pageuv,
     pageavgtime,
     ordercnt,
     orderuv,
     orderrate,
     goods_num,
     goods_amount
     
     )
  
    select b1.page_key,
           b1.page_name,
           b1.page_value,
           b1.visit_date_key,
           b1.application_key,
           decode(b1.application_key,
                  10,
                  'IOS',
                  20,
                  'ANDROID',
                  30,
                  '3G',
                  40,
                  'PC',
                  50,
                  'WEIXIN') as application_nm,
           b1.pagepv,
           b1.pageuv,
           b1.page_staytime,
           nvl(b2.ordercnt, 0) as ordercnt,
           nvl(b2.orderuv, 0) as orderuv,
           nvl(trunc((b2.orderuv / pageuv), 2), 0) as orderrate,
           nvl(b2.goods_num, 0) as goods_num,
           nvl(b2.goods_amount, 0) as goods_amount
      from (select to_number(to_char(w1.visit_date, 'yyyymmdd')) as visit_date_key,
                   w1.application_key,
                   w1.page_key,
                   w1.page_name,
                   w1.page_value,
                   count(w1.vid) as pagepv,
                   count(distinct w1.vid) as pageuv,
                   trunc(avg(w1.page_staytime), 2) as page_staytime
              from fact_pagegoods w1
             where w1.page_key not in (-1, 0, 6376, 7081)
             group by to_number(to_char(w1.visit_date, 'yyyymmdd')),
                      w1.application_key,
                      w1.page_key,
                      w1.page_name,
                      w1.page_value) b1,
           
           (select z2.add_time,
                   z2.application_key,
                   z2.page_key,
                   z2.page_name,
                   z2.page_value,
                   count(distinct z2.order_id) as ordercnt,
                   count(distinct z2.vvid) as orderuv,
                   -- trunc((count(distinct z2.vvid) / count(distinct vid)), 2) as orderrate,
                   nvl(sum(z2.goods_num), 0) as goods_num,
                   nvl(sum(z2.goods_num * z2.goods_pay_price), 0) as goods_amount
              from fact_pagegoods_detail z2
             group by z2.add_time,
                      z2.application_key,
                      z2.page_key,
                      z2.page_name,
                      z2.page_value) b2
     where b1.visit_date_key = b2.add_time(+)
       and b1.application_key = b2.application_key(+)
       and b1.page_key = b2.page_key(+)
       and b1.page_name = b2.page_name(+)
       and b1.page_value = b2.page_value(+);

  commit;

  insert into temp_page_total
    (page_key, page_name, page_value, application_key, totalpv, totaluv)
    select k1.page_key,
           k1.page_name,
           k1.page_value,
           k1.application_key,
           count(k1.vid) as totalpv,
           count(distinct k1.vid) as totaluv
      from fact_page_view k1
     where k1.visit_date_key = startpoint
    /*   and exists
    (select *
             from fact_daily_goodpage_1 k2
            where k2.page_key = k1.page_key
              and k2.page_value=k1.page_value
              and k2.visit_date_key = k1.visit_date_key)*/
     group by k1.page_key, k1.page_name, k1.page_value, k1.application_key;

  commit;

  insert into fact_daily_goodpage
    (page_key,
     page_name,
     page_value,
     visit_date_key,
     application_nm,
     totalpv,
     totaluv,
     pagepv,
     pageuv,
     pageavgtime,
     ordercnt,
     orderuv,
     orderrate,
     goods_num,
     goods_amount
     
     )
  
    select m2.page_key,
           m2.page_name,
           m2.page_value,
           m2.visit_date_key,
           m2.application_nm,
           m1.totalpv,
           m1.totaluv,
           m2.pagepv,
           m2.pageuv,
           m2.pageavgtime,
           m2.ordercnt,
           m2.orderuv,
           m2.orderrate,
           m2.goods_num,
           m2.goods_amount
      from temp_page_total m1, fact_daily_goodpage_1 m2
     where m1.page_key = m2.page_key
       and m1.page_value = m2.page_value
       and m1.application_key = m2.application_key;

  commit;

  insert into fact_daily_topic
    select *
      from (select hh.visit_date_key,
                   --(select uu.title from  g_activity UU where  UU.TRACE_PAGE_NAME=hh.page_value) as 专题,
                   case
                     when hh.page_name = 'ZT_Detail2' then
                      (select x1.zt_name
                         from dim_zhuangti x1
                        where to_char(x1.zt_id) = hh.page_value)
                     when hh.page_name = 'WZT2' then
                      (select x1.zt_name
                         from dim_zhuangti x1
                        where x1.key = hh.page_value)
                     when hh.page_name = 'KFZT' then
                      (select uu.title
                         from g_activity uu
                        where uu.trace_page_name = hh.page_value)
                     when hh.page_name = 'hdact' then
                      (select uu.title
                         from g_activity uu
                        where uu.key_source = hh.page_value)
                   end as zt_name,
                   --hh.page_name,
                   --hh.page_value,
                   hh.application_nm,
                   hh.totaluv,
                   --hh.pageuv as 商品UV,
                   hh.orderuv,
                   hh.ordercnt,
                   hh.goods_num,
                   hh.goods_amount,
                   --hh.orderrate as  专题订购转化,
                   trunc(hh.orderuv / hh.totaluv, 3) as orderrate,
                   hh.pageavgtime,
                   to_date(to_char(hh.visit_date_key),'yyyymmdd')
              from fact_daily_goodpage hh
             where visit_date_key = startpoint
               and page_name in ('KFZT', 'ZT_Detail2', 'WZT2', 'hdact')) ff
     where ff.zt_name is not null;

  commit;

  insert into fact_daily_topic_goods
    select hh2.visit_date_key,
           case
             when hh2.page_name = 'ZT_Detail2' then
              (select x1.zt_name
                 from dim_zhuangti x1
                where to_char(x1.zt_id) = hh2.page_value)
             when hh2.page_name = 'WZT2' then
              (select x1.zt_name
                 from dim_zhuangti x1
                where x1.key = hh2.page_value)
             when hh2.page_name = 'KFZT' then
              (select uu.title
                 from g_activity uu
                where uu.trace_page_name = hh2.page_value)
             when hh2.page_name = 'hdact' then
              (select uu.title
                 from g_activity uu
                where uu.key_source = hh2.page_value)
           end as zt_name,
           hh2.item_code,
           hh2.goods_name,
           hh2.matdlt,
           hh2.brand_name,
           hh2.is_tv,
           hh2.goods_price,
           hh2.goodpv,
           hh2.gooduv,
           hh2.goodnum,
           hh2.goodamount,
           hh2.application_nm,
           to_date(to_char(hh2.visit_date_key),'yyyymmdd')
    
      from fact_daily_goodorder hh2
     where visit_date_key = startpoint
       and page_name in ('KFZT', 'ZT_Detail2', 'WZT2', 'hdact');

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
end processpagedaily;
/

