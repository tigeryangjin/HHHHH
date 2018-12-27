???create or replace procedure dw_user.processtoptengdsscan(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processtoptengdsscan'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_top10_gdscannew'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_top10_gdscannew
    (stat_date_key,
     goods_common_key,
     goods_name,
     matdlt,
     group_name,
     isbochu,
     order_nums,
     orderamount)
    select startpoint as stat_date_key,
           goods_common_key,
           goods_name,
           matdlt,
           group_name,
           isbochu,
           order_nums,
           orderamount
      from (select *
              from (select w1.goods_common_key,
                           (select w2.goods_name
                              from dim_good w2
                             where w2.item_code = w1.goods_common_key
                               and
                                  
                                   rownum = 1) as goods_name,
                           (select w2.matdlt
                              from dim_good w2
                             where w2.item_code = w1.goods_common_key
                               and
                                  
                                   rownum = 1) as matdlt,
                           (select w2.group_name
                              from dim_good w2
                             where w2.item_code = w1.goods_common_key
                               and
                                  
                                   rownum = 1) as group_name,
                           case
                             when w1.live_state = 0 and w1.replay_state = 0 then
                              '没有播出'
                             else
                              '有播出'
                           end as isbochu,
                           sum(nvl(case
                                     when exists (select *
                                             from (select v5.member_key
                                                     from (select *
                                                             from dim_vid_scan v2
                                                            where v2.scan_date_key =
                                                                  startpoint
                                                                 --and v2.scan_date_key =
                                                                 --  v2.active_date_key
                                                              and v2.is_new = 1) v3,
                                                          dim_vid_mem v5
                                                    where v3.vid = v5.vid) b1
                                            where b1.member_key = w1.member_key
                                           
                                           )
                                     
                                      then
                                      w1.nums
                                   end,
                                   0)) as order_nums,
                           
                           sum(nvl(case
                                     when exists (select *
                                             from (select v5.member_key
                                                     from (select *
                                                             from dim_vid_scan v2
                                                            where v2.scan_date_key =
                                                                  startpoint
                                                                 --and v2.scan_date_key =
                                                                 --  v2.active_date_key
                                                              and v2.is_new = 1) v3,
                                                          dim_vid_mem v5
                                                    where v3.vid = v5.vid) b1
                                            where b1.member_key = w1.member_key
                                           
                                           )
                                     
                                      then
                                      w1.order_amount
                                   end,
                                   0)) as orderamount
                      from fact_goods_sales w1
                     where w1.order_date_key = startpoint
                       and w1.order_state = 1
                       and w1.sales_source_key = 20
                       and w1.sales_source_second_key in (20015, 20017)
                     group by w1.goods_common_key,
                              case
                                when w1.live_state = 0 and w1.replay_state = 0 then
                                 '没有播出'
                                else
                                 '有播出'
                              end)
             order by orderamount desc)
     where rownum <= 10;

  commit;

  insert into fact_top10_gdscanold
    (stat_date_key,
     goods_common_key,
     goods_name,
     matdlt,
     group_name,
     isbochu,
     order_nums,
     orderamount
     
     )
  
    select startpoint as stat_date_key,
           goods_common_key,
           goods_name,
           matdlt,
           group_name,
           isbochu,
           order_nums,
           orderamount
    
      from (select *
              from (select w1.goods_common_key,
                           (select w2.goods_name
                              from dim_good w2
                             where w2.item_code = w1.goods_common_key
                               and
                                  
                                   rownum = 1) as goods_name,
                           (select w2.matdlt
                              from dim_good w2
                             where w2.item_code = w1.goods_common_key
                               and
                                  
                                   rownum = 1) as matdlt,
                           (select w2.group_name
                              from dim_good w2
                             where w2.item_code = w1.goods_common_key
                               and
                                  
                                   rownum = 1) as group_name,
                           case
                             when w1.live_state = 0 and w1.replay_state = 0 then
                              '没有播出'
                             else
                              '有播出'
                           end as isbochu,
                           sum(nvl(case
                                     when exists (select *
                                             from (select v5.member_key
                                                     from (select *
                                                             from dim_vid_scan v2
                                                            where v2.scan_date_key <
                                                                  startpoint
                                                              and v2.scan_date_key >=
                                                                  to_number(to_char((sysdate - 90),
                                                                                    'yyyymmdd'))
                                                           --and v2.is_new=0
                                                           ) v3,
                                                          dim_vid_mem v5
                                                    where v3.vid = v5.vid) b1
                                            where b1.member_key = w1.member_key
                                           
                                           )
                                     
                                      then
                                      w1.nums
                                   end,
                                   0)) as order_nums,
                           
                           sum(nvl(case
                                     when exists (select *
                                             from (select v5.member_key
                                                     from (select *
                                                             from dim_vid_scan v2
                                                            where v2.scan_date_key <
                                                                  startpoint
                                                              and v2.scan_date_key >=
                                                                  to_number(to_char((sysdate - 90),
                                                                                    'yyyymmdd'))
                                                           --and v2.is_new=0 
                                                           ) v3,
                                                          dim_vid_mem v5
                                                    where v3.vid = v5.vid) b1
                                            where b1.member_key = w1.member_key
                                           
                                           )
                                     
                                      then
                                      w1.order_amount
                                   end,
                                   0)) as orderamount
                      from fact_goods_sales w1
                     where w1.order_date_key = startpoint
                       and w1.order_state = 1
                       and w1.sales_source_key = 20
                       and w1.sales_source_second_key in (20015, 20017)
                     group by w1.goods_common_key,
                              case
                                when w1.live_state = 0 and w1.replay_state = 0 then
                                 '没有播出'
                                else
                                 '有播出'
                              end)
             order by orderamount desc)
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
end processtoptengdsscan;
/

