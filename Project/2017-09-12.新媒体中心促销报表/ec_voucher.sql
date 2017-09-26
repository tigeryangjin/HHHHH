CREATE TABLE fact_ec_voucher (
   voucher_id number(10) ,
   voucher_code varchar2(100) ,
   voucher_t_id number(10) ,
   voucher_title varchar2(150) ,
   voucher_desc varchar2(800) ,
   voucher_start_date number(10) ,
   voucher_end_date number(10) ,
   voucher_price number(10) ,
   voucher_limit number(10,2) ,
   voucher_store_id number(10) ,
   voucher_state number(3) ,
   voucher_active_date number(10) ,
   voucher_type number(3) ,
   voucher_owner_id number(10) ,
   voucher_owner_name varchar2(150) ,
   voucher_order_id number(10) ,
   voucher_add_ip varchar2(60) ,
   voucher_add_vid varchar2(300) ,
   voucher_add_application varchar2(60) ,
   coupon_tv_id varchar2(60) ,
   coupon_tv_code varchar2(120) ,
   voucher_remark varchar2(600) 
 ) ;
-- Add comments to the columns 
comment on column fact_ec_voucher.voucher_id
  is '代金券编号';
comment on column fact_ec_voucher.voucher_code
  is '代金券编码';
comment on column fact_ec_voucher.voucher_t_id
  is '代金券模版编号';
comment on column fact_ec_voucher.voucher_title
  is '代金券标题';
comment on column fact_ec_voucher.voucher_desc
  is '代金券描述';
comment on column fact_ec_voucher.voucher_start_date
  is '代金券有效期开始时间';
comment on column fact_ec_voucher.voucher_end_date
  is '代金券有效期结束时间';
comment on column fact_ec_voucher.voucher_price
  is '代金券面额';
comment on column fact_ec_voucher.voucher_limit
  is '代金券使用时的订单限额';
comment on column fact_ec_voucher.voucher_store_id
  is '代金券的店铺id';
comment on column fact_ec_voucher.voucher_state
  is '代金券状态(1-未用,2-已用,3-过期,4-收回)';
comment on column fact_ec_voucher.voucher_active_date
  is '代金券发放日期';
comment on column fact_ec_voucher.voucher_type
  is '代金券类别';
comment on column fact_ec_voucher.voucher_owner_id
  is '代金券所有者id';
comment on column fact_ec_voucher.voucher_owner_name
  is '代金券所有者名称';
comment on column fact_ec_voucher.voucher_order_id
  is '使用该代金券的订单索引ID';
comment on column fact_ec_voucher.voucher_add_ip
  is '领取时的IP';
comment on column fact_ec_voucher.voucher_add_vid
  is '领取时的设备编号';
comment on column fact_ec_voucher.voucher_add_application
  is '领取的应用';
comment on column fact_ec_voucher.coupon_tv_id
  is 'TV模板优惠券ID号';
comment on column fact_ec_voucher.coupon_tv_code
  is 'TV优惠券券码';
comment on column fact_ec_voucher.voucher_remark
  is '代金券备注';
