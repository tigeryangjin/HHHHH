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
  is '����';
comment on column G_ACTIVITY.title
  is 'ר������';
comment on column G_ACTIVITY.share_title
  is '�������';
comment on column G_ACTIVITY.share_desc
  is '��������';
comment on column G_ACTIVITY.share_img
  is '����ͼƬ';
comment on column G_ACTIVITY.activity_name
  is '�����';
comment on column G_ACTIVITY.trace_page_name
  is '�û���Ϊͳ�Ʊ���';
comment on column G_ACTIVITY.create_time
  is '����ʱ��';
comment on column G_ACTIVITY.begin_time
  is '��ʼʱ��';
comment on column G_ACTIVITY.end_time
  is '�����ʱ��';
comment on column G_ACTIVITY.from_col
  is '���� 1:APP 2:Weixin 3:3g 0û�м�¼';
comment on column G_ACTIVITY.enable_col
  is '�Ƿ����� 1 ���� 0 ������';
comment on column G_ACTIVITY.author_id
  is '����Id';
comment on column G_ACTIVITY.w_insert_dt
  is '��¼����ʱ��';
comment on column G_ACTIVITY.w_update_dt
  is '��¼����ʱ��';
