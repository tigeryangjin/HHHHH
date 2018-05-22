CREATE TABLE `g_activity` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '����',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT 'ר������',
  `share_title` varchar(50) NOT NULL DEFAULT '' COMMENT '�������',
  `share_desc` varchar(150) NOT NULL DEFAULT '' COMMENT '��������',
  `share_img` varchar(200) NOT NULL DEFAULT '1' COMMENT '����ͼƬ',
  `activity_name` varchar(20) NOT NULL DEFAULT '' COMMENT '�����',
  `trace_page_name` varchar(20) NOT NULL DEFAULT '' COMMENT '�û���Ϊͳ�Ʊ���',
  `create_time` datetime DEFAULT NULL COMMENT '����ʱ��',
  `begin_time` datetime DEFAULT NULL COMMENT '��ʼʱ��',
  `end_time` datetime DEFAULT NULL COMMENT '�����ʱ��',
  `from` varchar(10) DEFAULT '1' COMMENT '���� 1:APP 2:Weixin 3:3g 0û�м�¼',
  `enable` tinyint(1) NOT NULL COMMENT '�Ƿ����� 1 ���� 0 ������',
  `author_id` int(11) DEFAULT NULL COMMENT '����Id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

CREATE TABLE G_ACTIVITY_TMP
(  id_col number(10) ,
   title varchar2(150) ,
   share_title varchar2(150) ,
   share_desc varchar2(450) ,
   share_img varchar2(600) ,
   activity_name varchar2(60),
   trace_page_name varchar2(60),
   create_time date ,
   begin_time date ,
   end_time date ,
   from_col varchar2(30) ,
   enable_col varchar2(1) ,
   author_id number(10) );
