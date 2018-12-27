???create or replace procedure dw_user.processpage_detail(startpoint in number) is
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
  sp_name          := 'processpage_detail'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view'; --此处需要手工录入该PROCEDURE操作的表格
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

  declare
  
  begin
    delete from fact_pagegoods;
    delete from fact_pageorders;
    commit;
  
    insert into fact_pagegoods
      (id,
       page_key,
       page_value,
       page_name,
       application_key,
       goodcode,
       session_key,
       vid,
       visit_date,
       page_staytime
       
       )
      select a1.id,
             a1.ip_geo_key,
             a1.hmci as page_value,
             --  to_number(var_array(i).page_value),
             (select nvl(a2.page_name, 'nopage')
                from dim_page_gn a2
               where a2.page_key = a1.ip_geo_key) as page_name,
             a1.application_key,
             to_number(case
                         when regexp_like(a1.page_value, '.([a-z]+|[A-Z])') then
                          '0'
                         when regexp_like(a1.page_value, '[[:punct:]]+') then
                          '0'
                       -- when regexp_like(a1.page_value, '[\u4e00-\u9fa5]+') then
                       --  '0'
                         when a1.page_value is null then
                          '0'
                         when a1.page_value like '%null%' then
                          '0'
                         else
                          regexp_replace(a1.page_value, '\s', '')
                       end) as goodcode,
             
             -- to_number(a1.page_value),
             a1.session_key,
             a1.vid,
             a1.visit_date,
             a1.page_staytime
        from fact_page_view a1
       where a1.visit_date_key = startpoint
         and a1.page_key in (1924, 2841, 24146, 11586, 355, 38629)
         and a1.page_value != 'undefined'
         and length(a1.page_value) <= 6;
    commit;
  
    delete from fact_page_ordergood;
    delete from fact_page_session;
    commit;
  
    insert into fact_page_ordergood
      (order_id,
       goods_num,
       goods_pay_price,
       vid,
       goods_commonid,
       goods_name,
       matdlt,
       brand_name,
       is_tv,
       cust_no,
       addtime,
       add_time)
    
      select t3.order_id,
             t3.goods_num,
             t3.goods_pay_price,
             t3.vid,
             t3.goods_commonid,
             t3.goods_name,
             t3.matdlt,
             t3.brand_name,
             t3.is_tv,
             t3.cust_no,
             t3.addtime,
             t3.add_time
        from order_good t3
       where t3.add_time = startpoint
         and t3.iscg = 1
         and exists (select *
                from fact_pagegoods p2
               where p2.goodcode = t3.goods_commonid);
  
    commit;
  
    insert into fact_page_session
      (session_key, start_time, end_time, member_key, vid)
    
      select t1.session_key,
             t1.start_time,
             t1.end_time,
             t1.member_key,
             t1.vid
        from fact_session t1
       where t1.start_date_key = startpoint
         and exists (select *
                from fact_pagegoods p1
               where p1.session_key = t1.session_key);
  
    commit;
  
    insert into fact_pageorders
      (order_id,
       goods_num,
       goods_pay_price,
       vid,
       goods_commonid,
       goods_name,
       session_key,
       addtime,
       add_time,
       matdlt,
       brand_name,
       is_tv)
    
      select t4.order_id,
             t4.goods_num,
             t4.goods_pay_price,
             t4.vid,
             t4.goods_commonid,
             t4.goods_name,
             t2.session_key,
             t4.addtime,
             t4.add_time,
             t4.matdlt,
             t4.brand_name,
             t4.is_tv
        from fact_page_session t2, fact_page_ordergood t4
       where t2.vid = t4.vid
         and t4.addtime >= t2.start_time
         and t4.addtime <= t2.end_time;
  
    commit;
  
  end;

  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.etl_status     := 'SUCCESS';
  S_ETL.ERR_MSG        := '输入参数startpoint:' || startpoint;
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
  
end processpage_detail;
/

