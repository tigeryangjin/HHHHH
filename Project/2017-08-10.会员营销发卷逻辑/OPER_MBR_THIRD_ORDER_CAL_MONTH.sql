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
  is '订购过三次，自然月统计
by yangjin';
-- Add comments to the columns 
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.member_key
  is '会员编号';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.month_key
  is '月份';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.order_count
  is '订单次数';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.actual_order_amount
  is '实际订购金额';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.profit_amount
  is '毛利额';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.amount_level
  is '实际订购金额等级（1:199~299，2:299~399，3:399以上）';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.insert_dt
  is '插入时间';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.update_dt
  is '更新时间';
comment on column OPER_MBR_THIRD_ORDER_CAL_MONTH.processed
  is '已处理标志(0:未处理，1:已处理)';
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
