???create or replace procedure dw_user.processcanmonth is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processcanmonth'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_scanmon'; --此处需要手工录入该PROCEDURE操作的表格
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

  declare
  
    type type_array is table of tmp_month%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from tmp_month e
     order by e.date_key;
  
    for i in 1 .. var_array.count loop
    
      insert into fact_daily_scanmon
        (stat_date_key,
         smrs,
         smxqy,
         ddtjy,
         xsm,
         bqyf,
         xsml,
         appjh,
         wxyj,
         wxdd,
         appyj,
         appdd,
         smyj,
         zyj,
         smzb,
         wxrs,
         apprs)
        select x1.stat_date_key,
               x1.smrs,
               x2.smxqy,
               x2.ddtjy,
               x3.xsm,
               x3.bqyf,
               x3.xsml,
               x3.appjh,
               x4.wxyj,
               x4.wxdd,
               x4.appyj,
               x4.appdd,
               x4.smyj,
               x4.zyj,
               x4.smzb,
               x4.wxrs,
               x4.apprs
          from (select var_array(i).date_key as stat_date_key,
                       count(distinct d1.vid) as smrs
                  from fact_page_view d1
                 where d1.visit_date_key = var_array(i).date_key
                   and (d1.page_key = 39910
                   or d1.page_name in ('Click_live_gd','Click_live_order','Click_broadcast','Click_recommend_gd'))
                   ) x1,
               
               (select var_array(i).date_key as stat_date_key,
                       count(distinct(case
                                        when exists (select *
                                                from dim_vid_scan w1
                                               where w1.scan_date_key = var_array(i).date_key
                                                 and w1.vid like 'wx%'
                                                 and w1.vid = d2.vid) and d2.page_key = 11586 then
                                         vid
                                      end
                                      
                                      )) as smxqy,
                       
                       count(distinct(case
                                        when exists
                                         (select *
                                                from dim_vid_scan w1
                                               where w1.scan_date_key = var_array(i).date_key
                                                 and w1.vid = d2.vid) and
                                             d2.page_key in (344, 6392, 6603, 16649, 5425, 2844, 1272, 24149) then
                                         vid
                                      end
                                      
                                      )) as ddtjy
                
                  from fact_page_view d2
                 where d2.visit_date_key = var_array(i).date_key) x2,
               
               (select var_array(i).date_key as stat_date_key,
                       count(distinct(case
                                        when m1.is_new = 1 then
                                         vid
                                      end)) as xsm,
                       count(distinct(case
                                        when m1.is_new = 0 then
                                         vid
                                      end)) as bqyf,
                       
                       decode(count(distinct(case
                                               when m1.is_new = 1 then
                                                vid
                                             end)),
                              0,
                              0,
                              trunc((count(distinct(case
                                                      when m1.is_new = 1 then
                                                       vid
                                                    end)) /
                                    (count(distinct(case
                                                       when m1.is_new = 0 then
                                                        vid
                                                     end)) +
                                    count(distinct(case
                                                       when m1.is_new = 1 then
                                                        vid
                                                     end)))),
                                    2)) as xsml,
                       
                       /* trunc((count(distinct(case
                                         when m1.is_new = 1 then
                                          vid
                                       end)) /
                       (count(distinct(case
                                          when m1.is_new = 0 then
                                           vid
                                        end)) +
                       count(distinct(case
                                          when m1.is_new = 1 then
                                           vid
                                        end)))),
                       2) as xsml,*/
                       count(distinct(case
                                        when exists (select *
                                                from fact_visitor_register m2
                                               where m2.create_date_key = var_array(i).date_key
                                                 and m2.vid = m1.vid
                                                 and m2.application_key in (10, 20)) then
                                         m1.vid
                                      end)) as appjh
                  from dim_vid_scan m1
                 where m1.scan_date_key = var_array(i).date_key) x3,
               
               (select var_array(i).date_key as stat_date_key,
                       sum(case
                             when exists (select *
                                     from dim_vid_scan w1
                                    where w1.scan_date_key = var_array(i).date_key
                                      and w1.ip = ccc.order_ip) and ccc.order_from = 76 then
                              ccc.order_amount
                           end) as wxyj,
                       count(case
                               when exists (select *
                                       from dim_vid_scan w1
                                      where w1.scan_date_key = var_array(i).date_key
                                        and w1.ip = ccc.order_ip) and ccc.order_from = 76 then
                                ccc.order_id
                             end) as wxdd,
                       
                       count(distinct(case
                                        when exists (select *
                                                from dim_vid_scan w1
                                               where w1.scan_date_key = var_array(i).date_key
                                                 and w1.ip = ccc.order_ip) and ccc.order_from = 76 then
                                         ccc.member_key
                                      end)) as wxrs,
                       
                       sum(case
                             when exists (select *
                                     from dim_vid_scan w1
                                    where w1.scan_date_key = var_array(i).date_key
                                      and w1.vid = ccc.vid) and ccc.order_from in (61, 63) then
                              ccc.order_amount
                           end) as appyj,
                       count(case
                               when exists (select *
                                       from dim_vid_scan w1
                                      where w1.scan_date_key = var_array(i).date_key
                                        and w1.vid = ccc.vid) and ccc.order_from in (61, 63) then
                                ccc.order_id
                             end) as appdd,
                       
                       count(distinct(case
                                        when exists (select *
                                                from dim_vid_scan w1
                                               where w1.scan_date_key = var_array(i).date_key
                                                 and w1.vid = ccc.vid) and ccc.order_from in (61, 63) then
                                         ccc.member_key
                                      end)) as apprs,
                       
                       sum(case
                             when exists (select *
                                     from dim_vid_scan w1
                                    where w1.scan_date_key = var_array(i).date_key
                                      and w1.vid = ccc.vid) then
                              ccc.order_amount
                           end) as smyj,
                       sum(ccc.order_amount) as zyj,
                       
                       decode(sum(case
                                    when exists (select *
                                            from dim_vid_scan w1
                                           where w1.scan_date_key = var_array(i).date_key
                                             and w1.vid = ccc.vid) then
                                     ccc.order_amount
                                  end),
                              0,
                              0,
                              trunc((sum(case
                                           when exists (select *
                                                   from dim_vid_scan w1
                                                  where w1.scan_date_key = var_array(i).date_key
                                                    and w1.vid = ccc.vid) then
                                            ccc.order_amount
                                         end) / sum(ccc.order_amount)),
                                    2)) as smzb
                
                /* trunc((sum(case
                       when exists (select *
                               from dim_vid_scan w1
                              where w1.scan_date_key = var_array(i).date_key
                                and w1.vid = ccc.vid) then
                        ccc.order_amount
                     end) / sum(ccc.order_amount)),
                2) as smzb*/
                  from factec_order ccc
                 where ccc.add_time = var_array(i).date_key
                   and ccc.order_state > 10) x4
         where x1.stat_date_key = x2.stat_date_key
           and x2.stat_date_key = x3.stat_date_key
           and x3.stat_date_key = x4.stat_date_key;
    
      commit;
    end loop;
  
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
end processcanmonth;
/

