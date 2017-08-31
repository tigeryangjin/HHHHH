-- Create table
create table OPER_MBR_TWELVE_ORDER_YEAR
(
  member_key          NUMBER(20),
  year_key            NUMBER(20),
  order_count         NUMBER(4),
  actual_order_amount NUMBER(10,2),
  profit_amount       NUMBER(10,2),
  amount_level        NUMBER(1),
  insert_dt           DATE,
  update_dt           DATE,
  month_key           NUMBER(20),
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
comment on table OPER_MBR_TWELVE_ORDER_YEAR
  is '������12�Σ���Ȼ��ͳ��
by yangjin';
-- Add comments to the columns 
comment on column OPER_MBR_TWELVE_ORDER_YEAR.member_key
  is '��Ա���';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.year_key
  is '��Ȼ��';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.order_count
  is '��������';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.actual_order_amount
  is 'ʵ�ʶ������';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.profit_amount
  is 'ë����';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.amount_level
  is 'ʵ�ʶ������ȼ���1:199~299��2:299~399��3:399���ϣ�';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.insert_dt
  is '����ʱ��';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.update_dt
  is '����ʱ��';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.month_key
  is 'ִ���·�';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.processed
  is '�Ѵ����־(0:δ����1:�Ѵ���)';
-- Create/Recreate indexes 
create index OPERMOF_MEMBER_KEY4 on OPER_MBR_TWELVE_ORDER_YEAR (YEAR_KEY)
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
