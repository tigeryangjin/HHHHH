-- Create table
create table OPER_DAU_ORDER_REPORT
(
  date_key           NUMBER(10),
  is_new_user        VARCHAR2(8),
  is_scan            VARCHAR2(8),
  channel_name       VARCHAR2(6),
  dau                NUMBER(10,2),
  order_member_count NUMBER(10,2),
  order_amount       NUMBER(10,2),
  order_qty          NUMBER(10,2),
  order_count        NUMBER(10,2)
)
tablespace DWDATA00
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
comment on table OPER_DAU_ORDER_REPORT
  is '�����û��ջ���ձ�
by yangjin
2018-03-16';
-- Add comments to the columns 
comment on column OPER_DAU_ORDER_REPORT.date_key
  is '����';
comment on column OPER_DAU_ORDER_REPORT.is_new_user
  is '���Ͽ�
';
comment on column OPER_DAU_ORDER_REPORT.is_scan
  is 'ɨ���û�';
comment on column OPER_DAU_ORDER_REPORT.channel_name
  is 'ͨ·ҵ�����';
comment on column OPER_DAU_ORDER_REPORT.dau
  is '�ջ�
';
comment on column OPER_DAU_ORDER_REPORT.order_member_count
  is '��������';
comment on column OPER_DAU_ORDER_REPORT.order_amount
  is '�������';
comment on column OPER_DAU_ORDER_REPORT.order_qty
  is '��������
';
comment on column OPER_DAU_ORDER_REPORT.order_count
  is '��������
';
