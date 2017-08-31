-- Create table
create table OPER_MBR_THIRD_ORDER_CAL_MONTH
(
  member_key          NUMBER(20),
  month_key           NUMBER(20),
  order_count         NUMBER(4),
  actual_order_amount NUMBER(10,2),
  profit_amount       NUMBER(10,2),
  amount_level        NUMBER(1),
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
comment on table OPER_MBR_THIRD_ORDER_CAL_MONTH
  is '���������Σ���Ȼ��ͳ��
by yangjin';
-- Add comments to the columns 
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.member_key
  is '��Ա���';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.month_key
  is '�·�';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.order_count
  is '��������';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.actual_order_amount
  is 'ʵ�ʶ������';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.profit_amount
  is 'ë����';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.amount_level
  is 'ʵ�ʶ������ȼ���1:199~299��2:299~399��3:399���ϣ�';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.insert_dt
  is '����ʱ��';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.update_dt
  is '����ʱ��';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.processed
  is '�Ѵ����־(0:δ����1:�Ѵ���)';
-- Create/Recreate indexes 
create index OPERMOF_MEMBER_KEY3 on OPER_MBR_THIRD_ORDER_CAL_MONTH (MONTH_KEY)
  tablespace BDUDATAORDER
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
