???create or replace procedure dw_user.processdacuzt(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdacuzt'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_dczt'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_daily_dczt
    (visit_date_key,
     title,
     application_nm,
     pageuv,
     orderuv,
     ordercnt,
     goods_num,
     goods_amount,
     order_rate,
     pageavgtime)
  
    select xx.visit_date_key,
           xx.title,
           xx.application_nm,
           sum(xx.pageuv) as pageuv,
           sum(xx.orderuv) as orderuv,
           sum(xx.ordercnt) as ordercnt,
           sum(xx.goods_num) as goods_num,
           sum(xx.goods_amount) as goods_amount,
           trunc(sum(xx.orderuv) / sum(xx.pageuv), 3) as order_rate,
           trunc(avg(xx.pageavgtime), 2) as pageavgtime
      from (select hh.visit_date_key as visit_date_key,
                   (select uu.title
                      from g_activity uu
                     where uu.trace_page_name = hh.page_value) as title,
                   decode(hh.application_nm,
                          'IOS',
                          'APP',
                          'ANDROID',
                          'APP',
                          'WEIXIN',
                          '微信',
                          '3G',
                          '3G',
                          'PC',
                          'PC') as application_nm,
                   hh.pageuv as pageuv,
                   hh.orderuv as orderuv,
                   hh.ordercnt as ordercnt,
                   hh.goods_num as goods_num,
                   hh.goods_amount as goods_amount,
                   hh.orderrate as orderrate,
                   hh.pageavgtime as pageavgtime
            
              from fact_daily_goodpage hh
             where visit_date_key = startpoint
               and page_name = 'KFZT') xx
     where xx.title is not null
     group by xx.visit_date_key, xx.title, xx.application_nm;

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
end processdacuzt;
/

