CREATE TABLE `tp_community_group_fans_apply` (
  `apply_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '索引主键',
  `group_id` int(11) NOT NULL COMMENT '所属分组',
  `nickname` varchar(50) DEFAULT NULL COMMENT '申请人名字',
  `fans_img` varchar(200) DEFAULT NULL COMMENT '头像',
  `fans_ip` varchar(15) DEFAULT NULL COMMENT 'ip',
  `ec_cust_no` varchar(50) DEFAULT NULL,
  `openid` varchar(200) DEFAULT NULL,
  `vid` varchar(100) DEFAULT NULL,
  `ec_member_id` int(11) DEFAULT NULL,
  `ec_member_name` varchar(100) DEFAULT NULL,
  `audit_status` int(2) DEFAULT '10' COMMENT '审核状态 10待审核 20 审核通过 30审核失败',
  `audit_user` int(2) DEFAULT NULL COMMENT '审核人',
  `audit_remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `audit_time` int(11) DEFAULT NULL COMMENT '审核时间',
  `add_time` int(11) NOT NULL COMMENT '创建时间',
  `token` varchar(30) NOT NULL,
  PRIMARY KEY (`apply_id`)
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8;

create table tp_community_group_fans_a_tmp(
  apply_id number(11) NOT NULL,
  group_id number(11) NOT NULL,
  nickname varchar2(50) DEFAULT NULL,
  fans_img varchar2(200) DEFAULT NULL,
  fans_ip varchar2(15) DEFAULT NULL,
  ec_cust_no varchar2(50) DEFAULT NULL,
  openid varchar2(200) DEFAULT NULL,
  vid varchar2(100) DEFAULT NULL,
  ec_member_id number(11) DEFAULT NULL,
  ec_member_name varchar2(100) DEFAULT NULL,
  audit_status number(2) ,
  audit_user number(10) DEFAULT NULL,
  audit_remark varchar2(500) DEFAULT NULL,
  audit_time number(11) DEFAULT NULL,
  add_time number(11) NOT NULL,
  token varchar2(30) NOT NULL);
	
-- Create table
create table TP_COMMUNITY_GROUP_FANS_A
(
  apply_id       NUMBER(11) not null,
  group_id       NUMBER(11) not null,
  nickname       VARCHAR2(50),
  fans_img       VARCHAR2(200),
  fans_ip        VARCHAR2(15),
  ec_cust_no     VARCHAR2(50),
  openid         VARCHAR2(200),
  vid            VARCHAR2(100),
  ec_member_id   NUMBER(11),
  ec_member_name VARCHAR2(100),
  audit_status   NUMBER(2),
  audit_user     NUMBER(10),
  audit_remark   VARCHAR2(500),
  audit_time     DATE,
  add_time       DATE not null,
  token          VARCHAR2(30) not null
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GROUP_FANS_A
  is '社群成员申请表
by yangjin
2018-03-26';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GROUP_FANS_A.apply_id
  is '索引主键';
comment on column TP_COMMUNITY_GROUP_FANS_A.group_id
  is '所属分组';
comment on column TP_COMMUNITY_GROUP_FANS_A.nickname
  is '申请人名字';
comment on column TP_COMMUNITY_GROUP_FANS_A.fans_img
  is '头像';
comment on column TP_COMMUNITY_GROUP_FANS_A.fans_ip
  is 'ip';
comment on column TP_COMMUNITY_GROUP_FANS_A.ec_cust_no
  is 'Cust_no';
comment on column TP_COMMUNITY_GROUP_FANS_A.vid
  is 'vid';
comment on column TP_COMMUNITY_GROUP_FANS_A.ec_member_id
  is 'Ec 会员id';
comment on column TP_COMMUNITY_GROUP_FANS_A.ec_member_name
  is 'Ec会员名';
comment on column TP_COMMUNITY_GROUP_FANS_A.audit_status
  is '审核状态 10待审核 20 审核通过 30审核失败';
comment on column TP_COMMUNITY_GROUP_FANS_A.audit_user
  is '审核人';
comment on column TP_COMMUNITY_GROUP_FANS_A.audit_remark
  is '备注';
comment on column TP_COMMUNITY_GROUP_FANS_A.audit_time
  is '审核时间';
comment on column TP_COMMUNITY_GROUP_FANS_A.add_time
  is '创建时间';
