???create or replace procedure dw_user.process_store_daily (startpoint  in varchar2,
                                                endpoint    in varchar2,
                                                insertpoint in number)
 is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
 -- startpoint  varchar(50);
 -- endpoint    varchar(50);
  /* 
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'process_store_daily'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_store'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
 -- startpoint       := '20180309';
 -- endpoint         := '20180315';
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  insert into fact_daily_store
  
    select w_store_d_s.nextval,
           li.store_id,
           li.store_company_name,
           li.store_name,
           li.brand_name,
           li.store_type,
           li.store_time,
           li.store_state,
           li.sc_name,
           li.hbp_store_id,
           li.contacts_name,
           li.contacts_phone,
           li.totstorage,
           li.xsjstorage,
           li.totsjstorage,
           li.yxamount,
           li.bzamount,
           li.insert_date_key,
           li.totamount,
           li.bztotamount,
           li.yxjs,
           li.bzyxjs,
           li.totjs,
           li.bztotjs
    
      from (select xx.store_id,
                   xx.store_company_name,
                   xx.store_name,
                   nvl((select zz.brand_name
                         from dim_ec_good zz
                        where zz.store_id = xx.store_id
                          and rownum = 1),
                       '未知') as brand_name,
                   xx.store_type,
                   xx.store_time,
                   xx.store_state,
                   xx.sc_name,
                   xx.hbp_store_id,
                   xx.contacts_name,
                   xx.contacts_phone,
                   xx.totstorage,
                   xx.xsjstorage,
                   xx.totsjstorage,
                   nvl(yy.yxamount, 0) as yxamount,
                   nvl(yy.bzamount, 0) as bzamount,
                   insertpoint as insert_date_key,
                   nvl(yy.totamount, 0) as totamount,
                   nvl(yy.bztotamount, 0) as bztotamount， nvl(yy.yxjs, 0) as yxjs,
                   nvl(yy.bzyxjs, 0) as bzyxjs,
                   nvl(yy.totjs, 0) as totjs,
                   nvl(yy.bztotjs, 0) as bztotjs
            
              from (select m1.store_id,
                           m1.store_company_name,
                           m1.store_name,
                           m1.store_type,
                           m1.store_time,
                           m1.store_state,
                           m1.sc_name,
                           m1.hbp_store_id,
                           m1.contacts_name,
                           m1.contacts_phone,
                           nvl(count(distinct m2.item_code), 0) as totstorage,
                           nvl(count(distinct(case
                                                when exists
                                                 (select distinct w1.item_code
                                                        from fact_daily_goodzaijia w1
                                                       where to_char(w1.goods_addtime, 'yyyymmdd') between
                                                             startpoint and endpoint
                                                         and w1.item_code = m2.item_code) then
                                                 m2.item_code
                                              end)),
                               0) as xsjstorage,
                           nvl(count(distinct(case
                                                when exists
                                                 (select distinct w1.item_code
                                                        from fact_daily_goodzaijia w1
                                                       where w1.create_date_key between startpoint and
                                                             endpoint
                                                         and w1.item_code = m2.item_code) then
                                                 m2.item_code
                                              end)),
                               0) as totsjstorage
                      from dim_ec_store m1,
                           (select *
                              from dim_ec_good kk
                             where kk.store_id != 1) m2
                     where m1.store_id = m2.store_id
                     group by m1.store_id,
                              m1.store_company_name,
                              m1.store_name,
                              m1.store_type,
                              m1.store_time,
                              m1.store_state,
                              m1.sc_name,
                              m1.hbp_store_id,
                              m1.contacts_name,
                              m1.contacts_phone) xx,
                   (select j2.store_id,
                           nvl(sum(case
                                     when exists (select *
                                             from fact_ec_order j20
                                            where j20.order_id = j1.order_id
                                              and j20.is_kjg = j1.is_kjg
                                              and j20.order_state >= 20) then
                                      j1.goods_pay_price
                                   end),
                               0) as yxamount,
                           nvl(sum(case
                                     when exists (select *
                                             from fact_ec_order j20
                                            where j20.order_id = j1.order_id
                                              and j20.is_kjg = j1.is_kjg
                                              and j20.order_state >= 20) and
                                          to_char(j1.createtime, 'yyyymmdd') between
                                          startpoint and endpoint then
                                      j1.goods_pay_price
                                   end),
                               0) as bzamount,
                           
                           nvl(sum(case
                                     when exists (select *
                                             from fact_ec_order j20
                                            where j20.order_id = j1.order_id
                                              and j20.is_kjg = j1.is_kjg) then
                                      j1.goods_pay_price
                                   end),
                               0) as totamount,
                           nvl(sum(case
                                     when exists (select *
                                             from fact_ec_order j20
                                            where j20.order_id = j1.order_id
                                              and j20.is_kjg = j1.is_kjg) and
                                          to_char(j1.createtime, 'yyyymmdd') between
                                          startpoint and endpoint then
                                      j1.goods_pay_price
                                   end),
                               0) as bztotamount,
                           
                           nvl(count(case
                                       when exists (select *
                                               from fact_ec_order j20
                                              where j20.order_id = j1.order_id
                                                and j20.is_kjg = j1.is_kjg
                                                and j20.order_state >= 20) then
                                        1
                                     end),
                               0) as yxjs,
                           nvl(count(case
                                       when exists (select *
                                               from fact_ec_order j20
                                              where j20.order_id = j1.order_id
                                                and j20.is_kjg = j1.is_kjg
                                                and j20.order_state >= 20) and
                                            to_char(j1.createtime, 'yyyymmdd') between
                                            startpoint and endpoint then
                                        1
                                     end),
                               0) as bzyxjs,
                           
                           nvl(count(case
                                       when exists (select *
                                               from fact_ec_order j20
                                              where j20.order_id = j1.order_id
                                                and j20.is_kjg = j1.is_kjg) then
                                        1
                                     end),
                               0) as totjs,
                           nvl(count(case
                                       when exists (select *
                                               from fact_ec_order j20
                                              where j20.order_id = j1.order_id
                                                and j20.is_kjg = j1.is_kjg) and
                                            to_char(j1.createtime, 'yyyymmdd') between
                                            startpoint and endpoint then
                                        1
                                     end),
                               0) as bztotjs
                    
                      from fact_ec_ordergoods j1,
                           (select *
                              from dim_ec_good ll
                             where ll.store_id != 1) j2
                     where j1.goods_commonid = j2.goods_commonid
                     group by j2.store_id) yy
             where xx.store_id = yy.store_id(+)) li;

  insert_rows := sql%rowcount;
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
end process_store_daily;
/

