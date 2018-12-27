???create or replace procedure dw_user.processfactkeywordview(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  member_true number;
  goods_true  number;
  insert_ok   number;

  /*
  功能说明：用户关键词行为数据统计
       
  
  作者时间：bobo  2016-06-22
  */
begin
  sp_name          := 'processfactkeywordview'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_keyword_view'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  member_true      := 0;
  goods_true       := 0;
  insert_rows      := 0;
  --onetotal         := 50000; --一次取5000记录循环
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;
  delete from fact_keyword_view where create_date_key = postday;
  insert into fact_keyword_view
    (create_date_key,
     vid,
     channel_name,
     source_one,
     source_two,
     plan,
     adgroup,
     keyword,
     car_nums,
     register_member_nums,
     banner_nums)
    ((select pc.active_date_key as create_date_key,
             pc.vid,
             'pc' as channel_name,
             pc.LEVEL1 as source_one,
             pc.LEVEL2 as source_two,
             pc.plan,
             pc.adgroup,
             pc.keyword,
             (case when pc_sc.sc_nums  is not null then pc_sc.sc_nums
             else 0 end) as car_nums,
             (case when pms.member_nums is not null then pms.member_nums
             else 0 end) as register_member_nums,
             (case when pb.banner_count is not null then pb.banner_count
             else 0 end) as banner_nums
        from fact_daily_pcpromotion pc
        left join (select sum(scgq) as sc_nums, vid
                    from fact_shoppingcar
                   where create_date_key = postday
                     and scgq >= 1
                     and vid in (select vid
                                   from fact_daily_pcpromotion
                                  where active_date_key = postday)
                   group by vid) pc_sc
          on pc.vid = pc_sc.vid
        left join (select pm.vid, count(1) as member_nums
                    from (select vid, member_key
                            from fact_page_view
                           where visit_date_key = postday
                             and member_key != 0
                             and vid in
                                 (select vid
                                    from fact_daily_pcpromotion
                                   where active_date_key = postday)
                           group by vid, member_key) pm
                    left join fact_member_register fm
                      on pm.member_key = fm.member_key
                   where fm.register_date_key = postday
                   group by vid) pms
          on pms.vid = pc.vid
        left join (select count(1) as banner_count, vid
                    from fact_page_view
                   where page_name = 'bannerdownload'
                     and visit_date_key = postday
                     and vid in (select vid
                                   from fact_daily_pcpromotion
                                  where active_date_key = postday)
                   group by vid) pb
          on pb.vid = pc.vid
       where pc.active_date_key = postday) union
     (select pc.active_date_key as create_date_key,
             pc.vid,
             '3g' as channel_name,
             pc.LEVEL1 as source_one,
             pc.LEVEL2 as source_two,
             pc.plan,
             pc.adgroup,
             pc.keyword,
             (case when pc_sc.sc_nums is not null then pc_sc.sc_nums
             else 0 end) as car_nums,
             (case when pms.member_nums is not null then pms.member_nums
             else 0 end) as register_member_nums,
             (case when pb.banner_count is not null then pb.banner_count
             else 0 end) as banner_nums
        from fact_daily_3gpromotion pc
        left join (select sum(scgq) as sc_nums, vid
                    from fact_shoppingcar
                   where create_date_key = postday
                     and scgq >= 1
                     and vid in (select vid
                                   from fact_daily_3gpromotion
                                  where active_date_key = postday)
                   group by vid) pc_sc
          on pc.vid = pc_sc.vid
        left join (select pm.vid, count(1) as member_nums
                    from (select vid, member_key
                            from fact_page_view
                           where visit_date_key = postday
                             and member_key != 0
                             and vid in
                                 (select vid
                                    from fact_daily_3gpromotion
                                   where active_date_key = postday)
                           group by vid, member_key) pm
                    left join fact_member_register fm
                      on pm.member_key = fm.member_key
                   where fm.register_date_key = postday
                   group by vid) pms
          on pms.vid = pc.vid
        left join (select count(1) as banner_count, vid
                    from fact_page_view
                   where page_name = 'bannerdownload'
                     and visit_date_key = postday
                     and vid in (select vid
                                   from fact_daily_3gpromotion
                                  where active_date_key = postday)
                   group by vid) pb
          on pb.vid = pc.vid
       where pc.active_date_key = postday));
       insert_rows := sql%rowcount;
  
  /*日志记录模块*/
  s_etl.end_time := sysdate;
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
end processfactkeywordview;
/

