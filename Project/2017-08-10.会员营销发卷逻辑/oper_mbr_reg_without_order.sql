-- Create table
create table OPER_MBR_REG_WITHOUT_ORDER
(
  member_key                NUMBER(20),
  register_date_key         NUMBER(20),
  thirty_without_order_flag NUMBER(1),
  record_date_key           NUMBER(20),
  register_device_key       NUMBER(20),
  insert_dt                 DATE,
  update_dt                 DATE,
  processed                 NUMBER(1) default 0
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
comment on table OPER_MBR_REG_WITHOUT_ORDER
  is '���̻�Աע����޶���
by yangjin';
-- Add comments to the columns 
comment on column OPER_MBR_REG_WITHOUT_ORDER.member_key
  is '��Ա���';
comment on column OPER_MBR_REG_WITHOUT_ORDER.register_date_key
  is '����ע������';
comment on column OPER_MBR_REG_WITHOUT_ORDER.thirty_without_order_flag
  is 'δ������־(0:7��δ������1:15��δ����)';
comment on column OPER_MBR_REG_WITHOUT_ORDER.record_date_key
  is '��¼����';
comment on column OPER_MBR_REG_WITHOUT_ORDER.register_device_key
  is 'ע�����һ�ε�device_key';
comment on column OPER_MBR_REG_WITHOUT_ORDER.insert_dt
  is '����ʱ��';
comment on column OPER_MBR_REG_WITHOUT_ORDER.update_dt
  is '����ʱ��';
comment on column OPER_MBR_REG_WITHOUT_ORDER.processed
  is '�Ѵ����־(0:δ����1:�Ѵ���)';
-- Create/Recreate indexes 
create index OPERMR_MEMBER_KEY on OPER_MBR_REG_WITHOUT_ORDER (MEMBER_KEY)
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
