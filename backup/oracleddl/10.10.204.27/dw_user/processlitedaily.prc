???create or replace procedure dw_user.processlitedaily(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processlitedaily'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_plite'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_daily_plite
    select l1.visit_date_key,
           to_date(to_char(l1.visit_date_key), 'yyyymmdd') as vt_date,
           l1.pvtot,
           l1.uvtot,
           l2.orderrcnt,
           l2.ordertot,
           trunc(l2.orderrcnt / l1.uvtot, 3) as orderrate
      from (select ui.visit_date_key,
                   count(1) as pvtot,
                   count(distinct ui.vid) as uvtot
              from fact_page_view ui
             where ui.visit_date_key = startpoint
               and ui.application_key = 70
               and ui.hmsc = 'KLGMall'
             group by ui.visit_date_key) l1,
           (select e.add_time,
                   count(distinct e.member_key) as orderrcnt,
                   sum(e.order_amount) as ordertot
              from factec_order e
             where e.add_time = startpoint
               and e.app_name = 'KLGWX'
               and e.order_state >= 20
               and e.order_from not in ('995',
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
               and e.vid like 'wxlite%'
            
             group by e.add_time) l2
     where l1.visit_date_key = l2.add_time;

  commit;

  insert into fact_daily_pliteloudou
    select vv1.visit_date_key,
           to_date(to_char(vv1.visit_date_key), 'yyyymmdd') as vt_date,
           vv1.homepv,
           vv1.homeuv,
           vv1.goodpv,
           vv1.gooduv,
           vv1.orderconfirmpv,
           vv1.orderconfirmuv,
           vv2.ordercnt,
           vv2.ordermem,
           trunc((vv1.gooduv / vv1.homeuv), 2) as goodrate,
           trunc((vv1.orderconfirmuv / vv1.homeuv), 2) as orderconfirmrate,
           trunc((vv2.ordermem / vv1.homeuv), 2) as orderrate,
           trunc((vv2.orderyxmem / vv1.homeuv), 2) as orderyxrate,
           vv2.orderyxmem
    
      from (select ui2.visit_date_key,
                   count(ui2.id) as homepv,
                   count(distinct ui2.vid) as homeuv,
                   count(case
                           when ui2.page_key = 47518 then
                            1
                         end) as goodpv,
                   count(distinct(case
                                    when ui2.page_key = 47518 then
                                     ui2.vid
                                  end)) as gooduv,
                   count(case
                           when ui2.page_key = 47540 then
                            1
                         end) as orderconfirmpv,
                   count(distinct(case
                                    when ui2.page_key = 47540 then
                                     ui2.vid
                                  end)) as orderconfirmuv
              from fact_page_view ui2
             where ui2.visit_date_key = startpoint
               and ui2.application_key = 70
               and ui2.hmsc = 'KLGMall'
             group by ui2.visit_date_key) vv1,
           
           (select e.add_time,
                   count(e.member_key) as ordercnt,
                   count(distinct e.member_key) ordermem,
                   count(case
                           when e.order_state >= 20 and not exists
                            (select *
                                   from fact_order_reverse l3
                                  where l3.order_key = e.crm_order_no
                                    and l3.order_type = 0
                                    and l3.cancel_state = 0) then
                            e.member_key
                         end) as orderyxcnt,
                   count(distinct(case
                                    when e.order_state >= 20 and not exists
                                     (select *
                                            from fact_order_reverse l3
                                           where l3.order_key = e.crm_order_no
                                             and l3.order_type = 0
                                             and l3.cancel_state = 0) then
                                     e.member_key
                                  end)) orderyxmem
            
              from factec_order e
             where e.add_time = startpoint
               and e.app_name = 'KLGWX'
                  --and e.order_state >= 20
               and e.order_from not in ('995',
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
               and e.vid like 'wxlite%'
             group by e.add_time) vv2
     where vv1.visit_date_key = vv2.add_time;

  commit;

  insert into fact_daily_cpsaoma
    select bb3.visit_date_key,
           to_date(to_char(bb3.visit_date_key), 'yyyymmdd') as vt_date,
           bb3.pv,
           bb3.uv,
           bb2.smuvcnt,
           bb2.sm_orderrs,
           bb2.smyj,
           bb2.smcnt,
           trunc(bb2.smrate, 2) as smrate
      from (select ml.visit_date_key,
                   ml.smuvcnt,
                   ml.sm_orderrs,
                   ml.smyj,
                   ml.smcnt,
                   ml.sm_orderrs / ml.smuvcnt as smrate
              from fact_daily_wx_new ml
             where ml.visit_date_key = startpoint) bb2,
           
           (select a.visit_date_key,
                   count(1) as pv,
                   count(distinct vid) as uv
              from fact_page_view a
             where a.visit_date_key = startpoint
               and (a.page_key = 39910 or
                   a.page_name in ('Click_live_gd',
                                    'Click_live_order',
                                    'Click_broadcast',
                                    'Click_recommend_gd'))
             group by a.visit_date_key) bb3
     where bb2.visit_date_key = bb3.visit_date_key;

  commit;

  insert into fact_daily_appsource
    select n8.start_date_key,
           n8.vt_date,
           n8.leixin,
           count(distinct n8.vid1) as uv,
           sum(n8.pv) as pv,
           count(distinct(case
                            when vid2 is not null then
                             n8.vid2
                          end)) as orderrs,
           sum(n8.tot) as ordertot,
           trunc((count(distinct(case
                                   when vid2 is not null then
                                    n8.vid2
                                 end)) / count(distinct n8.vid1)),
                 3) as orderrate
      from (select n6.start_date_key,
                   n6.vt_date,
                   n6.vid1,
                   n6.leixin,
                   n6.pv,
                   n7.vid2,
                   n7.tot
              from (select n5.start_date_key,
                           n5.vt_date,
                           n5.vid as vid1,
                           n5.leixin,
                           sum(n5.page_count) as pv
                      from (select n1.start_date_key,
                                   to_date(to_char(n1.start_date_key),
                                           'yyyymmdd') as vt_date,
                                   n1.vid,
                                   n1.page_count,
                                   case
                                     when exists (select *
                                             from dim_hmsc g1
                                            where hmpl = '推广'
                                              and g1.hmsc = n1.hmsc) and
                                          not exists
                                      (select *
                                             from dim_vid_scan c5
                                            where c5.vid = n1.vid) then
                                      '推广'
                                     when not exists (select *
                                             from dim_hmsc g1
                                            where hmpl = '推广'
                                              and g1.hmsc = n1.hmsc) and
                                          not exists
                                      (select *
                                             from dim_vid_scan c5
                                            where c5.vid = n1.vid) then
                                      '自然'
                                     when exists (select *
                                             from dim_vid_scan c5
                                            where c5.vid = n1.vid)
                                     
                                      then
                                      '内部'
                                   end as leixin
                              from fact_session n1
                             where n1.start_date_key = startpoint
                               and n1.application_key in (10, 20)) n5
                     group by n5.start_date_key,
                              n5.vt_date,
                              n5.vid,
                              n5.leixin) n6,
                   (select n2.vid as vid2, sum(n2.order_amount) as tot
                      from factec_order n2
                     where n2.add_time = startpoint
                       and n2.order_state >= 20
                       and n2.order_from not in ('995',
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
                       and n2.app_name in ('KLGiPhone', 'KLGAndroid')
                     group by n2.vid) n7
             where n6.vid1 = n7.vid2(+)) n8
     group by n8.start_date_key, n8.vt_date, n8.leixin;

  commit;

  insert into fact_daily_apploudou
  
    select vv1.visit_date_key,
           to_date(to_char(vv1.visit_date_key), 'yyyymmdd') as vt_date,
           vv1.homepv,
           vv1.homeuv,
           vv1.goodpv,
           vv1.gooduv,
           vv1.orderconfirmpv,
           vv1.orderconfirmuv,
           vv2.ordercnt,
           vv2.ordermem,
           vv2.orderyxcnt,
           vv2.orderyxmem,
           trunc((vv1.gooduv / vv1.homeuv), 2) as goodrate,
           trunc((vv1.orderconfirmuv / vv1.homeuv), 2) as orderconfirmrate,
           trunc((vv2.ordermem / vv1.homeuv), 2) as orderrate,
           trunc((vv2.orderyxmem / vv1.homeuv), 2) as orderyxrate
      from (select ui2.visit_date_key,
                   count(ui2.id) as homepv,
                   count(distinct ui2.vid) as homeuv,
                   count(case
                           when ui2.page_key in (1924, 2841) then
                            1
                         end) as goodpv,
                   count(distinct(case
                                    when ui2.page_key in (1924, 2841) then
                                     ui2.vid
                                  end)) as gooduv,
                   count(case
                           when ui2.page_key in (1272, 2844, 57473, 55935) then
                            1
                         end) as orderconfirmpv,
                   count(distinct(case
                                    when ui2.page_key in (1272, 2844, 57473, 55935) then
                                     ui2.vid
                                  end)) as orderconfirmuv
              from fact_page_view ui2
             where ui2.visit_date_key = startpoint
               and ui2.application_key in (10, 20)
             group by ui2.visit_date_key) vv1,
           
           (select e.add_time,
                   count(case
                           when e.order_state >= 20 then
                            e.member_key
                         end) as ordercnt,
                   count(distinct(case
                                    when e.order_state >= 20 then
                                     e.member_key
                                  end)) ordermem,
                   count(case
                           when e.order_state >= 20 and not exists
                            (select *
                                   from fact_order_reverse l3
                                  where l3.order_key = e.crm_order_no
                                    and l3.order_type = 0
                                    and l3.cancel_state = 0) then
                            e.member_key
                         end) as orderyxcnt,
                   count(distinct(case
                                    when e.order_state >= 20 and not exists
                                     (select *
                                            from fact_order_reverse l3
                                           where l3.order_key = e.crm_order_no
                                             and l3.order_type = 0
                                             and l3.cancel_state = 0) then
                                     e.member_key
                                  end)) orderyxmem
            
              from factec_order e
             where e.add_time = startpoint
               and e.app_name in ('KLGiPhone', 'KLGAndroid')
                  --and e.order_state >= 20
               and e.order_from not in ('995',
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
             group by e.add_time) vv2
     where vv1.visit_date_key = vv2.add_time;

  commit;

  insert into fact_daily_pintuan
    select pp2.visit_date_key,
           to_date(to_char(pp2.visit_date_key), 'yyyymmdd') as vt_date,
           pp2.pv,
           pp2.uv,
           pp1.item_code,
           pp1.goods_name,
           pp1.leixin,
           decode(pp1.payment_code, 'online', '在线支付', 'offline', 'COD') as payment_code,
           pp1.app_name,
           pp1.rs,
           pp1.js,
           pp1.je,
           pp1.ds
      from (select v1.add_time,
                   to_date(to_char(v1.add_time), 'yyyymmdd'),
                   v1.item_code,
                   v1.goods_name,
                   v1.leixin,
                   v1.payment_code,
                   v1.app_name,
                   count(distinct v1.cust_no) as rs,
                   sum(v1.goods_num) as js,
                   sum(v1.goods_num * v1.goods_pay_price) as je,
                   count(distinct v1.order_id) as ds
              from (select b15.add_time,
                           b16.erp_code as item_code,
                           b16.goods_name,
                           case
                             when exists (select *
                                     from dim_ec_good b17
                                    where b17.goods_commonid = b16.goods_commonid
                                      and b17.is_tv = 0
                                      and b17.is_own_shop = 1) then
                              '自营'
                             when exists (select *
                                     from dim_ec_good b17
                                    where b17.goods_commonid = b16.goods_commonid
                                      and b17.is_tv = 1) then
                              'TV'
                             else
                              '自营'
                           end as leixin,
                           
                           b15.cust_no,
                           b16.order_id,
                           b16.goods_num,
                           b16.goods_pay_price,
                           b15.payment_code,
                           b15.app_name
                      from fact_pt_order b15, fact_pt_ordergoods b16
                     where b15.add_time = startpoint
                       and b15.order_state >= 20
                       and b15.order_id = b16.order_id) v1
             group by v1.add_time,
                      v1.item_code,
                      v1.goods_name,
                      v1.leixin,
                      v1.payment_code,
                      v1.app_name) pp1,
           
           (select ui2.visit_date_key,
                   count(id) as pv,
                   count(distinct ui2.vid) as uv
              from fact_page_view ui2
             where ui2.visit_date_key = startpoint
               and ui2.page_name = 'KFZT'
               and ui2.page_value = 'juhuasuan0901apppc'
             group by ui2.visit_date_key) pp2
     where pp1.add_time = pp2.visit_date_key;

  commit;

  insert into fact_daily_pintuan
    select pp2.visit_date_key,
           to_date(to_char(pp2.visit_date_key), 'yyyymmdd') as vt_date,
           pp2.pv,
           pp2.uv,
           pp1.item_code,
           pp1.goods_name,
           pp1.leixin,
           pp1.payment_code,
           pp1.app_name,
           pp1.rs,
           pp1.js,
           pp1.je,
           pp1.ds
      from (select v1.add_time,
                   to_date(to_char(v1.add_time), 'yyyymmdd'),
                   v1.item_code,
                   v1.goods_name,
                   v1.leixin,
                   v1.payment_code,
                   v1.app_name,
                   count(distinct v1.cust_no) as rs,
                   sum(v1.goods_num) as js,
                   sum(v1.order_amount) as je,
                   count(distinct v1.order_key) as ds
              from (select y5.posting_date_key as add_time,
                           y5.goods_common_key as item_code,
                           (select y7.goods_name
                              from dim_ec_good y7
                             where y7.item_code = y5.goods_common_key) as goods_name,
                           decode((select y7.is_tv
                                    from dim_ec_good y7
                                   where y7.item_code = y5.goods_common_key),
                                  1,
                                  'TV',
                                  0,
                                  '自营') as leixin,
                           y5.member_key as cust_no,
                           y5.order_key,
                           y5.nums as goods_num,
                           y5.order_amount,
                           case
                             when y5.sales_source_second_key = 10001 then
                              'COD'
                             else
                              '在线支付'
                           end as payment_code,
                           'TV' as app_name
                      from fact_goods_sales y5
                     where y5.posting_date_key = startpoint
                       and y5.sales_source_key = 10
                       and exists
                     (select *
                              from dim_ec_good y3
                             where y3.goods_name like '%拼拼拼%'
                               and y3.item_code = y5.goods_common_key)) v1
             group by v1.add_time,
                      v1.item_code,
                      v1.goods_name,
                      v1.leixin,
                      v1.payment_code,
                      v1.app_name) pp1,
           
           (select ui2.visit_date_key,
                   count(id) as pv,
                   count(distinct ui2.vid) as uv
              from fact_page_view ui2
             where ui2.visit_date_key = startpoint
               and ui2.page_name = 'KFZT'
               and ui2.page_value = 'juhuasuan0901apppc'
             group by ui2.visit_date_key) pp2
     where pp1.add_time = pp2.visit_date_key;

  commit;
  
  
 insert into  fact_daily_pintuan_tj
select 
pt.vt_date,
(sum(pt.uv)/count(pt.uv)) as uv,
(sum(pt.pv)/count(pt.pv)) as pv,
trunc(sum(pt.je)) as ptje,
sum(pt.ds) as ptds,
nvl(trunc (sum(case when pt.app_name!='TV' then  pt.rs end)/
 (sum(pt.uv)/count(pt.uv)),3),0) as orderrate,
trunc(sum(case when pt.payment_code='在线支付'  then pt.ds end)) as ptzxds,
trunc(sum(case when pt.payment_code='COD'  then pt.ds end)) as ptcodeds,
trunc(sum(case when pt.app_name='TV' then pt.ds end)) as pttvds ,
nvl(trunc(sum(case when pt.app_name!='TV' then pt.ds end)),0) as ptxmtds,
nvl(trunc(sum(case when pt.payment_code='在线支付'  then pt.ds end)/sum(pt.ds),3),0) as ptzxrate,
nvl(trunc(sum(case when pt.app_name!='TV' then pt.ds end)/sum(pt.ds),3),0) as ptxmtrate
 from   fact_daily_pintuan pt where pt.visit_date_key=startpoint
group by pt.vt_date;



   commit;
  



insert into  fact_daily_happcoin
select add_time,
 to_date(to_char(add_time), 'yyyymmdd') as od_date,
count(distinct( case when  fa.integrals_amount>0 then  fa.order_id end)) as happcoin_od,
trunc(avg(case when fa.integrals_amount>0 then  fa.order_amount end),2) as happcoin_avgodmount,
trunc(avg(case when fa.integrals_amount>0 then  fa.integrals_amount end),2) as happcoin_avg,
trunc(sum(case when fa.integrals_amount>0 then  fa.integrals_amount end)) as happcoin_total,
count(distinct fa.order_id) as dailyodcnt,
trunc(sum(fa.order_amount)) as dailytotal
  from factec_order fa
 where add_time =startpoint
   and order_state >= 20
   and order_from not in ('995',
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
group by  add_time ;


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
end processlitedaily;
/

