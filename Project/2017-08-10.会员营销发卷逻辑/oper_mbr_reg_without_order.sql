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
  is '电商会员注册后无订购
by yangjin';
-- Add comments to the columns 
comment on column OPER_MBR_REG_WITHOUT_ORDER.member_key
  is '会员编号';
comment on column OPER_MBR_REG_WITHOUT_ORDER.register_date_key
  is '电商注册日期';
comment on column OPER_MBR_REG_WITHOUT_ORDER.thirty_without_order_flag
  is '未订购标志(0:7天未订购，1:15天未订购)';
comment on column OPER_MBR_REG_WITHOUT_ORDER.record_date_key
  is '记录日期';
comment on column OPER_MBR_REG_WITHOUT_ORDER.register_device_key
  is '注册最近一次的device_key';
comment on column OPER_MBR_REG_WITHOUT_ORDER.insert_dt
  is '插入时间';
comment on column OPER_MBR_REG_WITHOUT_ORDER.update_dt
  is '更新时间';
comment on column OPER_MBR_REG_WITHOUT_ORDER.processed
  is '已处理标志(0:未处理，1:已处理)';
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
