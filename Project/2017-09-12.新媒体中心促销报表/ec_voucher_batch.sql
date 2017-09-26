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
  is '����ID';
comment on column fact_ec_voucher_batch.voucher_id
  is '�Ż�ȯID';
comment on column fact_ec_voucher_batch.member_id
  is '�û�ID';
comment on column fact_ec_voucher_batch.cust_no
  is 'bp��';
comment on column fact_ec_voucher_batch.state
  is '����״̬';
comment on column fact_ec_voucher_batch.addtime
  is '����ʱ��';
comment on column fact_ec_voucher_batch.remarks
  is '���ű�ע';
comment on column fact_ec_voucher_batch.out_sn
  is '�ⲿҵ�񵥺�';
comment on column fact_ec_voucher_batch.erp_order_no
  is 'ERP������';
comment on column fact_ec_voucher_batch.send_type
  is '�����';
comment on column fact_ec_voucher_batch.voucher_key
  is '';
