
CREATE TABLE fact_ec_order_common (
   order_id number(11) ,
   store_id number(10) ,
   shipping_time number(10),
   shipping_express_id number(1),
   evaluation_time number(10) ,
   evalseller_state number(1),
   evalseller_time number(10),
   order_message varchar2(1000),
   order_ponumberscount number(11),
   voucher_name varchar2(30),
   voucher_price number(11),
   voucher_desc varchar2(50),
   voucher_start_date number(10),
   voucher_end_date number(10),
   voucher_ref varchar2(32),
   dcissue_seq varchar2(32),
   voucher_code varchar2(32),
   deliver_explain varchar2(500),
   daddress_id varchar2(10),
   transpzone varchar2(10) ,
   reciver_name varchar2(50) ,
   reciver_info varchar2(500),
   reciver_province_id number(8),
   reciver_city_id number(8),
   invoice_info varchar2(500),
   promotion_info varchar2(500) ,
   dlyo_pickup_code varchar2(4),
   receiver_seq varchar2(10)
 );
 
 
-- Add comments to the columns 
comment on column fact_ec_order_common.order_id
  is '订单索引id';
comment on column fact_ec_order_common.store_id
  is '店铺ID';
comment on column fact_ec_order_common.shipping_time
  is '配送时间';
comment on column fact_ec_order_common.shipping_express_id
  is '配送公司ID';
comment on column fact_ec_order_common.evaluation_time
  is '评价时间';
comment on column fact_ec_order_common.evalseller_state
  is '卖家是否已评价买家';
comment on column fact_ec_order_common.evalseller_time
  is '卖家评价买家的时间';
comment on column fact_ec_order_common.order_message
  is '订单留言';
comment on column fact_ec_order_common.order_ponumberscount
  is '订单赠送积分';
comment on column fact_ec_order_common.voucher_name
  is '代金券名称';
comment on column fact_ec_order_common.voucher_price
  is '代金券面额';
comment on column fact_ec_order_common.voucher_desc
  is '代金券备注';
comment on column fact_ec_order_common.voucher_start_date
  is '券开始时间';	
comment on column fact_ec_order_common.voucher_end_date
  is '券失效时间';		
comment on column fact_ec_order_common.voucher_ref
  is 'EC的优惠券模板号';			
comment on column fact_ec_order_common.dcissue_seq
  is 'CRM中的优惠券号';		
comment on column fact_ec_order_common.voucher_code
  is '代金券编码';	
comment on column fact_ec_order_common.deliver_explain
  is '发货备注';		
comment on column fact_ec_order_common.daddress_id
  is '发货地址ID';		
comment on column fact_ec_order_common.transpzone
  is '四级地址编号';		
comment on column fact_ec_order_common.reciver_name
  is '收货人姓名';			
comment on column fact_ec_order_common.reciver_info
  is '收货人其它信息';	
comment on column fact_ec_order_common.reciver_province_id
  is '收货人省级ID';	
comment on column fact_ec_order_common.reciver_city_id
  is '收货人市级ID';
comment on column fact_ec_order_common.invoice_info
  is '发票信息';
comment on column fact_ec_order_common.promotion_info
  is '促销信息备注'	;
comment on column fact_ec_order_common.dlyo_pickup_code
  is '提货码'	;	
comment on column fact_ec_order_common.receiver_seq
  is '顾客地址编号'	;
	
