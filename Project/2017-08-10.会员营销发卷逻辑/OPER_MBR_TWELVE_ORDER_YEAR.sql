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
  is '订购过12次，自然年统计
by yangjin';
-- Add comments to the columns 
comment on column OPER_MBR_TWELVE_ORDER_YEAR.member_key
  is '会员编号';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.year_key
  is '自然年';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.order_count
  is '订单次数';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.actual_order_amount
  is '实际订购金额';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.profit_amount
  is '毛利额';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.amount_level
  is '实际订购金额等级（1:199~299，2:299~399，3:399以上）';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.insert_dt
  is '插入时间';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.update_dt
  is '更新时间';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.month_key
  is '执行月份';
comment on column OPER_MBR_TWELVE_ORDER_YEAR.processed
  is '已处理标志(0:未处理，1:已处理)';
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
