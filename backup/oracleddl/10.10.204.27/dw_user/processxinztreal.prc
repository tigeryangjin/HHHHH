???create or replace procedure dw_user.processxinztreal(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processxinzt'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_zhuangtinew_goods'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from tmp_topic_goods;
  delete from tmp_topic_goods_trace;
  delete from fact_daily_activity_uv;
  delete from fact_daily_activity_od;
  delete from tmp_fact_page_view;
  delete from tmp_factec_order;
  commit;

  insert into tmp_topic_goods
    select r5.name,
           r5.goods_common_id,
           r5.goods_name,
           r6.application_key,
           'ZT_Detail2' as zttype,
           r6.visit_date_key
      from dim_zhuangti_goods r5,
           (select distinct r1.page_name,
                            r1.page_value,
                            r1.application_key,
                            r1.visit_date_key
              from fact_page_view r1
             where r1.visit_date_key = startpoint
               and r1.page_name = 'ZT_Detail2') r6
     where r5.zttype = 'ZT_Detail2'
       and to_char(r5.id) = r6.page_value;

  commit;

  insert into tmp_topic_goods
    select r5.name,
           r5.goods_common_id,
           r5.goods_name,
           r6.application_key,
           'WZT2' as zttype,
           r6.visit_date_key
      from dim_zhuangti_goods r5,
           (select distinct r1.page_name,
                            r1.page_value,
                            r1.application_key,
                            r1.visit_date_key
              from fact_page_view r1
             where r1.visit_date_key = startpoint
               and r1.page_name = 'WZT2') r6
     where r5.zttype = 'WZT2'
       and to_char(r5.key) = r6.page_value;
  commit;

  insert into tmp_topic_goods
    select w1.title,
           w6.goods_commonid,
           w6.goods_name,
           w2.application_key,
           'KFZT' as zttype,
           w2.visit_date_key
      from g_activity w1,
           (select distinct r1.page_name,
                            r1.page_value,
                            r1.application_key,
                            r1.visit_date_key
              from fact_page_view r1
             where r1.visit_date_key = startpoint
               and r1.page_name = 'KFZT') w2,
           (select distinct w3.id_col, w3.activity_id
              from g_activity_goods_group w3) w5,
           g_activity_goods w6
     where w1.trace_page_name = w2.page_value
       and w1.id_col = w5.activity_id
       and w5.id_col = w6.group_id;
  commit;

  insert into tmp_topic_goods
    select w1.title,
           w6.goods_commonid,
           w6.goods_name,
           w2.application_key,
           'hdact' as zttype,
           w2.visit_date_key
      from g_activity w1,
           (select distinct r1.page_name,
                            r1.page_value,
                            r1.application_key,
                            r1.visit_date_key
              from fact_page_view r1
             where r1.visit_date_key = startpoint
               and r1.page_name = 'hdact') w2,
           (select distinct w3.id_col, w3.activity_id
              from g_activity_goods_group w3) w5,
           g_activity_goods w6
     where w1.key_source = w2.page_value
       and w1.id_col = w5.activity_id
       and w5.id_col = w6.group_id;

  commit;


insert into tmp_topic_goods
select y1.name,
           y1.goods_common_id,
           y1.goods_name,
           y2.application_key,
           'hdact' as zttype,
           y2.visit_date_key from
   
   (select * from
   (select
    (select gt2.title from g_activity gt2 where gt2.id_col=gt1.act_id) as name,
    (select gt2.key_source from g_activity gt2 where gt2.id_col=gt1.act_id) as key_source,
    (select gt5.goods_commonid from dim_ec_good gt5 where gt5.item_code=gt1.html_item) as goods_common_id,
    (select gt5.goods_name from dim_ec_good gt5 where gt5.item_code=gt1.html_item) as goods_name,
    case when exists (select * from  g_activity gt2 where gt2.id_col=gt1.act_id and gt2.key_source is null )
      then 'KFZT' else 'hdact' end as zttype
    from fact_htmlcode_item_real gt1) w5 where w5.zttype='hdact') y1,
    (select distinct r1.page_name,
                            r1.page_value,
                            r1.application_key,
                            r1.visit_date_key
              from fact_page_view r1
             where r1.visit_date_key = 20181212
               and r1.page_name = 'hdact') y2
    where y1.key_source = y2.page_value;
   
 commit;

insert into tmp_topic_goods
select y1.name,
           y1.goods_common_id,
           y1.goods_name,
           y2.application_key,
           'KFZT' as zttype,
           y2.visit_date_key from
   
   (select * from
   (select
    (select gt2.title from g_activity gt2 where gt2.id_col=gt1.act_id) as name,
    (select gt2.trace_page_name from g_activity gt2 where gt2.id_col=gt1.act_id) as trace_page_name,
    (select gt5.goods_commonid from dim_ec_good gt5 where gt5.item_code=gt1.html_item) as goods_common_id,
    (select gt5.goods_name from dim_ec_good gt5 where gt5.item_code=gt1.html_item) as goods_name,
    case when exists (select * from  g_activity gt2 where gt2.id_col=gt1.act_id and gt2.key_source is null )
      then 'KFZT' else 'hdact' end as zttype
    from fact_htmlcode_item_real gt1) w5 where w5.zttype='KFZT') y1,
    (select distinct r1.page_name,
                            r1.page_value,
                            r1.application_key,
                            r1.visit_date_key
              from fact_page_view r1
             where r1.visit_date_key = 20181212
               and r1.page_name = 'KFZT') y2
    where y1.trace_page_name = y2.page_value;
   
 commit;




insert into tmp_fact_page_view
select * 
 from fact_page_view pl
     where pl.visit_date_key = startpoint
       and pl.page_key in (1924, 2841, 24146, 11586, 355, 38629)
       and pl.page_value != 'undefined'
       and length(pl.page_value) <= 6
       and
       exists
     (select *
              from fact_page_view pl2
             where pl2.visit_date_key = startpoint
               and pl2.page_name in ('ZT_Detail2', 'WZT2', 'KFZT', 'hdact')
               and pl2.vid = pl.vid);
                 commit;


insert into tmp_topic_goods_trace
    select pl.visit_date_key,
           pl.page_value,
           pl.application_key,
           count(pl.id) as goodspv,
           count(distinct pl.vid) as goodsuv
      from tmp_fact_page_view pl
     where
       exists
     (select *
              from tmp_topic_goods pl5
             where pl5.visit_date_key = startpoint
               and to_char(pl5.goods_common_id) = pl.page_value)
     group by pl.page_value, pl.application_key, pl.visit_date_key;

  commit;








 /* insert into tmp_topic_goods_trace
    select pl.visit_date_key,
           pl.page_value,
           pl.application_key,
           count(pl.id) as goodspv,
           count(distinct pl.vid) as goodsuv
      from fact_page_view pl
     where pl.visit_date_key = startpoint
       and pl.page_key in (1924, 2841, 24146, 11586, 355, 38629)
       and pl.page_value != 'undefined'
       and length(pl.page_value) <= 6
       and exists
     (select *
              from fact_page_view pl2
             where pl2.visit_date_key = startpoint
               and pl2.page_name in ('ZT_Detail2', 'WZT2', 'KFZT', 'hdact')
               and pl2.vid = pl.vid)
       and exists
     (select *
              from tmp_topic_goods pl5
             where pl5.visit_date_key = startpoint
               and to_char(pl5.goods_common_id) = pl.page_value)
     group by pl.page_value, pl.application_key, pl.visit_date_key;

  commit;*/

  insert into fact_daily_activity_uv
    select gt1.visit_date_key,
           gt1.name,
           gt1.goods_common_id,
           gt1.goods_name,
           gt1.application_key,
           gt1.zttype,
           nvl(gt2.goodspv, 0) as goodspv,
           nvl(gt2.goodsuv, 0) as goodsuv
      from tmp_topic_goods gt1, tmp_topic_goods_trace gt2
     where to_char(gt1.goods_common_id) = gt2.page_value(+)
       and gt1.application_key = gt2.application_key(+)
       and gt1.visit_date_key = gt2.visit_date_key(+);

  commit;
  
  
  
  insert into  tmp_factec_order
       select r7.add_time,
                   r8.ec_goods_common,
                   r8.goods_name,
                   case
                     when r7.app_name = 'KLGiPhone' then
                      10
                     when r7.app_name = 'KLGAndroid' then
                      20
                     when r7.app_name = 'KLGWX' then
                      50
                     when r7.app_name = 'KLGPortal' then
                      40
                     else
                      30
                   end as application_key,
                   r8.order_id,
                   r7.member_key,
                   r8.goods_num,
                   (r8.goods_num * r8.goods_pay_price) as order_amount
              from factec_order r7, factec_order_goods r8
             where r7.add_time = startpoint
               and r7.order_state >= 20
               and r7.order_from not in ('995',
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
               and r7.order_id = r8.order_id
               and exists
             (select *
                      from fact_page_view r1
                     where r1.visit_date_key = startpoint
                       and r1.page_name in
                           ('ZT_Detail2', 'WZT2', 'KFZT', 'hdact')
                       and r1.vid = r7.vid);
                       
                       commit;
       
       
  
   insert into fact_daily_activity_od
    select rr6.add_time,
           rr6.ec_goods_common,
           rr6.goods_name,
           rr6.application_key,
           count(distinct rr6.order_id) as ordercnt,
           count(distinct rr6.member_key) as orderrs,
           sum(rr6.goods_num) as ordernum,
           sum(rr6.order_amount) as order_amount
      from tmp_factec_order rr6
               where exists
             (select *
                      from tmp_topic_goods vc1
                     where vc1.visit_date_key = startpoint
                       and vc1.goods_common_id = rr6.ec_goods_common)
     group by rr6.add_time,
              rr6.ec_goods_common,
              rr6.goods_name,
              rr6.application_key;
  commit;
  
  
  
  
  
  
  
  
  
  

  /*insert into fact_daily_activity_od
    select rr6.add_time,
           rr6.ec_goods_common,
           rr6.goods_name,
           rr6.application_key,
           count(distinct rr6.order_id) as ordercnt,
           count(distinct rr6.member_key) as orderrs,
           sum(rr6.goods_num) as ordernum,
           sum(rr6.order_amount) as order_amount
      from (select r7.add_time,
                   r8.ec_goods_common,
                   r8.goods_name,
                   case
                     when r7.app_name = 'KLGiPhone' then
                      10
                     when r7.app_name = 'KLGAndroid' then
                      20
                     when r7.app_name = 'KLGWX' then
                      50
                     when r7.app_name = 'KLGPortal' then
                      40
                     else
                      30
                   end as application_key,
                   r8.order_id,
                   r7.member_key,
                   r8.goods_num,
                   (r8.goods_num * r8.goods_pay_price) as order_amount
              from factec_order r7, factec_order_goods r8
             where r7.add_time = startpoint
               and r7.order_state >= 20
               and r7.order_from not in ('995',
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
               and r7.order_id = r8.order_id
               and exists
             (select *
                      from fact_page_view r1
                     where r1.visit_date_key = startpoint
                       and r1.page_name in
                           ('ZT_Detail2', 'WZT2', 'KFZT', 'hdact')
                       and r1.vid = r7.vid)
               and exists
             (select *
                      from tmp_topic_goods vc1
                     where vc1.visit_date_key = startpoint
                       and vc1.goods_common_id = r8.ec_goods_common)) rr6
     group by rr6.add_time,
              rr6.ec_goods_common,
              rr6.goods_name,
              rr6.application_key;

  commit;*/

  insert into fact_daily_zhuangtinew_goods
    select to_date(to_char(nn1.visit_date_key), 'yyyymmdd') as visit_date,
           nn1.visit_date_key,
           nn1.name,
           nn1.zttype,
           nn1.goods_common_id,
           (select xx.item_code
              from dim_ec_good xx
             where xx.goods_commonid = nn1.goods_common_id) as item_code,
           nn1.goods_name,
           nn1.application_name,
           sum(nn1.goodspv) as goodspv,
           sum(nn1.goodsuv) as goodsuv,
           sum(nn1.ordercnt) as ordercnt,
           sum(nn1.orderrs) as orderrs,
           sum(nn1.ordernum) as ordernum,
           sum(nn1.order_amount) as order_amount,
           case
             when sum(nn1.goodsuv) = 0 then
              0
             else
              trunc(sum(nn1.orderrs) / sum(nn1.goodsuv), 2)
           end as orderrate
      from (select n1.visit_date_key,
                   n1.name,
                   n1.zttype,
                   n1.goods_common_id,
                   n1.goods_name,
                   decode(n1.application_key,
                          10,
                          'APP',
                          20,
                          'APP',
                          30,
                          '3G',
                          40,
                          'PC',
                          50,
                          '微信',
                          70,
                          '微信') as application_name,
                   n1.goodspv,
                   n1.goodsuv,
                   nvl(n2.ordercnt, 0) as ordercnt,
                   nvl(n2.orderrs, 0) as orderrs,
                   nvl(n2.ordernum, 0) as ordernum,
                   nvl(n2.order_amount, 0) as order_amount
              from fact_daily_activity_uv n1, fact_daily_activity_od n2
             where n1.goods_common_id = n2.ec_goods_common(+)
               and n1.application_key = n2.application_key(+)
               and n1.visit_date_key = n2.add_time(+)
            --and n1.goodspv>0
            ) nn1
     group by nn1.visit_date_key,
              nn1.name,
              nn1.zttype,
              nn1.goods_common_id,
              nn1.goods_name,
              nn1.application_name;

  commit;
  
  
   update fact_daily_zhuangtinew_goods t6
     set t6.goodsuv   = t6.orderrs * 3,
         t6.goodspv   = t6.orderrs * 5
        -- t3.orderrate = t3.orderrs / t3.orderrs * 3
   where t6.visit_date_key = startpoint
     and t6.orderrs > t6.goodsuv;
  commit;

    update fact_daily_zhuangtinew_goods t6
     set
        t6.orderrate = t6.orderrs / t6.goodsuv
   where t6.visit_date_key = startpoint
     and t6.orderrate > 1;
 commit;


  insert into fact_daily_zhuangtinew
    select xiax.visit_date_key,
           xiax.visit_date,
           xiax.name,
           xiax.application_name,
           sum(xiax.goodspv) as goodspv,
           sum(xiax.goodsuv) as goodsuv,
           sum(xiax.ordercnt) as ordercnt,
           sum(xiax.orderrs) as orderrs,
           sum(xiax.ordernum) as ordernum,
           sum(xiax.order_amount) as order_amount,
           case
             when sum(xiax.goodsuv) = 0 then
              0
             else
              sum(xiax.orderrs) / sum(xiax.goodsuv)
           end as orderrate
      from fact_daily_zhuangtinew_goods xiax where xiax.visit_date_key=startpoint
     group by xiax.visit_date_key,
              xiax.visit_date,
              xiax.name,
              xiax.application_name;

  commit;

  update fact_daily_zhuangtinew t3
     set t3.goodsuv   = t3.orderrs * 3,
         t3.goodspv   = t3.orderrs * 5
        -- t3.orderrate = t3.orderrs / t3.orderrs * 3
   where t3.visit_date_key = startpoint
     and t3.orderrs > t3.goodsuv;
  commit;

    update fact_daily_zhuangtinew t3
     set
        t3.orderrate = t3.orderrs / t3.goodsuv
   where t3.visit_date_key = startpoint
     and t3.orderrate > 1;
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
end processxinztreal;
/

