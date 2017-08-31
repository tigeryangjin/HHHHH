-- Create table
create table OPER_MBR_ORDER_RETAIN_PUSH
(
  member_key          NUMBER(20),
  record_date_key     NUMBER(20),
  order_date_key      NUMBER(20),
  actual_order_amount NUMBER(10,2),
  order_frequency     NUMBER(5),
  amount_level        NUMBER(1),
  day_without_order   NUMBER(5),
  insert_dt           DATE,
  update_dt           DATE,
  processed           NUMBER(1) default 0
)
tablespace BDUDATAORDER
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table OPER_MBR_ORDER_RETAIN_PUSH
  is '��Ա��ȯ-��Ա����
by yangjin';
-- Add comments to the columns 
comment on column OPER_MBR_ORDER_RETAIN_PUSH.member_key
  is '��Ա���';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.record_date_key
  is '��¼����';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.order_date_key
  is '��������';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.actual_order_amount
  is 'ʵ�ʶ������';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.order_frequency
  is '��������';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.amount_level
  is '��Ч����1�Σ�15�������ظ�����,ʵ�ʶ������ȼ���1:100���£�2:100����300���£�3:300���ϣ�
��Ч����2�Σ�30�������ظ�����,ʵ�ʶ������ȼ���1:100~189��2:189~500��3:500����,-1:100���£�
��Ч����3�Σ�30�������ظ�����,ʵ�ʶ������ȼ���1:100~189��2:189~800��3:800����,-1:100���£�';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.day_without_order
  is 'δ��������';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.insert_dt
  is '����ʱ��';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.update_dt
  is '����ʱ��';
comment on column OPER_MBR_ORDER_RETAIN_PUSH.processed
  is '�Ѵ����־(0:δ����1:�Ѵ���)';
