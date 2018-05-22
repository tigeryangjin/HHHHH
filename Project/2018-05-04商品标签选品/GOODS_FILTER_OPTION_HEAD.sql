-- Create table
create table GOODS_FILTER_OPTION_HEAD
(
  filter_id            NUMBER(10) not null,
  filter_name          VARCHAR2(200),
  goods_label_id_set  VARCHAR2(2000),
  create_time          DATE,
  create_user          VARCHAR2(20),
  last_update_time     DATE,
  last_update_user     VARCHAR2(20),
  status               NUMBER(1),
  execution_start_time DATE,
  execution_end_time   DATE,
  result_records       NUMBER(10),
  result_message       VARCHAR2(500),
  output_file_path     VARCHAR2(200),
  json_goods_label    VARCHAR2(2000)
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
comment on table GOODS_FILTER_OPTION_HEAD
  is '商品筛选操作主表
by yangjin
2018-05-07';
-- Add comments to the columns 
comment on column GOODS_FILTER_OPTION_HEAD.filter_id
  is '筛选ID，seq';
comment on column GOODS_FILTER_OPTION_HEAD.filter_name
  is '筛选名称';
comment on column GOODS_FILTER_OPTION_HEAD.goods_label_id_set
  is '商品标签集合逻辑操作';
comment on column GOODS_FILTER_OPTION_HEAD.create_time
  is '筛选创建时间';
comment on column GOODS_FILTER_OPTION_HEAD.create_user
  is '筛选创建人';
comment on column GOODS_FILTER_OPTION_HEAD.last_update_time
  is '最后更新时间';
comment on column GOODS_FILTER_OPTION_HEAD.last_update_user
  is '最后更新人';
comment on column GOODS_FILTER_OPTION_HEAD.status
  is '状态(-1:待审核，0:未运行，1:正在运行中，2:运行成功，9:运行失败，-2:已删除)';
comment on column GOODS_FILTER_OPTION_HEAD.execution_start_time
  is '执行开始时间';
comment on column GOODS_FILTER_OPTION_HEAD.execution_end_time
  is '执行结束时间';
comment on column GOODS_FILTER_OPTION_HEAD.result_records
  is '筛选出的会员记录数';
comment on column GOODS_FILTER_OPTION_HEAD.result_message
  is '返回信息(成功：SUCCESS,如果报错则存报错信息)';
comment on column GOODS_FILTER_OPTION_HEAD.output_file_path
  is '导出文件路径';
comment on column GOODS_FILTER_OPTION_HEAD.json_goods_label
  is 'JSON商品标签';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GOODS_FILTER_OPTION_HEAD
  add constraint GOODS_FILTER_OPTION_HEAD_PK primary key (FILTER_ID)
  using index 
  tablespace DWDATA00
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
