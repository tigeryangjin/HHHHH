CREATE TABLE `g_activity_goods_group` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `activity_id` int(11) NOT NULL DEFAULT '0' COMMENT '活动外键',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '分组名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '分组更新时间',
  `customed_superscript` int(11) NOT NULL DEFAULT '1' COMMENT '1开启 0不开启 10使用自定义角标',
  `image_src` varchar(100) NOT NULL DEFAULT '' COMMENT '角标图片路径',
  `method` tinyint(1) DEFAULT '1' COMMENT '1:人工排位、2：销量',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=124 DEFAULT CHARSET=utf8;


CREATE TABLE G_ACTIVITY_GOODS_GROUP_TMP
(   ID_COL NUMBER(10),
		ACTIVITY_ID NUMBER(10),
		TITLE VARCHAR(150),
		CREATE_TIME DATE,
		UPDATE_TIME DATE,
		CUSTOMED_SUPERSCRIPT NUMBER(10),
		IMAGE_SRC VARCHAR(300),
		METHOD NUMBER(1));
