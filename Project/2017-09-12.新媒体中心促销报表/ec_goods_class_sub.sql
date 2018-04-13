CREATE TABLE `ec_goods_class_sub` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '�ӷ���Id������',
  `gc_id` int(11) NOT NULL COMMENT '��Ʒ����Id',
  `name` varchar(100) NOT NULL COMMENT '�ӷ�������',
  `pic` varchar(200) NOT NULL COMMENT '�ӷ���ͼƬ',
  `description` varchar(500) DEFAULT NULL COMMENT '����',
  `sort` int(11) NOT NULL COMMENT '����',
  `status` tinyint(3) NOT NULL COMMENT '0��δ���á�1�����ã�Ĭ��Ϊ1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=230 DEFAULT CHARSET=utf8 COMMENT='��Ʒ�ӷ����';


create table dim_ec_goods_class_sub (  id number(11) NOT NULL ,
  gc_id number(11) NOT NULL ,
  name varchar2(100) NOT NULL ,
  pic varchar2(200) NOT NULL ,
  description varchar2(500) ,
  sort number(11) NOT NULL ,
  status number(3) NOT NULL );
