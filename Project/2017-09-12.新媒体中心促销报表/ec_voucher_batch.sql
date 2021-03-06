CREATE TABLE fact_ec_voucher_batch (
   id number(10) ,
   voucher_id varchar2(300) ,
   member_id varchar2(60),
   cust_no varchar2(60) ,
   state number(10) ,
   addtime number(10) ,
   remarks varchar2(600) ,
   voucher_key varchar2(300) ,
   out_sn varchar2(150) ,
   erp_order_no varchar2(150) ,
   send_type varchar2(60) 
 ) ;
-- Add comments to the columns 
comment on column fact_ec_voucher_batch.id
  is '自增ID';
comment on column fact_ec_voucher_batch.voucher_id
  is '优惠券ID';
comment on column fact_ec_voucher_batch.member_id
  is '用户ID';
comment on column fact_ec_voucher_batch.cust_no
  is 'bp号';
comment on column fact_ec_voucher_batch.state
  is '发放状态';
comment on column fact_ec_voucher_batch.addtime
  is '发放时间';
comment on column fact_ec_voucher_batch.remarks
  is '发放备注';
comment on column fact_ec_voucher_batch.out_sn
  is '外部业务单号';
comment on column fact_ec_voucher_batch.erp_order_no
  is 'ERP订单号';
comment on column fact_ec_voucher_batch.send_type
  is '活动类型';
comment on column fact_ec_voucher_batch.voucher_key
  is '';
