CREATE TABLE `ec_tags` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '��ǩID',
  `tag_name` varchar(20) NOT NULL COMMENT '��ǩ����',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '�ϼ���ǩID',
  `is_show` tinyint(3) NOT NULL DEFAULT '1' COMMENT '�Ƿ���ʾ��1��0��Ĭ����',
  `is_checkbox` tinyint(3) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ɶ�ѡ��1��0��Ĭ�Ϸ�',
  `sort` tinyint(3) NOT NULL DEFAULT '0' COMMENT '���򣨴�С����',
  `add_time` datetime DEFAULT NULL COMMENT '���ʱ��',
  `edit_time` datetime DEFAULT NULL COMMENT '�޸�ʱ��',
  PRIMARY KEY (`tag_id`),
  KEY `index_parent_id` (`parent_id`),
  KEY `index_isshow` (`is_show`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='��ǩ��Ϣ��';

CREATE TABLE EC_TAGS_TMP
(  tag_id number(10),
  tag_name varchar2(60),
  parent_id number(10),
  is_show number(3),
  is_checkbox number(3),
  sort number(3),
  add_time date,
  edit_time date);
