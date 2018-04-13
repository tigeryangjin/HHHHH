CREATE TABLE `tp_community_group_link` (
  `link_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '索引主键',
  `group_id` int(11) NOT NULL COMMENT '所属分组',
  `group_no` varchar(50) NOT NULL COMMENT '群编号',
  `sign` varchar(200) NOT NULL COMMENT '签名',
  `link_expire_time` int(11) NOT NULL COMMENT '链接过期时间',
  `admin_user` varchar(50) NOT NULL,
  `add_time` int(11) NOT NULL COMMENT '创建时间',
  `token` varchar(30) NOT NULL,
  PRIMARY KEY (`link_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

create table tp_community_group_link_tmp(
  link_id number(11) NOT NULL,
  group_id number(11) NOT NULL ,
  group_no varchar2(50) NOT NULL,
  sign varchar2(200) NOT NULL ,
  link_expire_time number(11) NOT NULL,
  admin_user varchar2(50) NOT NULL,
  add_time number(11) NOT NULL ,
  token varchar2(30) NOT NULL);
	
-- Create table
create table TP_COMMUNITY_GROUP_LINK
(
  link_id          NUMBER(11) not null,
  group_id         NUMBER(11) not null,
  group_no         VARCHAR2(50) not null,
  sign             VARCHAR2(200) not null,
  link_expire_time NUMBER(11) not null,
  admin_user       VARCHAR2(50) not null,
  add_time         NUMBER(11) not null,
  token            VARCHAR2(30) not null
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GROUP_LINK
  is '群分享链接表
by yangjin
2018-03-26';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GROUP_LINK.link_id
  is '索引主键';
comment on column TP_COMMUNITY_GROUP_LINK.group_id
  is '所属分组';
comment on column TP_COMMUNITY_GROUP_LINK.group_no
  is '群编号';
comment on column TP_COMMUNITY_GROUP_LINK.sign
  is '签名';
comment on column TP_COMMUNITY_GROUP_LINK.link_expire_time
  is '链接过期时间';
comment on column TP_COMMUNITY_GROUP_LINK.admin_user
  is '操作人';
comment on column TP_COMMUNITY_GROUP_LINK.add_time
  is '创建时间';
