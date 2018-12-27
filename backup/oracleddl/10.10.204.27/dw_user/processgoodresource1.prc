???create or replace procedure dw_user.processgoodresource1(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processgoodresource1'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_goodsresource_1 '; --此处需要手工录入该PROCEDURE操作的表格
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

  execute immediate 'truncate table tmp_0508_1';
  execute immediate 'truncate table tmp_0508_2';
  execute immediate 'truncate table tmp_0508_3';
  execute immediate 'truncate table tmp_0508_5';
  execute immediate 'truncate table fact_page_view_ck';
  execute immediate 'truncate table tmp_0509_mindate';
  delete from fact_daily_goodsresource y where y.date_key = startpoint;
  commit;

  insert into fact_page_view_ck
  
    select *
      from fact_page_view_hit v1
     where visit_date_key = startpoint
       and hit_is = 1
       and exists (select *
              from dim_resource_page v2
             where v2.page_name = v1.page_name);
  commit;

  insert into tmp_0509_mindate
    select vid, min(v1.visit_date) as mindate
      from fact_page_view_ck v1
     where exists (select *
              from dim_resource_page v2
             where v2.page_name = v1.page_name)
     group by vid;
  commit;

  update fact_page_view_ck ccc
     set ccc.page_value = 'Ja'
   where id = 1227685407;
  commit;

  insert into tmp_0508_1
    (item_code,
     item_name,
     page_cnnm,
     pv,
     uv
     
     )
    select
    
     (select v3.item_code
        from dim_ec_good v3
       where v3.goods_commonid = to_number(case
                                           /*原正则表达式：.([a-z]+|[A-Z]) by yangjin 2018-08-31*/
                                             when regexp_like(v1.page_value, '.|([a-z]+|[A-Z])') then
                                              '0'
                                             when regexp_like(v1.page_value, '[[:punct:]]+') then
                                              '0'
                                             when regexp_like(v1.page_value, '[^x00-xff]') then
                                              '0'
                                             when v1.page_value is null then
                                              '0'
                                             when v1.page_value like '%null%' then
                                              '0'
                                           
                                             else
                                              regexp_replace(v1.page_value, '\s', '')
                                           end)) as item_code,
     
     (select v3.goods_name
        from dim_ec_good v3
       where v3.goods_commonid = to_number(case
                                           /*原正则表达式：.([a-z]+|[A-Z]) by yangjin 2018-08-31*/
                                             when regexp_like(v1.page_value, '.|([a-z]+|[A-Z])') then
                                              '0'
                                             when regexp_like(v1.page_value, '[[:punct:]]+') then
                                              '0'
                                             when regexp_like(v1.page_value, '[^x00-xff]') then
                                              '0'
                                             when v1.page_value is null then
                                              '0'
                                             when v1.page_value like '%null%' then
                                              '0'
                                           
                                             else
                                              regexp_replace(v1.page_value, '\s', '')
                                           end)) as item_name,
     
     (select p1.page_name
        from dim_resource_page p1
       where p1.page_name = v1.page_name) as page_cnnm,
     count(1) as pv,
     count(distinct v1.vid) as uv
      from fact_page_view_ck v1
     where visit_date_key = startpoint
       and exists (select *
              from dim_resource_page v2
             where v2.page_name = v1.page_name)
     group by v1.page_name,
              to_number(case
                        /*原正则表达式：.([a-z]+|[A-Z]) by yangjin 2018-08-31*/
                          when regexp_like(v1.page_value, '.|([a-z]+|[A-Z])') then
                           '0'
                          when regexp_like(v1.page_value, '[[:punct:]]+') then
                           '0'
                          when regexp_like(v1.page_value, '[^x00-xff]') then
                           '0'
                          when v1.page_value is null then
                           '0'
                          when v1.page_value like '%null%' then
                           '0'
                        
                          else
                           regexp_replace(v1.page_value, '\s', '')
                        end);

  delete from tmp_0508_1 where item_code is null;
  commit;

  insert into tmp_0508_3
    (item_code,
     item_name,
     page_cnnm,
     pv,
     uv
     
     )
    select m.item_code,
           m.item_name,
           m.page_cnnm,
           sum(m.pv) as pv,
           sum(m.uv) as uv
      from tmp_0508_1 m
     group by m.item_code, m.item_name, m.page_cnnm;

  commit;

  insert into tmp_0508_2
    (item_code,
     item_name,
     page_cnnm,
     rs,
     je,
     js
     
     )
    select (select v3.item_code
              from dim_ec_good v3
             where v3.goods_commonid = to_number(case
                                                 /*原正则表达式：.([a-z]+|[A-Z]) by yangjin 2018-08-31*/
                                                   when regexp_like(v1.page_value, '.|([a-z]+|[A-Z])') then
                                                    '0'
                                                   when regexp_like(v1.page_value, '[[:punct:]]+') then
                                                    '0'
                                                   when regexp_like(v1.page_value, '[^x00-xff]') then
                                                    '0'
                                                   when v1.page_value is null then
                                                    '0'
                                                   when v1.page_value like '%null%' then
                                                    '0'
                                                 
                                                   else
                                                    regexp_replace(v1.page_value, '\s', '')
                                                 end)) as item_code,
           
           (select v3.goods_name
              from dim_ec_good v3
             where v3.goods_commonid = to_number(case
                                                 /*原正则表达式：.([a-z]+|[A-Z]) by yangjin 2018-08-31*/
                                                   when regexp_like(v1.page_value, '.|([a-z]+|[A-Z])') then
                                                    '0'
                                                   when regexp_like(v1.page_value, '[[:punct:]]+') then
                                                    '0'
                                                   when regexp_like(v1.page_value, '[^x00-xff]') then
                                                    '0'
                                                   when v1.page_value is null then
                                                    '0'
                                                   when v1.page_value like '%null%' then
                                                    '0'
                                                 
                                                   else
                                                    regexp_replace(v1.page_value, '\s', '')
                                                 end)) as item_name,
           
           (select p1.page_name
              from dim_resource_page p1
             where p1.page_name = v1.page_name) as page_cnnm,
           count(distinct v8.cust_no) as rs,
           sum(v8.goods_pay_price * v8.goods_num) as je,
           sum(v8.goods_num) as js
      from fact_page_view_ck v1,
           (select *
              from order_good v7
             where v7.add_time = startpoint
               and v7.iscg = 1) v8
     where v1.visit_date_key = startpoint
       and exists (select *
              from dim_resource_page v2
             where v2.page_name = v1.page_name)
       and exists (select *
              from tmp_0509_mindate h3
             where h3.vid = v1.vid
               and h3.mindate = v1.visit_date)
       and v1.visit_date_key = v8.add_time(+)
       and to_number(case
                     /*原正则表达式：.([a-z]+|[A-Z]) by yangjin 2018-08-31*/
                       when regexp_like(v1.page_value, '.|([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(v1.page_value, '[[:punct:]]+') then
                        '0'
                       when regexp_like(v1.page_value, '[^x00-xff]') then
                        '0'
                       when v1.page_value is null then
                        '0'
                       when v1.page_value like '%null%' then
                        '0'
                     
                       else
                        regexp_replace(v1.page_value, '\s', '')
                     end) = v8.goods_commonid(+)
       and v1.vid = v8.vid(+)
     group by v1.page_name,
              
              to_number(case
                        /*原正则表达式：.([a-z]+|[A-Z]) by yangjin 2018-08-31*/
                          when regexp_like(v1.page_value, '.|([a-z]+|[A-Z])') then
                           '0'
                          when regexp_like(v1.page_value, '[[:punct:]]+') then
                           '0'
                          when regexp_like(v1.page_value, '[^x00-xff]') then
                           '0'
                          when v1.page_value is null then
                           '0'
                          when v1.page_value like '%null%' then
                           '0'
                        
                          else
                           regexp_replace(v1.page_value, '\s', '')
                        end);

  commit;

  insert into tmp_0508_5
    (item_code,
     item_name,
     page_cnnm,
     rs,
     je,
     js
     
     )
    select m.item_code,
           m.item_name,
           m.page_cnnm,
           sum(m.rs) as rs,
           sum(m.je) as je,
           sum(m.js) as js
      from tmp_0508_2 m
     group by m.item_code, m.item_name, m.page_cnnm;

  commit;

  insert into fact_daily_goodsresource
    (date_key,
     item_code,
     item_name,
     page_cnnm,
     pv,
     uv,
     rs,
     je,
     js
     
     )
    select startpoint as date_key,
           h1.item_code,
           h1.item_name,
           h1.page_cnnm,
           h1.pv,
           h1.uv,
           nvl(h2.rs, 0) as rs,
           nvl(h2.je, 0) as je,
           nvl(h2.js, 0) as js
      from tmp_0508_3 h1, tmp_0508_5 h2
     where h1.item_code = h2.item_code(+)
       and h1.item_name = h2.item_name(+)
       and h1.page_cnnm = h2.page_cnnm(+);

  commit;

  /* update fact_daily_goodsresource t1
     set t1.page_cnnm =
         (select t2.zt_name
            from dim_zhuangti t2
           where t2.zttypenm = 'ZT_Detail2'
             and t2.zt_id = substr(t1.page_cnnm, 15, 4)
          
          )
   where t1.date_key = startpoint
     and t1.page_cnnm like 'SL_ZT_Detail2_%'
     and regexp_like(substr(t1.page_cnnm, 15, 4), '[[:digit:]]');
  
  commit;*/

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
end processgoodresource1;
/

