CREATE TABLE `g_activity` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '专题名称',
  `share_title` varchar(50) NOT NULL DEFAULT '' COMMENT '分享标题',
  `share_desc` varchar(150) NOT NULL DEFAULT '' COMMENT '分享描述',
  `share_img` varchar(200) NOT NULL DEFAULT '1' COMMENT '分享图片',
  `activity_name` varchar(20) NOT NULL DEFAULT '' COMMENT '活动名称',
  `trace_page_name` varchar(20) NOT NULL DEFAULT '' COMMENT '用户行为统计编码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `begin_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '活动结束时间',
  `from` varchar(10) DEFAULT '1' COMMENT '渠道 1:APP 2:Weixin 3:3g 0没有记录',
  `enable` tinyint(1) NOT NULL COMMENT '是否启用 1 启用 0 不启用',
  `author_id` int(11) DEFAULT NULL COMMENT '作者Id',
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
