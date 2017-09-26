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
comment on column fact_ec_order_2.order_id is '��������id';
comment on column fact_ec_order_2.order_sn is '�������';
comment on column fact_ec_order_2.pay_sn is '֧������';
comment on column fact_ec_order_2.store_id is '���ҵ���id';
comment on column fact_ec_order_2.store_name is '���ҵ�������';
comment on column fact_ec_order_2.cust_no is '�˿ͱ��';
comment on column fact_ec_order_2.member_level is '��Ա����';
comment on column fact_ec_order_2.buyer_id is '���id';
comment on column fact_ec_order_2.buyer_name is '�������';
comment on column fact_ec_order_2.buyer_email is '��ҵ�������';
comment on column fact_ec_order_2.add_time is '��������ʱ��';
comment on column fact_ec_order_2.payment_code is '֧����ʽ���ƴ���';
comment on column fact_ec_order_2.payment_time is '֧��(����)ʱ��';
comment on column fact_ec_order_2.finnshed_time is '�������ʱ��';
comment on column fact_ec_order_2.goods_amount is '��Ʒ�ܼ۸�';
comment on column fact_ec_order_2.order_amount is '�����ܼ۸�';
comment on column fact_ec_order_2.rcb_amount is '��ֵ��֧�����';
comment on column fact_ec_order_2.pd_amount is 'Ԥ���֧�����';
comment on column fact_ec_order_2.shipping_fee is '�˷�';
comment on column fact_ec_order_2.evaluation_state is '����״̬ 0δ���ۣ�1�����ۣ�2�ѹ���δ����';
comment on column fact_ec_order_2.order_state is '����״̬��0(��ȡ��)10(Ĭ��):δ����;20:�Ѹ���;30:�ѷ���;40:���ջ�����Ͷ��;50:��ȷ���ջ�;';
comment on column fact_ec_order_2.vbeln_no is 'CRM�Ľ�������';
comment on column fact_ec_order_2.refund_state is '�˿�״̬:0�����˿�,1�ǲ����˿�,2��ȫ���˿�';
comment on column fact_ec_order_2.lock_state is '����״̬:0������,����0������,Ĭ����0';
comment on column fact_ec_order_2.delete_state is 'ɾ��״̬0δɾ��1�������վ2����ɾ��';
comment on column fact_ec_order_2.refund_amount is '�˿���';
comment on column fact_ec_order_2.delay_time is '�ӳ�ʱ��,Ĭ��Ϊ0';
comment on column fact_ec_order_2.cps_u_id is '';
comment on column fact_ec_order_2.order_from is '�μ�CPS���VALUE1';
comment on column fact_ec_order_2.shipping_type is '0��ʾ��˾����   1��ʾ��ͨһ��  5��Ӧ������';
comment on column fact_ec_order_2.shipping_name is '������˾����';
comment on column fact_ec_order_2.shipping_code is '��������';
comment on column fact_ec_order_2.app_name is '�µ���ԴӦ����';
comment on column fact_ec_order_2.vid is '�µ��豸���';
comment on column fact_ec_order_2.expire_time is '��������ʱ��';
comment on column fact_ec_order_2.erp_order_no is 'ERP�������';
comment on column fact_ec_order_2.crm_order_no is 'CRM������';
comment on column fact_ec_order_2.erp_order_time is '����CRM����ʱ��';
comment on column fact_ec_order_2.erp_log is '�׵���Ϣ��¼';
comment on column fact_ec_order_2.erp_order_fail is '�׵�����';
comment on column fact_ec_order_2.audit_status is '���״̬ 0����� 1ͨ��  -1δͨ�� ';
comment on column fact_ec_order_2.audit_times is '���ʱ��';
comment on column fact_ec_order_2.audit_remark is '��˱�ע';
comment on column fact_ec_order_2.audit_admin_id is '�����id';
comment on column fact_ec_order_2.order_ip is '�µ�IP';
comment on column fact_ec_order_2.integrals_amount is '���ֵֿ۽��';
comment on column fact_ec_order_2.integrals_sum is 'ʹ�û�������';
comment on column fact_ec_order_2.discount_mansong_id is '���ܵ���������ID';
comment on column fact_ec_order_2.discount_mansong_amount is '���������ۿ۽��';
comment on column fact_ec_order_2.discount_paymentway_amount is '֧����ʽ�����ۿ�';
comment on column fact_ec_order_2.discount_paymentway_desc is '';
comment on column fact_ec_order_2.discount_paymentchanel_amount is '֧�����������ۿ�';
comment on column fact_ec_order_2.discount_paymentchanel_desc is '';
comment on column fact_ec_order_2.paymentchannel is '֧����������֧�����ֻ�:Alipay_M��֧������վAlipay_W��΢��_WX��';
comment on column fact_ec_order_2.follow_up_time is '������������ʱ��';
comment on column fact_ec_order_2.tuotou_memberid is '��Ͷ��';
comment on column fact_ec_order_2.reservation_delivery_at is 'ԤԼ����ʱ�䱸ע��ֱ�Ӽ�¼ʱ�䣬��վ��APPӦͳһ��';
comment on column fact_ec_order_2.order_type is '�������� 1:��ͨ������2��Ԥ��β�����Ĭ��1,3���Ź�����';
comment on column fact_ec_order_2.order_other_id is '�������ͻid';

