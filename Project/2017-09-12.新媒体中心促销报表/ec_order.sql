CREATE TABLE fact_ec_order_2 (
   order_id number(10),
   order_sn number(20) ,
   pay_sn number(20) ,
   store_id number(10) ,
   store_name varchar2(150),
   cust_no varchar2(60),
   member_level varchar2(60),
   buyer_id number(10) ,
   buyer_name varchar2(150),
   buyer_email varchar2(240),
   add_time number(10) ,
   payment_code varchar2(10),
   payment_time number(10) ,
   finnshed_time number(10) ,
   goods_amount number(10,2) ,
   order_amount number(10,2) ,
   rcb_amount number(10,2) ,
   pd_amount number(10,2) ,
   shipping_fee number(10,2) ,
   evaluation_state number(4),
   order_state number(4),
   vbeln_no varchar2(60),
   refund_state number(4) ,
   lock_state number(4) ,
   delete_state number(4),
   refund_amount number(10,2),
   delay_time number(10) ,
   cps_u_id varchar2(300),
   order_from varchar2(30),
   shipping_type number(4),
   shipping_name varchar2(150),
   shipping_code varchar2(150),
   app_name varchar2(60),
   vid varchar2(300),
   expire_time number(10),
   erp_order_no number(15),
   crm_order_no number(15),
   erp_order_time number(10),
   erp_log varchar2(300),
   erp_order_fail number(8),
   audit_status number(4),
   audit_times number(10),
   audit_remark varchar2(1500),
   audit_admin_id number(10),
   order_ip varchar2(600),
   integrals_amount number(10,2),
   integrals_sum number(10),
   discount_mansong_id number(10),
   discount_mansong_amount number(10,2),
   discount_paymentway_amount number(10,2),
   discount_paymentway_desc varchar2(300),
   discount_paymentchanel_amount number(10,2),
   discount_paymentchanel_desc varchar2(300),
   paymentchannel varchar2(60),
   follow_up_time number(10),
   tuotou_memberid varchar2(30),
   reservation_delivery_at varchar2(60),
   order_type number(4),
   order_other_id number(10)
 ) ;
-- Add comments to the columns 
comment on column fact_ec_order_2.order_id is '订单索引id';
comment on column fact_ec_order_2.order_sn is '订单编号';
comment on column fact_ec_order_2.pay_sn is '支付单号';
comment on column fact_ec_order_2.store_id is '卖家店铺id';
comment on column fact_ec_order_2.store_name is '卖家店铺名称';
comment on column fact_ec_order_2.cust_no is '顾客编号';
comment on column fact_ec_order_2.member_level is '会员级别';
comment on column fact_ec_order_2.buyer_id is '买家id';
comment on column fact_ec_order_2.buyer_name is '买家姓名';
comment on column fact_ec_order_2.buyer_email is '买家电子邮箱';
comment on column fact_ec_order_2.add_time is '订单生成时间';
comment on column fact_ec_order_2.payment_code is '支付方式名称代码';
comment on column fact_ec_order_2.payment_time is '支付(付款)时间';
comment on column fact_ec_order_2.finnshed_time is '订单完成时间';
comment on column fact_ec_order_2.goods_amount is '商品总价格';
comment on column fact_ec_order_2.order_amount is '订单总价格';
comment on column fact_ec_order_2.rcb_amount is '充值卡支付金额';
comment on column fact_ec_order_2.pd_amount is '预存款支付金额';
comment on column fact_ec_order_2.shipping_fee is '运费';
comment on column fact_ec_order_2.evaluation_state is '评价状态 0未评价，1已评价，2已过期未评价';
comment on column fact_ec_order_2.order_state is '订单状态：0(已取消)10(默认):未付款;20:已付款;30:已发货;40:已收货（妥投）;50:已确认收货;';
comment on column fact_ec_order_2.vbeln_no is 'CRM的交货单号';
comment on column fact_ec_order_2.refund_state is '退款状态:0是无退款,1是部分退款,2是全部退款';
comment on column fact_ec_order_2.lock_state is '锁定状态:0是正常,大于0是锁定,默认是0';
comment on column fact_ec_order_2.delete_state is '删除状态0未删除1放入回收站2彻底删除';
comment on column fact_ec_order_2.refund_amount is '退款金额';
comment on column fact_ec_order_2.delay_time is '延迟时间,默认为0';
comment on column fact_ec_order_2.cps_u_id is '';
comment on column fact_ec_order_2.order_from is '参见CPS码表VALUE1';
comment on column fact_ec_order_2.shipping_type is '0表示公司物流   1表示四通一达  5供应商配送';
comment on column fact_ec_order_2.shipping_name is '物流公司名称';
comment on column fact_ec_order_2.shipping_code is '物流单号';
comment on column fact_ec_order_2.app_name is '下单来源应用名';
comment on column fact_ec_order_2.vid is '下单设备编号';
comment on column fact_ec_order_2.expire_time is '订单过期时间';
comment on column fact_ec_order_2.erp_order_no is 'ERP订单编号';
comment on column fact_ec_order_2.crm_order_no is 'CRM订单号';
comment on column fact_ec_order_2.erp_order_time is '生成CRM订单时间';
comment on column fact_ec_order_2.erp_log is '抛单信息记录';
comment on column fact_ec_order_2.erp_order_fail is '抛单次数';
comment on column fact_ec_order_2.audit_status is '审核状态 0待审核 1通过  -1未通过 ';
comment on column fact_ec_order_2.audit_times is '审核时间';
comment on column fact_ec_order_2.audit_remark is '审核备注';
comment on column fact_ec_order_2.audit_admin_id is '审核人id';
comment on column fact_ec_order_2.order_ip is '下单IP';
comment on column fact_ec_order_2.integrals_amount is '积分抵扣金额';
comment on column fact_ec_order_2.integrals_sum is '使用积分数量';
comment on column fact_ec_order_2.discount_mansong_id is '享受的满减促销ID';
comment on column fact_ec_order_2.discount_mansong_amount is '订单满减折扣金额';
comment on column fact_ec_order_2.discount_paymentway_amount is '支付方式享受折扣';
comment on column fact_ec_order_2.discount_paymentway_desc is '';
comment on column fact_ec_order_2.discount_paymentchanel_amount is '支付渠道享受折扣';
comment on column fact_ec_order_2.discount_paymentchanel_desc is '';
comment on column fact_ec_order_2.paymentchannel is '支付渠道，（支付宝手机:Alipay_M，支付宝网站Alipay_W，微信_WX）';
comment on column fact_ec_order_2.follow_up_time is '订单后续更新时间';
comment on column fact_ec_order_2.tuotou_memberid is '妥投人';
comment on column fact_ec_order_2.reservation_delivery_at is '预约发货时间备注（直接记录时间，网站与APP应统一）';
comment on column fact_ec_order_2.order_type is '订单类型 1:普通订单，2：预售尾款订单，默认1,3：团购订单';
comment on column fact_ec_order_2.order_other_id is '订单类型活动id';

