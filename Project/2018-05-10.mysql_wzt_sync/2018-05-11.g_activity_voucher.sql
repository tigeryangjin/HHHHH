CREATE TABLE `g_activity_voucher` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '����',
  `activity_id` int(11) NOT NULL DEFAULT '0' COMMENT '����',
  `voucher_id` varchar(50) NOT NULL DEFAULT '' COMMENT '�Ż݄�id',
  `voucher_key` datetime DEFAULT NULL COMMENT '�Ż݄�key',
  `create_time` datetime DEFAULT NULL COMMENT '����ʱ��',
  `update_time` datetime DEFAULT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE G_ACTIVITY_VOUCHER_TMP
(  ID_COL NUMBER(10),
  ACTIVITY_ID NUMBER(10),
  VOUCHER_ID VARCHAR2(150),
  VOUCHER_KEY DATE,
  CREATE_TIME DATE,
  UPDATE_TIME DATE);
