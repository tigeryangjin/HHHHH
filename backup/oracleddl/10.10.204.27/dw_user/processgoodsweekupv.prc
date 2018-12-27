???create or replace procedure dw_user.processgoodsweekupv(startpoint  in varchar2,
                                                endpoint    in varchar2,
                                                startpoint_1 in number,
                                                endpoint_1   in number
                                                ) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processgoodsweekupv'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_WEEK_GOODS_PVUV'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_week_goods_pvuv
    (weeknm,
     goods_code,
     goods_name,
     goodspv,
     goodsuv,
     threegpv,
     threeguv,
     pcpv,
     pcuv,
     wxpv,
     wxuv,
     appuv,
     apppv)
  
    select  startpoint || '年' || '第' ||
           endpoint || '周' ||
           startpoint_1 || '至' ||
           endpoint_1 as weeknm,
           (select v1.item_code
              from dim_ec_good v1
             where v1.goods_commonid = to_number(case
                                                   when regexp_like(v.page_value, '.([a-z]+|[A-Z])') then
                                                    '0'
                                                   when regexp_like(v.page_value, '[[:punct:]]+') then
                                                    '0'
                                                   when v.page_value is null then
                                                    '0'
                                                   when v.page_value like '%null%' then
                                                    '0'
                                                   else
                                                    regexp_replace(v.page_value, '\s', '')
                                                 end)) as goods_code,
           (select v1.goods_name
              from dim_ec_good v1
             where v1.goods_commonid = to_number(case
                                                   when regexp_like(v.page_value, '.([a-z]+|[A-Z])') then
                                                    '0'
                                                   when regexp_like(v.page_value, '[[:punct:]]+') then
                                                    '0'
                                                   when v.page_value is null then
                                                    '0'
                                                   when v.page_value like '%null%' then
                                                    '0'
                                                   else
                                                    regexp_replace(v.page_value, '\s', '')
                                                 end)) as goods_name
           
          ,
           count(1) as goodspv,
           count(distinct v.vid) as goodsuv,
           count(case
                   when v.application_key = 30 then
                    1
                 end) as threegpv,
           count(distinct(case
                            when v.application_key = 30 then
                             vid
                          end)) as threeguv,
           count(case
                   when v.application_key = 40 then
                    1
                 end) as pcpv,
           count(distinct(case
                            when v.application_key = 40 then
                             vid
                          end)) as pcuv,
           count(case
                   when v.application_key = 50 then
                    1
                 end) as wxpv,
           count(distinct(case
                            when v.application_key = 50 then
                             vid
                          end)) as wxuv,
           count(case
                   when v.application_key in (10, 20) then
                    1
                 end) as apppv,
           count(distinct(case
                            when v.application_key in (10, 20) then
                             vid
                          end)) as appuv
      from fact_page_view v
     where v.visit_date_key between
           startpoint_1 and
           endpoint_1
       and v.page_key in (1924, 2841, 24146, 11586, 355, 38629)
     group by to_number(case
                          when regexp_like(v.page_value, '.([a-z]+|[A-Z])') then
                           '0'
                          when regexp_like(v.page_value, '[[:punct:]]+') then
                           '0'
                          when v.page_value is null then
                           '0'
                          when v.page_value like '%null%' then
                           '0'
                          else
                           regexp_replace(v.page_value, '\s', '')
                        end),
              startpoint || '年' || '第' ||
              endpoint || '周' ||
              startpoint_1 || '至' ||
              endpoint_1;

  insert_rows := sql%rowcount;
  commit;

  delete from fact_week_goods_pvuv y where y.goods_code is null;

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
end processgoodsweekupv;
/

