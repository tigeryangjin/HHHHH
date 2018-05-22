CREATE TABLE `ec_tags` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` varchar(20) NOT NULL COMMENT '标签名称',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '上级标签ID',
  `is_show` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否显示（1是0否）默认是',
  `is_checkbox` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否可多选择（1是0否）默认否',
  `sort` tinyint(3) NOT NULL DEFAULT '0' COMMENT '排序（从小到大）',
  `add_time` datetime DEFAULT NULL COMMENT '添加时间',
  `edit_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`tag_id`),
  KEY `index_parent_id` (`parent_id`),
  KEY `index_isshow` (`is_show`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='标签信息表';

CREATE TABLE EC_TAGS_TMP
(  tag_id number(10),
  tag_name varchar2(60),
  parent_id number(10),
  is_show number(3),
  is_checkbox number(3),
  sort number(3),
  add_time date,
  edit_time date);
