--1.
CREATE TABLE `tp_community_fans_group_change_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `fans_id` int(11) NOT NULL COMMENT '��Աid',
  `old_group_id` int(11) NOT NULL COMMENT 'ԭ��Ⱥid',
  `group_id` int(11) NOT NULL COMMENT '�����Ⱥid',
  `remark` varchar(200) NOT NULL COMMENT '��ע',
  `admin_user` varchar(50) NOT NULL COMMENT '����Ա',
  `add_time` int(11) NOT NULL COMMENT '����ʱ��',
  `token` varchar(30) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--2.
create table tp_community_fans_g_c_l_tmp(
  log_id number(11) NOT NULL,
  fans_id number(11) NOT NULL,
  old_group_id number(11) NOT NULL,
  group_id number(11) NOT NULL,
  remark varchar2(200) NOT NULL,
  admin_user varchar2(50) NOT NULL,
  add_time date NOT NULL,
  token varchar2(30) NOT NULL);

--3.
-- Create table
create table TP_COMMUNITY_FANS_G_C_L
(
  log_id       NUMBER(11) not null,
  fans_id      NUMBER(11) not null,
  old_group_id NUMBER(11) not null,
  group_id     NUMBER(11) not null,
  remark       VARCHAR2(200) not null,
  admin_user   VARCHAR2(50) not null,
  add_time     DATE not null,
  token        VARCHAR2(30) not null
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_FANS_G_C_L
  is 'Ⱥ��Ա�����¼��
by yangjin
2018-03-26';
-- Add comments to the columns 
comment on column TP_COMMUNITY_FANS_G_C_L.log_id
  is '��������';
comment on column TP_COMMUNITY_FANS_G_C_L.fans_id
  is '��Աid';
comment on column TP_COMMUNITY_FANS_G_C_L.old_group_id
  is 'ԭ��Ⱥid';
comment on column TP_COMMUNITY_FANS_G_C_L.group_id
  is '�����Ⱥid';
comment on column TP_COMMUNITY_FANS_G_C_L.remark
  is '��ע';
comment on column TP_COMMUNITY_FANS_G_C_L.admin_user
  is '����Ա';
comment on column TP_COMMUNITY_FANS_G_C_L.add_time
  is '����ʱ��';
