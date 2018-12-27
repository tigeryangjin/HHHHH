???create or replace procedure dw_user.processmarketrate(startpoint in number) is
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
  sp_name          := 'processmarketrate'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_lcrate_market'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    insert into fact_lcrate_market
      (create_date_key,
       application_key,
       hmmd,
       lcrate,
       paymount,
       hitcnt,
       viewcnt)
      select startpoint as create_date_key,
             decode(y2.application_key, 10, 'IOS', 20, 'ANDROID') as application_key,
             (select y3.hmmd from dim_hmsc y3 where y3.hmsc = y2.hmsc) as hmmd,
             trunc(nvl((y1.cnt2 / y2.cnt1), 0), 2) as lcrate,
             0,
             0,
             0
        from (select x1.application_key,
                     x1.hmsc,
                     count(distinct vid) as cnt2
                from (select a.application_key, a.hmsc, a.vid
                        from fact_visitor_register a
                       where a.application_key in (10, 20)
                         and a.create_date_key =
                             to_number(to_char(add_months(to_date(to_char(startpoint),
                                                                  'yyyymmdd'),
                                                          -1),
                                               'yyyymmdd'))
                      --group by a.create_date_key,a.application_key,a.hmsc
                      intersect
                      select b.application_key, b.hmsc, b.vid
                        from fact_session b
                       where b.application_key in (10, 20)
                         and b.start_date_key = startpoint) x1
               group by x1.application_key, x1.hmsc) y1,
             (select a1.application_key, a1.hmsc, count(a1.id) as cnt1
                from fact_visitor_register a1
               where a1.application_key in (10, 20)
                 and a1.create_date_key =
                     to_number(to_char(add_months(to_date(to_char(startpoint),
                                                          'yyyymmdd'),
                                                  -1),
                                       'yyyymmdd'))
               group by a1.application_key, a1.hmsc) y2
       where y2.application_key = y1.application_key(+)
         and y2.hmsc = y1.hmsc(+);
  
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
  
end processmarketrate;
/

