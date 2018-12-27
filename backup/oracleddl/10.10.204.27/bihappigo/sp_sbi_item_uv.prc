???create or replace procedure bihappigo.sp_sbi_item_uv is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'SP_SBI_ITEM_UV'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_item_uv'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from fact_item_uv;

  insert into fact_item_uv
    (sitem_code,
     sitem_name,
     visit_date_key,
     uvcount,
     uvrate,
     uvtotal
     
     )
    select t1.sitem_code,
           t1.title,
           t1.visit_date_key,
           t1.cnt1,
           trunc((t1.cnt1 / t2.cnt2) * 100, 2) || '%',
           t2.cnt2
      from (select c.visit_date_key,
                   d.sitem_code,
                   d.title,
                   count(distinct c.vid) as cnt1
              from (select a.page_value as pcode, a.*
                      from fact_page_view a
                     where a.application_name = 'klgwx'
                       and a.visit_date_key =
                           to_number(to_char((sysdate - 1), 'yyyymmdd'))) c,
                   ods_goodslist d
             where c.pcode is not null
               and c.pcode = to_char(d.sitem_code)
             group by c.visit_date_key, d.sitem_code, d.title) t1,
           (select y.visit_date_key, count(distinct y.vid) as cnt2
              from fact_page_view y
             where y.visit_date_key =
                   to_number(to_char((sysdate - 1), 'yyyymmdd'))
               and y.application_name = 'klgwx'
             group by y.visit_date_key) t2
     where t1.visit_date_key = t2.visit_date_key
     order by t1.cnt1 desc;

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
end sp_sbi_item_uv;
/

