--1.
-- Create table
create table TP_COMMUNITY_GAME_PLAY_R_TMP
(
  id                   NUMBER(11) not null,
  gameid               NUMBER(11),
  group_id             NUMBER(11),
  openid               VARCHAR2(250),
  ip                   VARCHAR2(255),
  member_crmbp         VARCHAR2(20),
  memberdisplayname    VARCHAR2(50),
  prizeid              NUMBER(11),
  prizename            VARCHAR2(100),
  prizetype            NUMBER(4),
  pointsreward         VARCHAR2(11),
  vouchercodereward    VARCHAR2(50),
  delivery_name        VARCHAR2(50),
  delivery_phonenumber VARCHAR2(11),
  delivery_address     VARCHAR2(255),
  put_status           NUMBER(1),
  audit_status         NUMBER(1),
  audit_admin          VARCHAR2(50),
  audit_time           DATE,
  remark               VARCHAR2(200),
  createtime           DATE
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GAME_PLAY_R_TMP
  is '�齱��¼��-�м��
by yangjin
2018-03-27';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.id
  is '����ID';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.gameid
  is '��Ϸ���';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.group_id
  is 'Ⱥ��';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.openid
  is 'openid';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.ip
  is 'ip';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.member_crmbp
  is '��ԱID';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.memberdisplayname
  is '��Ա��ʾ��';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.prizeid
  is '��ƷID';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.prizename
  is '��Ʒ����';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.prizetype
  is '0-����һ��;10-δ�н�;20-�Ż�ȯ;21-����;30-ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.pointsreward
  is '�����Ļ�������0��ʾ�����ͻ���';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.vouchercodereward
  is '�������Ż�ȯ�ţ��ձ�ʾ������ȯ';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.delivery_name
  is '�ջ���������������ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.delivery_phonenumber
  is '�ջ�����ϵ�绰��������ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.delivery_address
  is '�ջ�����ϸ��ַ��������ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.put_status
  is '����״̬��-1ʧ�ܣ�1�ɹ���0�����ţ�Ĭ�Ͽ�';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.audit_status
  is '���״̬��-1��ͨ����1���ͨ����0����ˣ�Ĭ�Ͽ�';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.audit_admin
  is '�����';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.audit_time
  is '���ʱ��';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.remark
  is '��ע';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.createtime
  is '�н�ʱ��';


--2.
-- Create table
create table TP_COMMUNITY_GAME_PLAY_R
(
  id                   NUMBER(11) not null,
  gameid               NUMBER(11),
  group_id             NUMBER(11),
  openid               VARCHAR2(250),
  ip                   VARCHAR2(255),
  member_crmbp         VARCHAR2(20),
  memberdisplayname    VARCHAR2(50),
  prizeid              NUMBER(11),
  prizename            VARCHAR2(100),
  prizetype            NUMBER(4),
  pointsreward         VARCHAR2(11),
  vouchercodereward    VARCHAR2(50),
  delivery_name        VARCHAR2(50),
  delivery_phonenumber VARCHAR2(11),
  delivery_address     VARCHAR2(255),
  put_status           NUMBER(1),
  audit_status         NUMBER(1),
  audit_admin          VARCHAR2(50),
  audit_time           DATE,
  remark               VARCHAR2(200),
  createtime           DATE
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GAME_PLAY_R
  is '�齱��¼��
by yangjin
2018-03-27';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GAME_PLAY_R.id
  is '����ID';
comment on column TP_COMMUNITY_GAME_PLAY_R.gameid
  is '��Ϸ���';
comment on column TP_COMMUNITY_GAME_PLAY_R.group_id
  is 'Ⱥ��';
comment on column TP_COMMUNITY_GAME_PLAY_R.openid
  is 'openid';
comment on column TP_COMMUNITY_GAME_PLAY_R.ip
  is 'ip';
comment on column TP_COMMUNITY_GAME_PLAY_R.member_crmbp
  is '��ԱID';
comment on column TP_COMMUNITY_GAME_PLAY_R.memberdisplayname
  is '��Ա��ʾ��';
comment on column TP_COMMUNITY_GAME_PLAY_R.prizeid
  is '��ƷID';
comment on column TP_COMMUNITY_GAME_PLAY_R.prizename
  is '��Ʒ����';
comment on column TP_COMMUNITY_GAME_PLAY_R.prizetype
  is '0-����һ��;10-δ�н�;20-�Ż�ȯ;21-����;30-ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PLAY_R.pointsreward
  is '�����Ļ�������0��ʾ�����ͻ���';
comment on column TP_COMMUNITY_GAME_PLAY_R.vouchercodereward
  is '�������Ż�ȯ�ţ��ձ�ʾ������ȯ';
comment on column TP_COMMUNITY_GAME_PLAY_R.delivery_name
  is '�ջ���������������ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PLAY_R.delivery_phonenumber
  is '�ջ�����ϵ�绰��������ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PLAY_R.delivery_address
  is '�ջ�����ϸ��ַ��������ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PLAY_R.put_status
  is '����״̬��-1ʧ�ܣ�1�ɹ���0�����ţ�Ĭ�Ͽ�';
comment on column TP_COMMUNITY_GAME_PLAY_R.audit_status
  is '���״̬��-1��ͨ����1���ͨ����0����ˣ�Ĭ�Ͽ�';
comment on column TP_COMMUNITY_GAME_PLAY_R.audit_admin
  is '�����';
comment on column TP_COMMUNITY_GAME_PLAY_R.audit_time
  is '���ʱ��';
comment on column TP_COMMUNITY_GAME_PLAY_R.remark
  is '��ע';
comment on column TP_COMMUNITY_GAME_PLAY_R.createtime
  is '�н�ʱ��';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TP_COMMUNITY_GAME_PLAY_R
  add constraint TP_COMMUNITY_GAME_PLAY_R_PK primary key (ID)
  using index 
  tablespace DWDATA00
  pctfree 10
  initrans 2
  maxtrans 255;

