???create or replace procedure dw_user.createfestivalpg2(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'createfesvivalpg2'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_wechat'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into tmp_pg2
    (date_key, uv, pv, fans_num)
    select x1.visit_date_key, x1.uv, x1.pv, nvl(x2.fansnum,0)
      from (select y1.visit_date_key,
                   count(distinct vid) as uv,
                   count(1) as pv
              from fact_page_view y1
             where y1.visit_date_key = startpoint
               and y1.application_key = 50
               and to_char(y1.visit_date, 'hh24mi') between '1145' and
                   '1230'
             group by y1.visit_date_key) x1,
           (select tt.subscribe_time, nvl(count(1),0) as fansnum
              from dim_wechat tt
             where tt.subscribe_time = startpoint
               and to_char(tt.subscribe_date, 'hh24mi') between '1130' and
                   '1250'
             group by tt.subscribe_time) x2
     where x1.visit_date_key = x2.subscribe_time(+);

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
end createfestivalpg2;
/

