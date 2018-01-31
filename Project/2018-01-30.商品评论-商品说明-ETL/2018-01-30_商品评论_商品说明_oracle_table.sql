--mysql
CREATE TABLE `ec_goods_manual` (
  `manual_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动ID',
  `item_code` int(11) DEFAULT NULL COMMENT '商品编号',
  `common_id` int(11) DEFAULT NULL COMMENT '商品公共ID',
  `zmalab` varchar(50) DEFAULT NULL COMMENT '说明书项key',
  `zlabname` varchar(100) DEFAULT NULL COMMENT '说明书项名称',
  `zmalabtxt` text COMMENT '说明书项内容',
  `checked` tinyint(2) DEFAULT '0' COMMENT '是否勾选显示（1是，0否）',
  `add_time` datetime DEFAULT NULL COMMENT '入库时间',
  `show_sort` tinyint(2) DEFAULT '0' COMMENT '显示排序',
  PRIMARY KEY (`manual_id`),
  KEY `index_item_id` (`item_code`),
  KEY `index_common_id` (`common_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1769037 DEFAULT CHARSET=utf8 COMMENT='商品说明书信息表';

-- Create table EC_GOODS_MANUAL_TMP
drop table EC_GOODS_MANUAL_TMP;
create table EC_GOODS_MANUAL_TMP
(
  manual_id NUMBER(10),
  item_code NUMBER(10),
  common_id NUMBER(10),
  zmalab    VARCHAR2(50),
  zlabname  VARCHAR2(100),
  zmalabtxt CLOB,
  checked   NUMBER(1),
  add_time  DATE,
	show_sort number(2)
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
comment on table EC_GOODS_MANUAL_TMP
  is '商品说明书信息表_中间表
by yangjin
2018-01-30';
-- Add comments to the columns 
comment on column EC_GOODS_MANUAL_TMP.manual_id
  is '自动ID';
comment on column EC_GOODS_MANUAL_TMP.item_code
  is '商品编号';
comment on column EC_GOODS_MANUAL_TMP.common_id
  is '商品公共ID';
comment on column EC_GOODS_MANUAL_TMP.zmalab
  is '说明书项key';
comment on column EC_GOODS_MANUAL_TMP.zlabname
  is '说明书项名称';
comment on column EC_GOODS_MANUAL_TMP.checked
  is '是否勾选显示（1是，0否）';
comment on column EC_GOODS_MANUAL_TMP.add_time
  is '入库时间';
comment on column EC_GOODS_MANUAL_TMP.zmalabtxt
  is '说明书项内容';
comment on column EC_GOODS_MANUAL_TMP.show_sort
  is '显示排序';

-- Create table EC_GOODS_MANUAL
drop table FACT_EC_GOODS_MANUAL;
create table FACT_EC_GOODS_MANUAL
(
  manual_id NUMBER(10),
  item_code NUMBER(10),
  common_id NUMBER(10),
  zmalab    VARCHAR2(50),
  zlabname  VARCHAR2(100),
  zmalabtxt CLOB,
  checked   NUMBER(1),
  add_time  DATE,
	show_sort number(2)
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
comment on table FACT_EC_GOODS_MANUAL
  is '商品说明书信息表
by yangjin
2018-01-30';
-- Add comments to the columns 
comment on column FACT_EC_GOODS_MANUAL.manual_id
  is '自动ID';
comment on column FACT_EC_GOODS_MANUAL.item_code
  is '商品编号';
comment on column FACT_EC_GOODS_MANUAL.common_id
  is '商品公共ID';
comment on column FACT_EC_GOODS_MANUAL.zmalab
  is '说明书项key';
comment on column FACT_EC_GOODS_MANUAL.zlabname
  is '说明书项名称';
comment on column FACT_EC_GOODS_MANUAL.checked
  is '是否勾选显示（1是，0否）';
comment on column FACT_EC_GOODS_MANUAL.add_time
  is '入库时间';
comment on column FACT_EC_GOODS_MANUAL.zmalabtxt
  is '说明书项内容';
comment on column FACT_EC_GOODS_MANUAL.show_sort
  is '显示排序';
