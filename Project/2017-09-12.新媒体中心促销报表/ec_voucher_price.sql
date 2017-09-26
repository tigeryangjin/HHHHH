CREATE TABLE fact_ec_voucher_price (
   voucher_price_id number(10) ,
   voucher_price_describe varchar2(800) ,
   voucher_price number(10) ,
   voucher_defaultpoints number(10) 
 ) ;
-- Add comments to the columns 
comment on column fact_ec_voucher_price.voucher_price_id
  is '代金券面值编号';
comment on column fact_ec_voucher_price.voucher_price_describe
  is '代金券描述';
comment on column fact_ec_voucher_price.voucher_price
  is '代金券面值';
comment on column fact_ec_voucher_price.voucher_defaultpoints
  is '代金劵默认的兑换所需积分可以为0';
