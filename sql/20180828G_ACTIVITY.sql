-- Create table
create table G_ACTIVITY
(
  id_col          NUMBER(10),
  title           VARCHAR2(150),
  share_title     VARCHAR2(150),
  share_desc      VARCHAR2(450),
  share_img       VARCHAR2(600),
  activity_name   VARCHAR2(60),
  trace_page_name VARCHAR2(60),
  create_time     DATE,
  begin_time      DATE,
  end_time        DATE,
  from_col        VARCHAR2(30),
  enable_col      VARCHAR2(1),
  author_id       NUMBER(10),
  w_insert_dt     DATE,
  w_update_dt     DATE
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
comment on table G_ACTIVITY
  is 'source:G_ACTIVITY_TMP
by yangjin
2018-05-10';
-- Add comments to the columns 
comment on column G_ACTIVITY.id_col
  is '主键';
comment on column G_ACTIVITY.title
  is '专题名称';
comment on column G_ACTIVITY.share_title
  is '分享标题';
comment on column G_ACTIVITY.share_desc
  is '分享描述';
comment on column G_ACTIVITY.share_img
  is '分享图片';
comment on column G_ACTIVITY.activity_name
  is '活动名称';
comment on column G_ACTIVITY.trace_page_name
  is '用户行为统计编码';
comment on column G_ACTIVITY.create_time
  is '创建时间';
comment on column G_ACTIVITY.begin_time
  is '开始时间';
comment on column G_ACTIVITY.end_time
  is '活动结束时间';
comment on column G_ACTIVITY.from_col
  is '渠道 1:APP 2:Weixin 3:3g 0没有记录';
comment on column G_ACTIVITY.enable_col
  is '是否启用 1 启用 0 不启用';
comment on column G_ACTIVITY.author_id
  is '作者Id';
comment on column G_ACTIVITY.w_insert_dt
  is '记录插入时间';
comment on column G_ACTIVITY.w_update_dt
  is '记录更新时间';
