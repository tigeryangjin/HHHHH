
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
  is '��������id';
comment on column fact_ec_order_common.store_id
  is '����ID';
comment on column fact_ec_order_common.shipping_time
  is '����ʱ��';
comment on column fact_ec_order_common.shipping_express_id
  is '���͹�˾ID';
comment on column fact_ec_order_common.evaluation_time
  is '����ʱ��';
comment on column fact_ec_order_common.evalseller_state
  is '�����Ƿ����������';
comment on column fact_ec_order_common.evalseller_time
  is '����������ҵ�ʱ��';
comment on column fact_ec_order_common.order_message
  is '��������';
comment on column fact_ec_order_common.order_ponumberscount
  is '�������ͻ���';
comment on column fact_ec_order_common.voucher_name
  is '����ȯ����';
comment on column fact_ec_order_common.voucher_price
  is '����ȯ���';
comment on column fact_ec_order_common.voucher_desc
  is '����ȯ��ע';
comment on column fact_ec_order_common.voucher_start_date
  is 'ȯ��ʼʱ��';	
comment on column fact_ec_order_common.voucher_end_date
  is 'ȯʧЧʱ��';		
comment on column fact_ec_order_common.voucher_ref
  is 'EC���Ż�ȯģ���';			
comment on column fact_ec_order_common.dcissue_seq
  is 'CRM�е��Ż�ȯ��';		
comment on column fact_ec_order_common.voucher_code
  is '����ȯ����';	
comment on column fact_ec_order_common.deliver_explain
  is '������ע';		
comment on column fact_ec_order_common.daddress_id
  is '������ַID';		
comment on column fact_ec_order_common.transpzone
  is '�ļ���ַ���';		
comment on column fact_ec_order_common.reciver_name
  is '�ջ�������';			
comment on column fact_ec_order_common.reciver_info
  is '�ջ���������Ϣ';	
comment on column fact_ec_order_common.reciver_province_id
  is '�ջ���ʡ��ID';	
comment on column fact_ec_order_common.reciver_city_id
  is '�ջ����м�ID';
comment on column fact_ec_order_common.invoice_info
  is '��Ʊ��Ϣ';
comment on column fact_ec_order_common.promotion_info
  is '������Ϣ��ע'	;
comment on column fact_ec_order_common.dlyo_pickup_code
  is '�����'	;	
comment on column fact_ec_order_common.receiver_seq
  is '�˿͵�ַ���'	;
	
