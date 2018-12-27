???create or replace procedure dw_user.processgoodvideo(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processgoodvideo'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_goodvideo'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_daily_goodvideo
    (statsdate,
     item_code,
     goods_name,
     matdlt,
     group_name,
     pv,
     uv,
     avgnum,
     goodpv,
     gooduv,
     goodavg,
     goodnum,
     custnum,
     goodmount)
  
    select startpoint as statsdate,
           v1.item_code,
           v1.goods_name,
           v1.matdlt,
           v1.group_name,
           v1.pv,
           v1.uv,
           v1.avgnum,
           v2.goodpv,
           v2.gooduv,
           v2.goodavg,
           nvl(v3.goodnum, 0) as goodnum,
           nvl(v3.custnum, 0) as custnum,
           nvl(v3.goodmount, 0) as goodmount
      from (select x1.page_value,
                   (select y1.item_code
                      from dim_good y1
                     where y1.item_code = get_itemcode(x1.page_value)
                       and rownum = 1) as item_code,
                   (select y1.goods_name
                      from dim_good y1
                     where y1.item_code = get_itemcode(x1.page_value)
                       and rownum = 1) as goods_name,
                   (select y1.matdlt
                      from dim_good y1
                     where y1.item_code = get_itemcode(x1.page_value)
                       and rownum = 1) as matdlt,
                   (select y1.group_name
                      from dim_good y1
                     where y1.item_code = get_itemcode(x1.page_value)
                       and rownum = 1) as group_name,
                   count(x1.vid) as pv,
                   count(distinct x1.vid) as uv,
                   trunc(avg(x1.page_staytime), 2) as avgnum
              from fact_page_view x1
             where visit_date_key = 20170617
               and page_key in (40899, 40903)
             group by x1.page_value) v1,
           
           (select x2.page_value,
                   count(x2.vid) as goodpv,
                   count(distinct x2.vid) as gooduv,
                   trunc(avg(x2.page_staytime), 2) as goodavg
              from fact_page_view x2
             where x2.visit_date_key = 20170617
               and x2.page_key in (1924, 2841)
             group by x2.page_value) v2,
           
           (select x3.goods_commonid,
                   sum(x3.goods_num) as goodnum,
                   count(distinct x3.cust_no) as custnum,
                   sum(x3.goods_pay_price * x3.goods_num) as goodmount
              from order_good x3
             where x3.add_time = 20170617
               and x3.iscg = 1
             group by x3.goods_commonid) v3
     where v1.page_value = v2.page_value(+)
       and v2.page_value = v3.goods_commonid(+);

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
end processgoodvideo;
/

