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
  is '����ȯ���';
comment on column fact_ec_voucher.voucher_code
  is '����ȯ����';
comment on column fact_ec_voucher.voucher_t_id
  is '����ȯģ����';
comment on column fact_ec_voucher.voucher_title
  is '����ȯ����';
comment on column fact_ec_voucher.voucher_desc
  is '����ȯ����';
comment on column fact_ec_voucher.voucher_start_date
  is '����ȯ��Ч�ڿ�ʼʱ��';
comment on column fact_ec_voucher.voucher_end_date
  is '����ȯ��Ч�ڽ���ʱ��';
comment on column fact_ec_voucher.voucher_price
  is '����ȯ���';
comment on column fact_ec_voucher.voucher_limit
  is '����ȯʹ��ʱ�Ķ����޶�';
comment on column fact_ec_voucher.voucher_store_id
  is '����ȯ�ĵ���id';
comment on column fact_ec_voucher.voucher_state
  is '����ȯ״̬(1-δ��,2-����,3-����,4-�ջ�)';
comment on column fact_ec_voucher.voucher_active_date
  is '����ȯ��������';
comment on column fact_ec_voucher.voucher_type
  is '����ȯ���';
comment on column fact_ec_voucher.voucher_owner_id
  is '����ȯ������id';
comment on column fact_ec_voucher.voucher_owner_name
  is '����ȯ����������';
comment on column fact_ec_voucher.voucher_order_id
  is 'ʹ�øô���ȯ�Ķ�������ID';
comment on column fact_ec_voucher.voucher_add_ip
  is '��ȡʱ��IP';
comment on column fact_ec_voucher.voucher_add_vid
  is '��ȡʱ���豸���';
comment on column fact_ec_voucher.voucher_add_application
  is '��ȡ��Ӧ��';
comment on column fact_ec_voucher.coupon_tv_id
  is 'TVģ���Ż�ȯID��';
comment on column fact_ec_voucher.coupon_tv_code
  is 'TV�Ż�ȯȯ��';
comment on column fact_ec_voucher.voucher_remark
  is '����ȯ��ע';
