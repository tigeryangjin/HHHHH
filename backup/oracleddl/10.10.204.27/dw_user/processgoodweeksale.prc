???create or replace procedure dw_user.processgoodweeksale(startpoint  in varchar2,
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

  sp_name          := 'processgoodweeksale'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_week_goods_analysis'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_week_goods_analysis
    (weeknm,
     matdlt,
     item_code,
     goods_name,
     group_name,
     unit_price,
     bstatus,
     xinlao,
     totamount,
     totjs,
     totcount,
     totmem,
     tgamount,
     tgjs,
     tgcnt,
     tgmem,
     pcamount,
     pcjs,
     pccnt,
     pcmem,
     appamount,
     appjs,
     appcnt,
     appmem,
     wxamount,
     wxjs,
     wxcnt,
     wxmem)
    select startpoint || '年' || '第' ||
           endpoint || '周' ||
           startpoint_1 || '至' ||
           endpoint_1 as weeknm,
           (select cc1.matdlt
              from dim_good cc1
             where cc1.current_flg = 'Y'
               and cc1.item_code = cc.goods_common_key) as matdlt,
           (select cc1.item_code
              from dim_good cc1
             where cc1.current_flg = 'Y'
               and cc1.item_code = cc.goods_common_key) as item_code,
           (select cc1.goods_name
              from dim_good cc1
             where cc1.current_flg = 'Y'
               and cc1.item_code = cc.goods_common_key) as goods_name,
           (select cc1.group_name
              from dim_good cc1
             where cc1.current_flg = 'Y'
               and cc1.item_code = cc.goods_common_key) as group_name,
           cc.unit_price,
           case
             when cc.live_state = 0 and cc.replay_state = 0 then
              '未播出'
             else
              '播出'
           end as bstatus,
           case
             when not exists
              (select *
                     from dim_member cc2
                    where cc2.create_date_key <
                         startpoint_1
                      and cc2.member_bp = cc.member_key) then
              '新会员'
             else
              '老会员'
           end as xinlao,
           nvl(sum(cc.order_amount), 0) as totamount,
           nvl(sum(cc.nums), 0) as totjs,
           nvl(count(cc.order_key), 0) as totcount,
           nvl(count(distinct cc.member_key), 0) as totmem,
           
           nvl(sum(case
                     when cc.sales_source_second_key = 20022 then
                      cc.order_amount
                   end),
               0) as tgamount,
           nvl(sum(case
                     when cc.sales_source_second_key = 20022 then
                      cc.nums
                   end),
               0) as tgjs,
           nvl(count(case
                       when cc.sales_source_second_key = 20022 then
                        cc.order_key
                     end),
               0) as tgcnt,
           nvl(count(distinct(case
                                when cc.sales_source_second_key = 20022 then
                                 cc.member_key
                              end)),
               0) as tgmem,
           
           nvl(sum(case
                     when cc.sales_source_second_key = 20020 then
                      cc.order_amount
                   end),
               0) as pcamount,
           nvl(sum(case
                     when cc.sales_source_second_key = 20020 then
                      cc.nums
                   end),
               0) as pcjs,
           nvl(count(case
                       when cc.sales_source_second_key = 20020 then
                        cc.order_key
                     end),
               0) as pccnt,
           nvl(count(distinct(case
                                when cc.sales_source_second_key = 20020 then
                                 cc.member_key
                              end)),
               0) as pcmem,
           
           nvl(sum(case
                     when cc.sales_source_second_key = 20017 then
                      cc.order_amount
                   end),
               0) as appamount,
           nvl(sum(case
                     when cc.sales_source_second_key = 20017 then
                      cc.nums
                   end),
               0) as appjs,
           nvl(count(case
                       when cc.sales_source_second_key = 20017 then
                        cc.order_key
                     end),
               0) as appcnt,
           nvl(count(distinct(case
                                when cc.sales_source_second_key = 20017 then
                                 cc.member_key
                              end)),
               0) as appmem,
           
           nvl(sum(case
                     when cc.sales_source_second_key = 20021 then
                      cc.order_amount
                   end),
               0) as wxamount,
           nvl(sum(case
                     when cc.sales_source_second_key = 20021 then
                      cc.nums
                   end),
               0) as wxjs,
           nvl(count(case
                       when cc.sales_source_second_key = 20021 then
                        cc.order_key
                     end),
               0) as wxcnt,
           nvl(count(distinct(case
                                when cc.sales_source_second_key = 20021 then
                                 cc.member_key
                              end)),
               0) as wxmem
    
      from fact_goods_sales cc
     where cc.posting_date_key between
           startpoint_1 and
           endpoint_1
       and cc.tran_type = 0
       and cc.order_state = 1
     group by cc.goods_common_key,
              cc.unit_price,
              case
                when cc.live_state = 0 and cc.replay_state = 0 then
                 '未播出'
                else
                 '播出'
              end,
              case
                when not exists
                 (select *
                        from dim_member cc2
                       where cc2.create_date_key <
                             startpoint_1
                         and cc2.member_bp = cc.member_key) then
                 '新会员'
                else
                 '老会员'
              end,
              startpoint || '年' || '第' ||
              endpoint || '周' ||
              startpoint_1 || '至' ||
              endpoint_1;

  insert_rows := sql%rowcount;
  commit;

  delete from fact_week_goods_analysis y where y.item_code is null;

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
end processgoodweeksale;
/

