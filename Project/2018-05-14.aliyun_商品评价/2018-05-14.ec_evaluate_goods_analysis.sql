CREATE TABLE `ec_evaluate_goods_analysis` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `geval_id` int(11) DEFAULT NULL COMMENT '评价ID',
  `geval_ordergoodsid` int(11) DEFAULT NULL COMMENT '订单商品表编号',
  `geval_goodsid` int(11) DEFAULT NULL COMMENT '商品表编号SPU',
  `aspect_category` varchar(255) DEFAULT NULL COMMENT '属性类别',
  `aspect_term` varchar(255) DEFAULT NULL COMMENT '属性词',
  `aspect_index` varchar(255) DEFAULT NULL COMMENT '属性词所在的起始位置，终结位置',
  `aspect_polarity` varchar(255) DEFAULT NULL COMMENT '属性片段极性（正、中、负）',
  `opinion_term` varchar(255) DEFAULT NULL COMMENT '情感词',
  `create_time` int(11) DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `goods_index` (`geval_goodsid`) USING BTREE,
  KEY `order_goods_index` (`geval_ordergoodsid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=10135 DEFAULT CHARSET=utf8;

SELECT * FROM ALL_ALL_TABLES A WHERE A.owner='DW_USER' AND A.table_name LIKE '%EVALUATE%';

CREATE TABLE FACT_GOODS_EVALUATE_ALIYUN
(  ID_COL NUMBER(10),
  GEVAL_ID NUMBER(11),
  GEVAL_ORDERGOODSID NUMBER(11),
  GEVAL_GOODSID NUMBER(11),
  ASPECT_CATEGORY VARCHAR2(255),
  ASPECT_TERM VARCHAR2(255),
  ASPECT_INDEX VARCHAR2(255),
  ASPECT_POLARITY VARCHAR2(255),
  OPINION_TERM VARCHAR2(255),
  CREATE_TIME NUMBER(11));
