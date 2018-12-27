???create or replace procedure dw_user.processmama(startpoint in number,
                                               endpoint   in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processmama'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_mama'; --此处需要手工录入该PROCEDURE操作的表格
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

delete from  fact_daily_mama;
commit;

insert into fact_daily_mama
select  
172 as activityid,
'11.21-23感恩妈妈霜' as activityname,
v1.member_key,
(select v2.member_level from dim_member v2 where v2.member_bp=v1.member_key) as member_level,
v1.order_id,v1.erp_order_no,unix_to_oracle(v1.add_time_int) as  add_time
, v22.item_code,v22.goods_name,v22.goods_num,v22.goods_pay_price,
v1.voucher_price, 
(select w1.voucher_title from  fact_voucher w1  where w1.voucher_t_id=v1.voucher_ref and rownum=1) as vouchername

  from factec_order v1, factec_order_goods v22
 where v1.add_time between startpoint and endpoint
   and v1.order_state >= 20
   and v1.order_from not in ('995',
                             '993',
                             '990',
                             '806',
                             '805',
                             '804',
                             '803',
                             '802',
                             '801',
                             '800',
                             '76')
   and v1.order_id=v22.order_id
   and exists (select * from tmp_mama_good v3 where v3.item_code=v22.item_code)
   --and exists (select * from  fact_page_view v5 where v5.visit_date_key
  -- between startpoint and endpoint and  v5.page_name='KFZT' and v5.page_value='mamas1121'
  -- and   v5.vid=v1.vid
  -- )
   ;
   
   commit;

update  fact_daily_mama t set t.member_level='HAPP_T1' where t.member_level is null;
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
end processmama;
/

