CREATE TABLE fact_ec_voucher_price (
   voucher_price_id number(10) ,
   voucher_price_describe varchar2(800) ,
   voucher_price number(10) ,
   voucher_defaultpoints number(10) 
 ) ;
-- Add comments to the columns 
comment on column fact_ec_voucher_price.voucher_price_id
  is '����ȯ��ֵ���';
comment on column fact_ec_voucher_price.voucher_price_describe
  is '����ȯ����';
comment on column fact_ec_voucher_price.voucher_price
  is '����ȯ��ֵ';
comment on column fact_ec_voucher_price.voucher_defaultpoints
  is '������Ĭ�ϵĶһ�������ֿ���Ϊ0';
