CREATE TABLE `tp_community_group` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '索引主键',
  `group_no` varchar(11) NOT NULL COMMENT '群号 （随机字符串 8位小写字母）',
  `group_name` varchar(50) NOT NULL COMMENT '组名',
  `group_admin` varchar(50) DEFAULT NULL COMMENT '组管理人',
  `add_time` int(11) DEFAULT NULL COMMENT '添加时间',
  `token` varchar(30) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


create table tp_community_group_tmp (
  group_id number(11) NOT NULL ,
  group_no varchar2(11) NOT NULL ,
  group_name varchar2(50) NOT NULL ,
  group_admin varchar2(50) DEFAULT NULL ,
  add_time number(11) DEFAULT NULL ,
  token varchar2(30) NOT NULL,
  remark varchar2(255) DEFAULT NULL,
  create_time number(11) NOT NULL );
	

-- Create table
create table TP_COMMUNITY_GROUP
(
  group_id    NUMBER(11) not null,
  group_no    VARCHAR2(11) not null,
  group_name  VARCHAR2(50) not null,
  group_admin VARCHAR2(50),
  add_time    NUMBER(11),
  token       VARCHAR2(30) not null,
  remark      VARCHAR2(255),
  create_time NUMBER(11) not null
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GROUP
  is '社群表
by yangjin
2018-03-26';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GROUP.group_id
  is '索引主键';
comment on column TP_COMMUNITY_GROUP.group_no
  is '群号 （随机字符串 8位小写字母）';
comment on column TP_COMMUNITY_GROUP.group_name
  is '组名';
comment on column TP_COMMUNITY_GROUP.group_admin
  is '组管理人';
comment on column TP_COMMUNITY_GROUP.add_time
  is '添加时间';
comment on column TP_COMMUNITY_GROUP.remark
  is '备注';
comment on column TP_COMMUNITY_GROUP.create_time
  is '创建时间';
