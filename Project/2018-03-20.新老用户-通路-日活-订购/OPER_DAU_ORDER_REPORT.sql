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
  is '新老用户日活订购日报
by yangjin
2018-03-16';
-- Add comments to the columns 
comment on column OPER_DAU_ORDER_REPORT.date_key
  is '日期';
comment on column OPER_DAU_ORDER_REPORT.is_new_user
  is '新老客
';
comment on column OPER_DAU_ORDER_REPORT.is_scan
  is '扫码用户';
comment on column OPER_DAU_ORDER_REPORT.channel_name
  is '通路业务分类';
comment on column OPER_DAU_ORDER_REPORT.dau
  is '日活
';
comment on column OPER_DAU_ORDER_REPORT.order_member_count
  is '订购人数';
comment on column OPER_DAU_ORDER_REPORT.order_amount
  is '订购金额';
comment on column OPER_DAU_ORDER_REPORT.order_qty
  is '订购件数
';
comment on column OPER_DAU_ORDER_REPORT.order_count
  is '订购单数
';
