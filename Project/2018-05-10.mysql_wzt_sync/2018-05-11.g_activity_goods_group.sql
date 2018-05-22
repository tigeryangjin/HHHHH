CREATE TABLE `g_activity_goods_group` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '����',
  `activity_id` int(11) NOT NULL DEFAULT '0' COMMENT '����',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '��������',
  `create_time` datetime DEFAULT NULL COMMENT '����ʱ��',
  `update_time` datetime DEFAULT NULL COMMENT '�������ʱ��',
  `customed_superscript` int(11) NOT NULL DEFAULT '1' COMMENT '1���� 0������ 10ʹ���Զ���Ǳ�',
  `image_src` varchar(100) NOT NULL DEFAULT '' COMMENT '�Ǳ�ͼƬ·��',
  `method` tinyint(1) DEFAULT '1' COMMENT '1:�˹���λ��2������',
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
