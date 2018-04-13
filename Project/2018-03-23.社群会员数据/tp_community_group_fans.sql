CREATE TABLE `tp_community_group_fans` (
  `fans_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '索引主键',
  `group_id` int(11) NOT NULL COMMENT '所属分组',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `fans_img` varchar(200) DEFAULT NULL COMMENT '用户头像',
  `fans_ip` varchar(15) DEFAULT NULL COMMENT 'ip',
  `ec_cust_no` varchar(50) DEFAULT NULL COMMENT 'cust_no',
  `openid` varchar(200) DEFAULT NULL,
  `vid` varchar(100) DEFAULT NULL,
  `ec_member_id` int(11) DEFAULT NULL COMMENT 'ec对应会员id',
  `ec_member_name` varchar(100) DEFAULT NULL COMMENT 'ec对应名字',
  `audit_user` int(2) DEFAULT NULL COMMENT '审核人',
  `remark` varchar(200) DEFAULT NULL,
  `is_valid` int(2) NOT NULL DEFAULT '0' COMMENT '是否有效 1为无效   默认为0',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  `add_time` int(11) NOT NULL COMMENT '创建时间',
  `token` varchar(30) NOT NULL,
  PRIMARY KEY (`fans_id`)
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8;

create table tp_community_group_fans_tmp(
  fans_id number(11) NOT NULL,
  group_id number(11) NOT NULL,
  nickname varchar2(50) DEFAULT NULL ,
  fans_img varchar2(200) DEFAULT NULL,
  fans_ip varchar2(15) DEFAULT NULL ,
  ec_cust_no varchar2(50) DEFAULT NULL,
  openid varchar2(200) DEFAULT NULL,
  vid varchar2(100) DEFAULT NULL,
  ec_member_id number(11) DEFAULT NULL ,
  ec_member_name varchar2(100) DEFAULT NULL,
  audit_user number(2) DEFAULT NULL ,
  remark varchar2(200) DEFAULT NULL,
  is_valid number(2) NOT NULL ,
  update_time date DEFAULT NULL ,
  add_time date NOT NULL ,
  token varchar2(30) NOT NULL);
	
-- Create table
create table TP_COMMUNITY_GROUP_FANS
(
  fans_id        NUMBER(11) not null,
  group_id       NUMBER(11) not null,
  nickname       VARCHAR2(50),
  fans_img       VARCHAR2(200),
  fans_ip        VARCHAR2(15),
  ec_cust_no     VARCHAR2(50),
  openid         VARCHAR2(200),
  vid            VARCHAR2(100),
  ec_member_id   NUMBER(11),
  ec_member_name VARCHAR2(100),
  audit_user     NUMBER(2),
  remark         VARCHAR2(200),
  is_valid       NUMBER(2) not null,
  update_time    DATE,
  add_time       DATE not null,
  token          VARCHAR2(30) not null
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GROUP_FANS
  is '社群成员表-中间表
by yangjin
2018-03-26';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GROUP_FANS.fans_id
  is '索引主键';
comment on column TP_COMMUNITY_GROUP_FANS.group_id
  is '所属分组';
comment on column TP_COMMUNITY_GROUP_FANS.nickname
  is '昵称';
comment on column TP_COMMUNITY_GROUP_FANS.fans_img
  is '用户头像';
comment on column TP_COMMUNITY_GROUP_FANS.fans_ip
  is 'ip';
comment on column TP_COMMUNITY_GROUP_FANS.ec_cust_no
  is 'cust_no';
comment on column TP_COMMUNITY_GROUP_FANS.ec_member_id
  is 'ec对应会员id';
comment on column TP_COMMUNITY_GROUP_FANS.ec_member_name
  is 'ec对应名字';
comment on column TP_COMMUNITY_GROUP_FANS.audit_user
  is '审核人';
comment on column TP_COMMUNITY_GROUP_FANS.is_valid
  is '是否有效 1为无效   默认为0';
comment on column TP_COMMUNITY_GROUP_FANS.update_time
  is '更新时间';
comment on column TP_COMMUNITY_GROUP_FANS.add_time
  is '创建时间';
