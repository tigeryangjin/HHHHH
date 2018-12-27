???create or replace procedure dw_user.processscancust(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processscancust'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_scan_cust'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_scan_cust
    (statdate,
     usertype,
     rs,
     je,
     ds,
     js,
     t0count,
     t1count,
     t2count,
     t3count,
     t4count,
     t5count,
     t6count
     
     )
  
    select startpoint as statdate,
           '新扫码用户' as usertype,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key = startpoint
                                     and v2.vid = v1.vid
                                     and v2.is_new = 1) then
                             v1.vid
                          end
                          
                          )) as rs,
           
           sum(case
                 when exists (select *
                         from dim_vid_scan v2
                        where v2.scan_date_key = startpoint
                          and v2.vid = v1.vid
                          and v2.is_new = 1) then
                  v1.order_amount
               end
               
               ) as je,
           
           count(case
                   when exists (select *
                           from dim_vid_scan v2
                          where v2.scan_date_key = startpoint
                            and v2.vid = v1.vid
                            and v2.is_new = 1) then
                    v1.order_id
                 end
                 
                 ) as ds,
           
           sum(case
                 when exists (select *
                         from dim_vid_scan v2
                        where v2.scan_date_key = startpoint
                          and v2.vid = v1.vid
                          and v2.is_new = 1) then
                  v1.goods_num
               end
               
               ) as js,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key = startpoint
                                     and v2.vid = v1.vid
                                     and v2.is_new = 1) and
                                 nvl(get_cust_level(v1.member_key), 0) = 0 then
                             v1.vid
                          end
                          
                          )) as t0count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key = startpoint
                                     and v2.vid = v1.vid
                                     and v2.is_new = 1) and
                                 nvl(get_cust_level(v1.member_key), 0) = 1 then
                             v1.vid
                          end
                          
                          )) as t1count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key = startpoint
                                     and v2.vid = v1.vid
                                     and v2.is_new = 1) and
                                 nvl(get_cust_level(v1.member_key), 0) = 2 then
                             v1.vid
                          end
                          
                          )) as t2count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key = startpoint
                                     and v2.vid = v1.vid
                                     and v2.is_new = 1) and
                                 nvl(get_cust_level(v1.member_key), 0) = 3 then
                             v1.vid
                          end
                          
                          )) as t3count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key = startpoint
                                     and v2.vid = v1.vid
                                     and v2.is_new = 1) and
                                 nvl(get_cust_level(v1.member_key), 0) = 4 then
                             v1.vid
                          end
                          
                          )) as t4count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key = startpoint
                                     and v2.vid = v1.vid
                                     and v2.is_new = 1) and
                                 nvl(get_cust_level(v1.member_key), 0) = 5 then
                             v1.vid
                          end
                          
                          )) as t5count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key = startpoint
                                     and v2.vid = v1.vid
                                     and v2.is_new = 1) and
                                 nvl(get_cust_level(v1.member_key), 0) = 6 then
                             v1.vid
                          end
                          
                          )) as t6count
    
      from factec_order v1
     where v1.add_time = startpoint
       and v1.order_state > 10
       and v1.order_from in (61, 63)
    
    union
    
    select startpoint as statdate,
           '扫码标签用户' as usertype,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key < startpoint
                                     and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                                     and v2.vid = v1.vid
                                     --and v2.is_new = 0
                                     ) then
                             v1.vid
                          end
                          
                          )) as rs,
           
           sum(case
                 when exists (select *
                         from dim_vid_scan v2
                        where v2.scan_date_key < startpoint
                        and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                          and v2.vid = v1.vid
                          --and v2.is_new = 0
                          ) then
                  v1.order_amount
               end
               
               ) as je,
           
           count(case
                   when exists (select *
                           from dim_vid_scan v2
                          where v2.scan_date_key < startpoint
                          and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                            and v2.vid = v1.vid
                            --and v2.is_new = 0
                            ) then
                    v1.order_id
                 end
                 
                 ) as ds,
           
           sum(case
                 when exists (select *
                         from dim_vid_scan v2
                        where v2.scan_date_key < startpoint
                        and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                          and v2.vid = v1.vid
                          --and v2.is_new = 0
                          ) then
                  v1.goods_num
               end
               
               ) as js,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key < startpoint
                                   and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                                     and v2.vid = v1.vid
                                     --and v2.is_new = 0
                                     ) and
                                 nvl(get_cust_level(v1.member_key), 0) = 0 then
                             v1.vid
                          end
                          
                          )) as t0count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key < startpoint
                                   and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                                     and v2.vid = v1.vid
                                     --and v2.is_new = 0
                                     ) and
                                 nvl(get_cust_level(v1.member_key), 0) = 1 then
                             v1.vid
                          end
                          
                          )) as t1count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key < startpoint
                                   and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                                     and v2.vid = v1.vid
                                     --and v2.is_new = 0
                                     ) and
                                 nvl(get_cust_level(v1.member_key), 0) = 2 then
                             v1.vid
                          end
                          
                          )) as t2count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key < startpoint
                                   and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                                     and v2.vid = v1.vid
                                     --and v2.is_new = 0
                                     ) and
                                 nvl(get_cust_level(v1.member_key), 0) = 3 then
                             v1.vid
                          end
                          
                          )) as t3count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key < startpoint
                                   and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                                     and v2.vid = v1.vid
                                     --and v2.is_new = 0
                                     ) and
                                 nvl(get_cust_level(v1.member_key), 0) = 4 then
                             v1.vid
                          end
                          
                          )) as t4count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key < startpoint
                                   and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                                     and v2.vid = v1.vid
                                     --and v2.is_new = 0
                                     ) and
                                 nvl(get_cust_level(v1.member_key), 0) = 5 then
                             v1.vid
                          end
                          
                          )) as t5count,
           
           count(distinct(case
                            when exists (select *
                                    from dim_vid_scan v2
                                   where v2.scan_date_key < startpoint
                                    and v2.scan_date_key>=to_number(to_char((sysdate-90),'yyyymmdd'))
                                     and v2.vid = v1.vid
                                     --and v2.is_new = 0
                                     ) and
                                 nvl(get_cust_level(v1.member_key), 0) = 6 then
                             v1.vid
                          end
                          
                          )) as t6count
    
      from factec_order v1
     where v1.add_time = startpoint
       and v1.order_state > 10
       and v1.order_from in (61, 63);

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
end processscancust;
/

