???create or replace procedure dw_user.processgoodsuv(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  number;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processgoodsuv'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_good_daily'; --此处需要手工录入该PROCEDURE操作的表格
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

  begin
    delete from fact_good_uv;
    delete from fact_good_od;
    commit;
  
    insert into fact_good_uv
      (visit_date_key,
       application_key,
       hmmd,
       item_code,
       item_name,
       matdlt,
       goods_price,
       uv,
       pv)
      select x1.visit_date_key,
             x1.application_key,
             x1.hmmd,
             x1.item_code,
             x1.item_name,
             x1.matdlt,
             x1.goods_price,
             nvl(x1.uv, 0) as uv,
             nvl(x1.pv, 0) as pv
        from (select v.visit_date_key,
                     decode(v.application_key, 10, 'IOS', 20, 'ANDROID') as application_key,
                     (select v2.hmmd from dim_hmsc v2 where v2.hmsc = v.hmsc) as hmmd,
                     (select v1.item_code
                        from dim_ec_good v1
                       where v1.goods_commonid =
                             to_number(case
                                         when regexp_like(v.page_value,
                                                          '.([a-z]+|[A-Z])') then
                                          '0'
                                         when regexp_like(v.page_value, '[[:punct:]]+') then
                                          '0'
                                         when v.page_value is null then
                                          '0'
                                         when v.page_value like '%null%' then
                                          '0'
                                         else
                                          regexp_replace(v.page_value, '\s', '')
                                       end)) as item_code,
                     (select v1.goods_name
                        from dim_ec_good v1
                       where v1.goods_commonid =
                             to_number(case
                                         when regexp_like(v.page_value,
                                                          '.([a-z]+|[A-Z])') then
                                          '0'
                                         when regexp_like(v.page_value, '[[:punct:]]+') then
                                          '0'
                                         when v.page_value is null then
                                          '0'
                                         when v.page_value like '%null%' then
                                          '0'
                                         else
                                          regexp_replace(v.page_value, '\s', '')
                                       end)) as item_name,
                     (select v1.matdlt
                        from dim_ec_good v1
                       where v1.goods_commonid =
                             to_number(case
                                         when regexp_like(v.page_value,
                                                          '.([a-z]+|[A-Z])') then
                                          '0'
                                         when regexp_like(v.page_value, '[[:punct:]]+') then
                                          '0'
                                         when v.page_value is null then
                                          '0'
                                         when v.page_value like '%null%' then
                                          '0'
                                         else
                                          regexp_replace(v.page_value, '\s', '')
                                       end)) as matdlt,
                     (select v1.goods_price
                        from dim_ec_good v1
                       where v1.goods_commonid =
                             to_number(case
                                         when regexp_like(v.page_value,
                                                          '.([a-z]+|[A-Z])') then
                                          '0'
                                         when regexp_like(v.page_value, '[[:punct:]]+') then
                                          '0'
                                         when v.page_value is null then
                                          '0'
                                         when v.page_value like '%null%' then
                                          '0'
                                         else
                                          regexp_replace(v.page_value, '\s', '')
                                       end)) as goods_price,
                     count(v.id) as pv,
                     count(distinct v.vid) as uv
              
                from fact_page_view v
               where v.visit_date_key = startpoint
                 and v.page_key in (2841, 1924, 6604, 6391)
                 and v.page_value != 'undefined'
                 and v.page_value != '0'
               group by v.visit_date_key,
                        v.application_key,
                        v.hmsc,
                        v.page_value) x1
       where x1.item_code is not null;
  
    commit;
  
    insert into fact_good_od
    
      (create_date_key,
       application_key,
       hmmd,
       item_code,
       item_name,
       matdlt,
       goods_price,
       js,
       je)
      select w.add_time as create_date_key,
             (select decode(w1.application_key, 10, 'IOS', 20, 'ANDROID')
                from fact_visitor_register w1
               where w1.vid = w.vid) as application_key,
             (select (select w2.hmmd from dim_hmsc w2 where w2.hmsc = w1.hmsc)
                from fact_visitor_register w1
               where w1.vid = w.vid) as hmmd,
             w.item_code as item_code,
             (select w3.goods_name
                from dim_ec_good w3
               where w3.item_code = w.item_code) as item_name,
             (select w3.matdlt
                from dim_ec_good w3
               where w3.item_code = w.item_code) as matdlt,
             (select w3.goods_price
                from dim_ec_good w3
               where w3.item_code = w.item_code) as goods_price,
             sum(case
                   when w.iscg = 1 then
                    w.goods_num
                 end) as js,
             sum(case
                   when w.iscg = 1 then
                    w.goods_pay_price
                 end) as je
        from order_good w
       where w.add_time = startpoint and w.app_name in ('KLGiPhone','KLGAndroid')
       group by w.add_time, w.vid, w.item_code;
  
    commit;
  
    insert into fact_good_daily
      (visit_date_key,
       application_key,
       hmmd,
       item_code,
       item_name,
       matdlt,
       goods_price,
       uv,
       pv,
       js,
       je)
      select a1.visit_date_key,
             a1.application_key,
             a1.hmmd,
             a1.item_code,
             a1.item_name,
             a1.matdlt,
             a1.goods_price,
             a1.uv,
             a1.pv,
             nvl(a2.js, 0) as js,
             trunc(nvl(a2.je, 0), 2) as je
        from fact_good_uv a1, fact_good_od a2
       where a1.visit_date_key = a2.create_date_key(+)
         and a1.application_key = a2.application_key(+)
         and a1.hmmd = a2.hmmd(+)
         and a1.item_code = a2.item_code(+)
         and a1.item_name = a2.item_name(+)
         and a1.matdlt = a2.matdlt(+)
         and a1.goods_price = a2.goods_price(+);
    commit;
  
  end;

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
  
end processgoodsuv;
/

