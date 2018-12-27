???create or replace procedure dw_user.processxinztweekly(startpoint in number,
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

  sp_name          := 'processxinztweekly'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_weekly_xinzt'; --此处需要手工录入该PROCEDURE操作的表格
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



insert into fact_weekly_xinzt
select 
to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd') as stats_date,
  startpoint||'至'||endpoint as tongji_range,
qd.name,qd.application_name,
sum(qd.goodspv) as goodspv,sum(qd.goodsuv) as goodsuv,sum(qd.ordercnt) as ordercnt,
sum(qd.orderrs) as orderrs,sum(qd.ordernum) as ordernum,sum(qd.order_amount) as order_amount,
--sum(qd.orderrs)/sum(qd.goodsuv)
trunc(case when sum(qd.orderrs)=0 then 0
  else  sum(qd.orderrs)/sum(qd.goodsuv) end,2) as order_rate
 from fact_daily_zhuangtinew_goods qd where visit_date_key between startpoint and endpoint
group by qd.name,qd.application_name
order by qd.name,qd.application_name;
 
commit;
 
 
 
insert into fact_weekly_xinzt_goods
select 
to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd') as stats_date,
  startpoint||'至'||endpoint as tongji_range,
qd.name,qd.item_code,qd.goods_name,qd.application_name,
sum(qd.goodspv) as goodspv,sum(qd.goodsuv) as goodsuv,sum(qd.ordercnt) as ordercnt,
sum(qd.orderrs) as orderrs,sum(qd.ordernum) as ordernum,sum(qd.order_amount) as order_amount,
--sum(qd.orderrs)/sum(qd.goodsuv)
trunc(case when sum(qd.orderrs)=0 then 0
  else  sum(qd.orderrs)/sum(qd.goodsuv) end,2) as order_rate
 from fact_daily_zhuangtinew_goods qd where visit_date_key between startpoint and endpoint
group by qd.name,qd.item_code,qd.goods_name,qd.application_name
order by qd.name,qd.item_code,qd.goods_name,qd.application_name;
 
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
end processxinztweekly;
/

