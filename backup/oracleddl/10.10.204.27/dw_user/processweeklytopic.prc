???create or replace procedure dw_user.processweeklytopic(startpoint in number,
                                               endpoint   in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processweeklytopic'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_weekly_topic'; --此处需要手工录入该PROCEDURE操作的表格
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



insert into fact_weekly_topic
  select
   to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd') as stats_date,
  startpoint||'至'||endpoint as tongji_range,
   ff.zt_name,
   ff.application_nm,
   sum(ff.totaluv) as weektotaluv,
   sum(ff.orderuv) as weekorderuv,
   sum(ff.ordercnt) as weekordercnt,
   sum(ff.goods_num) as weekgoods_num,
   sum(ff.goods_amount) as weekgoods_amount,
   trunc(sum(ff.orderuv)/sum(ff.totaluv),3) as weekorderrate,
   avg(ff.pageavgtime) as weekpageavgtime
   from
(select hh.visit_date_key ,
--(select uu.title from  g_activity UU where  UU.TRACE_PAGE_NAME=hh.page_value) as 专题,
case when  hh.page_name='ZT_Detail2' then
(select x1.zt_name from    dim_zhuangti x1 where to_char(x1.zt_id)=hh.page_value)
when  hh.page_name='WZT2' then
(select x1.zt_name from    dim_zhuangti x1 where x1.key=hh.page_value)
when  hh.page_name='KFZT' then
(select uu.title from  g_activity UU where  UU.TRACE_PAGE_NAME=hh.page_value)
when  hh.page_name='hdact' then
(select uu.title from  g_activity UU where  UU.Key_Source=hh.page_value)
end as zt_name,
--hh.page_name,
--hh.page_value,
hh.application_nm ,
hh.totaluv,
--hh.pageuv as 商品UV,
hh.orderuv,
hh.ordercnt,
hh.goods_num,
hh.goods_amount,
--hh.orderrate as  专题订购转化,
trunc(hh.orderuv/hh.totaluv,3) as orderrate,
hh.pageavgtime
 from fact_daily_goodpage hh where visit_date_key between  startpoint and endpoint and 
 page_name in ('KFZT','ZT_Detail2','WZT2','hdact')) ff where ff.zt_name is not null
 group by ff.zt_name,ff.application_nm;
 
 commit;
 
 
 insert into fact_weekly_topic_goods
 select
 to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd') as stats_date,
  startpoint||'至'||endpoint as tongji_range, 
  tt.zt_name,tt.item_code,tt.goods_name,tt.matdlt,tt.brand_name,tt.is_tv,tt.goods_price,
       tt.application_nm,sum(tt.goodpv) as weekgoodpv,sum(tt.gooduv) as weekgooduv,sum(tt.goodnum) as weekgoodnum,sum(tt.goodamount)
       as weekgoodamount
 from
  (select   
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
           hh2.application_nm
    
      from fact_daily_goodorder hh2
     where visit_date_key between  startpoint and endpoint
       and page_name in ('KFZT', 'ZT_Detail2', 'WZT2', 'hdact')) tt where tt.zt_name is not null
       group by tt.zt_name,tt.item_code,tt.goods_name,tt.matdlt,tt.brand_name,tt.is_tv,tt.goods_price,
       tt.application_nm order by 
    tt.zt_name,tt.item_code,tt.goods_name,tt.matdlt,tt.brand_name,tt.is_tv,tt.goods_price;
       
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
end processweeklytopic;
/

