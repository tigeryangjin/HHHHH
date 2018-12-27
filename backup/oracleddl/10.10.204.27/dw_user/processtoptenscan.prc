???create or replace procedure dw_user.processtoptenscan(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processtoptenscan'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_top10_scanzt'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_top10_scanzt
    (page_name, page_value, newsm, sm, stat_date_key)
  
    select page_name, page_value, newsm, sm, startpoint
      from (select *
              from (select
                    
                     l1.page_name,
                     l1.page_value,
                     count(distinct(case
                                      when exists (select *
                                              from dim_vid_scan l2
                                             where l2.scan_date_key = startpoint
                                               and l2.is_new = 1
                                               and l2.vid = l1.vid) then
                                       vid
                                    end)) as newsm,
                     count(distinct(case
                                      when exists (select *
                                              from dim_vid_scan l2
                                             where l2.scan_date_key < startpoint
                                               and l2.scan_date_key >=
                                                   to_number(to_char((sysdate - 90),
                                                                     'yyyymmdd'))
                                                  -- and l2.scan_date_key != l2.active_date_key
                                               and l2.vid = l1.vid) then
                                       vid
                                    end)) as sm
                    
                      from fact_page_view l1
                     where l1.visit_date_key = startpoint
                       and l1.application_key in (10, 20)
                       and l1.page_key in
                           (8925, 8926, 36948, 36949, 40410, 40411)
                     group by l1.page_name, l1.page_value
                    
                    ) a
             order by sm desc) a2
     where rownum <= 10;

  commit;

  insert into fact_top10_scangoods
    (item_code, goods_name, newsm, sm, stat_date_key)
  
    select item_code, goods_name, newsm, sm, startpoint
      from (select *
              from (select
                    
                     (select l3.item_code
                        from dim_ec_good l3
                       where l3.goods_commonid =
                             to_number(case
                                         when regexp_like(l1.page_value,
                                                          '.([a-z]+|[A-Z])') then
                                          '0'
                                         when regexp_like(l1.page_value, '[[:punct:]]+') then
                                          '0'
                                         when l1.page_value is null then
                                          '0'
                                         when l1.page_value like '%null%' then
                                          '0'
                                         else
                                          regexp_replace(l1.page_value, '\s', '')
                                       end)) as item_code,
                     (select l3.goods_name
                        from dim_ec_good l3
                       where l3.goods_commonid =
                             to_number(case
                                         when regexp_like(l1.page_value,
                                                          '.([a-z]+|[A-Z])') then
                                          '0'
                                         when regexp_like(l1.page_value, '[[:punct:]]+') then
                                          '0'
                                         when l1.page_value is null then
                                          '0'
                                         when l1.page_value like '%null%' then
                                          '0'
                                         else
                                          regexp_replace(l1.page_value, '\s', '')
                                       end)) as goods_name,
                     count(distinct(case
                                      when exists (select *
                                              from dim_vid_scan l2
                                             where l2.scan_date_key = startpoint
                                               and l2.is_new = 1
                                                  --and l2.scan_date_key = l2.active_date_key
                                               and l2.vid = l1.vid) then
                                       vid
                                    end)) as newsm,
                     count(distinct(case
                                      when exists (select *
                                              from dim_vid_scan l2
                                             where l2.scan_date_key < startpoint
                                               and l2.scan_date_key >=
                                                   to_number(to_char((sysdate - 90),
                                                                     'yyyymmdd'))
                                                  -- and l2.scan_date_key != l2.active_date_key
                                               and l2.vid = l1.vid) then
                                       vid
                                    end)) as sm
                    
                      from fact_page_view l1
                     where l1.visit_date_key = startpoint
                       and l1.application_key in (10, 20)
                       and l1.page_key in (2841, 1924, 6604, 6391)
                     group by l1.page_value) a
             where a.goods_name is not null
             order by sm desc) a2
    
     where rownum <= 10;

  commit;

  insert into fact_top10_scanpage
    (page_name, newsm, sm, stat_date_key)
  
    select page_name, newsm, sm, startpoint
      from (select *
              from (select
                    
                     l1.page_name,
                     count(distinct(case
                                      when exists (select *
                                              from dim_vid_scan l2
                                             where l2.scan_date_key = startpoint
                                               and l2.is_new = 1
                                                  --and l2.scan_date_key = l2.active_date_key
                                               and l2.vid = l1.vid) then
                                       vid
                                    end)) as newsm,
                     count(distinct(case
                                      when exists (select *
                                              from dim_vid_scan l2
                                             where l2.scan_date_key < startpoint
                                               and l2.scan_date_key >=
                                                   to_number(to_char((sysdate - 90),
                                                                     'yyyymmdd'))
                                                  -- and l2.scan_date_key != l2.active_date_key
                                               and l2.vid = l1.vid) then
                                       vid
                                    end)) as sm
                    
                      from fact_page_view l1
                     where l1.visit_date_key = startpoint
                       and l1.application_key in (10, 20)
                       and l1.page_key not in (8925,
                                               8926,
                                               36948,
                                               36949,
                                               40410,
                                               40411,
                                               2841,
                                               1924,
                                               6604,
                                               6391)
                       and (page_name not like 'SL%' and
                           page_name not like 'LS%')
                       and application_key in (10, 20)
                    
                     group by l1.page_name, l1.page_value) a
             order by sm desc) a2
     where rownum <= 10;

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
end processtoptenscan;
/

