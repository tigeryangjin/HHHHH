CREATE TABLE `ec_goods` (
  `goods_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品id(SKU)',
  `item_code` int(11) DEFAULT NULL COMMENT '商品编号 SPU',
  `erp_code` int(11) DEFAULT NULL COMMENT '商品用于下单的编号',
  `goods_commonid` int(10) unsigned NOT NULL COMMENT '商品公共表id',
  `goods_name` varchar(200) NOT NULL COMMENT '商品名称（+规格名称）',
  `goods_jingle` varchar(150) NOT NULL COMMENT '商品广告词',
  `goods_jingle2` varchar(150) DEFAULT NULL,
  `store_id` int(10) unsigned NOT NULL COMMENT '店铺id',
  `store_name` varchar(50) NOT NULL COMMENT '店铺名称',
  `gc_id` int(10) unsigned NOT NULL COMMENT '商品分类id',
  `gc_id_1` int(10) unsigned NOT NULL COMMENT '一级分类id',
  `gc_id_2` int(10) unsigned NOT NULL COMMENT '二级分类id',
  `gc_id_3` int(10) unsigned NOT NULL COMMENT '三级分类id',
  `brand_id` int(10) unsigned NOT NULL COMMENT '品牌id',
  `goods_price` decimal(10,2) NOT NULL COMMENT '商品价格',
  `goods_promotion_price` decimal(10,2) NOT NULL COMMENT '商品促销价格',
  `goods_promotion_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '促销类型 0无促销，1团购，2限时折扣',
  `goods_promotion_id` int(11) NOT NULL DEFAULT '0' COMMENT '使用的促销编号',
  `goods_promotion_price_app` decimal(10,2) NOT NULL COMMENT '商品促销价格-app',
  `goods_promotion_type_app` tinyint(3) NOT NULL DEFAULT '0' COMMENT '促销类型 0无促销，1团购，2限时折扣',
  `goods_promotion_id_app` int(11) NOT NULL DEFAULT '0' COMMENT '使用的促销编号',
  `goods_promotion_price_wx` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品促销价格-微信',
  `goods_promotion_type_wx` tinyint(3) NOT NULL DEFAULT '0' COMMENT '促销类型 0无促销，1团购，2限时折扣',
  `goods_promotion_id_wx` int(11) NOT NULL COMMENT '使用的促销编号',
  `goods_promotion_price_3g` decimal(10,2) NOT NULL COMMENT '商品促销价格-3G',
  `goods_promotion_type_3g` tinyint(3) NOT NULL DEFAULT '0' COMMENT '促销类型 0无促销，1团购，2限时折扣',
  `goods_promotion_id_3g` int(11) NOT NULL COMMENT '使用的促销编号',
  `goods_marketprice` decimal(10,2) NOT NULL COMMENT '市场价',
  `goods_serial` varchar(50) NOT NULL COMMENT '商家编号',
  `goods_storage_alarm` tinyint(3) unsigned NOT NULL COMMENT '库存报警值',
  `goods_click` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品点击数量',
  `goods_salenum` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '销售数量',
  `goods_collect` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '收藏数量',
  `goods_spec` text NOT NULL COMMENT '商品规格序列化',
  `goods_storage` int(10) NOT NULL DEFAULT '0' COMMENT '商品库存',
  `goods_image` varchar(100) NOT NULL DEFAULT '' COMMENT '商品主图',
  `goods_videourl` varchar(200) DEFAULT NULL COMMENT '商品视频地址',
  `goods_state` tinyint(3) unsigned NOT NULL COMMENT '商品状态 0下架，1正常，10违规（禁售）',
  `goods_verify` tinyint(3) unsigned NOT NULL COMMENT '商品审核 1通过，0未通过，10审核中',
  `goods_addtime` int(10) unsigned NOT NULL COMMENT '商品添加时间',
  `goods_edittime` int(10) unsigned NOT NULL COMMENT '商品编辑时间',
  `areaid_1` int(10) unsigned NOT NULL COMMENT '一级地区id',
  `areaid_2` int(10) unsigned NOT NULL COMMENT '二级地区id',
  `color_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '颜色规格id',
  `transport_id` mediumint(8) unsigned NOT NULL COMMENT '运费模板id',
  `goods_freight` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '运费 0为免运费',
  `goods_vat` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否开具增值税发票 1是，0否',
  `goods_commend` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '商品推荐 1是，0否 默认0',
  `goods_stcids` varchar(255) NOT NULL DEFAULT '' COMMENT '店铺分类id 首尾用,隔开',
  `evaluation_good_star` tinyint(3) unsigned NOT NULL DEFAULT '5' COMMENT '好评星级',
  `evaluation_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '评价数',
  `is_virtual` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否为虚拟商品 1是，0否',
  `virtual_indate` int(10) unsigned NOT NULL COMMENT '虚拟商品有效期',
  `virtual_limit` tinyint(3) unsigned NOT NULL COMMENT '虚拟商品购买上限',
  `virtual_invalid_refund` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '是否允许过期退款， 1是，0否',
  `is_fcode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否为F码商品 1是，0否',
  `is_appoint` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否是预约商品 1是，0否',
  `is_presell` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否是预售商品 1是，0否',
  `have_gift` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否拥有赠品',
  `is_own_shop` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否为平台自营',
  `is_tv` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否为TV商品 1是，0否',
  `is_add_cart` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否可以加入购物车 1是，0否',
  `retention_time` int(10) DEFAULT '1800' COMMENT '该商品购买后，订单的最长保留时间，默认半小时',
  `supplier_id` varchar(50) DEFAULT NULL COMMENT '供应商编号',
  `supplier_name` varchar(50) DEFAULT NULL COMMENT '供应商名称',
  `is_live_promotion` tinyint(3) DEFAULT '0' COMMENT '是否享受TV直播的促销（1是，0否）',
  `is_allow_offline` tinyint(3) DEFAULT '1' COMMENT '是否允许货到付款（1是，0否）',
  `is_allow_point` tinyint(3) DEFAULT '1' COMMENT '是否允许使用积分(1是，0否)',
  `is_allow_voucher` tinyint(3) DEFAULT '1' COMMENT '是否允许使用优惠券(1是，0否)',
  `is_allow_paypromotion` tinyint(3) DEFAULT '1' COMMENT '是否享受支付促销(1是，0否)',
  `paypromotion_amount` decimal(10,2) DEFAULT '0.00' COMMENT '支付立减金额',
  `is_allow_bankpromotion` tinyint(3) DEFAULT '1' COMMENT '是否享受银行促销(1是，0否)',
  `is_valuables` tinyint(3) DEFAULT '0' COMMENT '是否为贵品（1是 0否）',
  `is_big` tinyint(3) DEFAULT '0' COMMENT '是否为大件（1是 0否）',
  `give_points` decimal(10,2) DEFAULT '0.00' COMMENT '赠送积分',
  `sync_rule_id` int(10) DEFAULT NULL COMMENT '库存同步规格ID',
  `sync_last_time` int(10) DEFAULT '0' COMMENT '最后同步时间（时间戳）',
  `sync_fail_time` datetime DEFAULT NULL COMMENT '最后同步错误时间（格式化时间）',
  `sync_error_log` varchar(5000) DEFAULT NULL COMMENT '错误日志',
  `sync_status` tinyint(3) DEFAULT '0' COMMENT '库存同步状态（0未同步，1已同步）',
  `is_shipping_self` tinyint(3) NOT NULL DEFAULT '1' COMMENT '0供应商配送   1（自有车队或四通一达配送）',
  `is_new_member_gift` tinyint(3) DEFAULT NULL COMMENT '是否为新人礼（1是，0否）',
  `is_allow_return` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否允许退货（1是0否）',
  `is_appreciation` tinyint(3) DEFAULT '0' COMMENT '是否允许十天鉴赏（0否，1是）',
  `goods_weight` decimal(6,2) DEFAULT '0.00' COMMENT '重量，单位kg',
  `is_reserved` tinyint(3) DEFAULT '0' COMMENT '是否取预留库存（1是，0否）',
  `superscript_id` int(11) DEFAULT '0' COMMENT '角标ID',
  `extra_point` tinyint(3) DEFAULT '0' COMMENT '额外积分倍数',
  `is_reservation_delivery` tinyint(3) NOT NULL DEFAULT '0' COMMENT '商品是否支持预约收货时间',
  `extra_gift` tinyint(3) DEFAULT '0' COMMENT '是否有额外赠送（1是，0否）',
  `ztlhrp` varchar(20) DEFAULT '0' COMMENT '提报组(5000芒果生活)',
  `is_group_purchase` int(1) DEFAULT '0' COMMENT '是否为拼团商品,1：是，0,：否',
  `commission_rule` varchar(20) DEFAULT NULL COMMENT '佣金规则(standard,recommend,manual,none)',
  `commission_rate` decimal(10,4) DEFAULT NULL COMMENT '佣金比',
  `rateBy` int(11) DEFAULT NULL COMMENT '佣金比',
  `delay_days` int(10) DEFAULT '0' COMMENT '可延迟发货天数（0为不可延迟发货）',
  PRIMARY KEY (`goods_id`),
  KEY `NewIndex2` (`goods_commonid`),
  KEY `NewIndex1` (`item_code`),
  KEY `NewIndex3` (`goods_state`),
  KEY `NewIndex4` (`gc_id`),
  KEY `NewIndex5` (`gc_id_1`),
  KEY `NewIndex6` (`gc_id_2`),
  KEY `NewIndex7` (`gc_id_3`),
  KEY `NewIndex8` (`brand_id`),
  KEY `NewIndex9` (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=339805 DEFAULT CHARSET=utf8 COMMENT='商品表';


CREATE TABLE EC_GOODS_TMP (
  goods_id number(10) ,
  item_code number(11),
  erp_code number(11) ,
  goods_commonid number(10) ,
  goods_name varchar2(200),
  goods_jingle varchar2(150),
  goods_jingle2 varchar2(150),
  store_id number(10),
  store_name varchar2(50),
  gc_id number(10)  ,
  gc_id_1 number(10) ,
  gc_id_2 number(10) ,
  gc_id_3 number(10) ,
  brand_id number(10) ,
  goods_price number(10,2),
  goods_promotion_price number(10,2) ,
  goods_promotion_type number(3),
  goods_promotion_id number(11),
  goods_promotion_price_app number(10,2),
  goods_promotion_type_app number(3) ,
  goods_promotion_id_app number(11) ,
  goods_promotion_price_wx number(10,2) ,
  goods_promotion_type_wx number(3) ,
  goods_promotion_id_wx number(11) ,
  goods_promotion_price_3g number(10,2) ,
  goods_promotion_type_3g number(3) ,
  goods_promotion_id_3g number(11) ,
  goods_marketprice number(10,2),
  goods_serial varchar2(50) ,
  goods_storage_alarm number(3)  ,
  goods_click number(10) ,
  goods_salenum number(10) ,
  goods_collect number(10) ,
  goods_spec varchar2(200) ,
  goods_storage number(10),
  goods_image varchar2(100),
  goods_videourl varchar2(200),
  goods_state number(3) ,
  goods_verify number(3),
  goods_addtime date,
  goods_edittime date,
  areaid_1 number(10) ,
  areaid_2 number(10) ,
  color_id number(10) ,
  transport_id number(8) ,
  goods_freight number(10,2) ,
  goods_vat number(3) ,
  goods_commend number(3) ,
  goods_stcids varchar2(255),
  evaluation_good_star number(3) ,
  evaluation_count number(10) ,
  is_virtual number(3) ,
  virtual_indate number(10) ,
  virtual_limit number(3) ,
  virtual_invalid_refund number(3),
  is_fcode number(4) ,
  is_appoint number(3),
  is_presell number(3),
  have_gift number(3) ,
  is_own_shop number(3),
  is_tv number(3) ,
  is_add_cart number(3) ,
  retention_time number(10) ,
  supplier_id varchar2(50),
  supplier_name varchar2(50),
  is_live_promotion number(3),
  is_allow_offline number(3) ,
  is_allow_point number(3) ,
  is_allow_voucher number(3),
  is_allow_paypromotion number(3),
  paypromotion_amount number(10,2) ,
  is_allow_bankpromotion number(3) ,
  is_valuables number(3) ,
  is_big number(3) ,
  give_points number(10,2) ,
  sync_rule_id number(10) ,
  sync_last_time date ,
  sync_fail_time date ,
  sync_error_log varchar2(2000) ,
  sync_status number(3) ,
  is_shipping_self number(3) ,
  is_new_member_gift number(3),
  is_allow_return number(3) ,
  is_appreciation number(3) ,
  goods_weight number(6,2) ,
  is_reserved number(3) ,
  superscript_id number(11) ,
  extra_point number(3) ,
  is_reservation_delivery number(3) ,
  extra_gift number(3) ,
  ztlhrp varchar2(20),
  is_group_purchase number(1) ,
  commission_rule varchar2(20) ,
  commission_rate number(10,4),
  rateBy number(11) ,
  delay_days number(10) 
);


-- Create table
create table FACT_EC_GOODS
(
  goods_id                  NUMBER(10),
  item_code                 NUMBER(11),
  erp_code                  NUMBER(11),
  goods_commonid            NUMBER(10),
  goods_name                VARCHAR2(200),
  goods_jingle              VARCHAR2(500),
  goods_jingle2             VARCHAR2(150),
  store_id                  NUMBER(10),
  store_name                VARCHAR2(50),
  gc_id                     NUMBER(10),
  gc_id_1                   NUMBER(10),
  gc_id_2                   NUMBER(10),
  gc_id_3                   NUMBER(10),
  brand_id                  NUMBER(10),
  goods_price               NUMBER(10,2),
  goods_promotion_price     NUMBER(10,2),
  goods_promotion_type      NUMBER(3),
  goods_promotion_id        NUMBER(11),
  goods_promotion_price_app NUMBER(10,2),
  goods_promotion_type_app  NUMBER(3),
  goods_promotion_id_app    NUMBER(11),
  goods_promotion_price_wx  NUMBER(10,2),
  goods_promotion_type_wx   NUMBER(3),
  goods_promotion_id_wx     NUMBER(11),
  goods_promotion_price_3g  NUMBER(10,2),
  goods_promotion_type_3g   NUMBER(3),
  goods_promotion_id_3g     NUMBER(11),
  goods_marketprice         NUMBER(10,2),
  goods_serial              VARCHAR2(100),
  goods_storage_alarm       NUMBER(3),
  goods_click               NUMBER(10),
  goods_salenum             NUMBER(10),
  goods_collect             NUMBER(10),
  goods_spec                VARCHAR2(200),
  goods_storage             NUMBER(10),
  goods_image               VARCHAR2(100),
  goods_videourl            VARCHAR2(200),
  goods_state               NUMBER(3),
  goods_verify              NUMBER(3),
  goods_addtime             DATE,
  goods_edittime            DATE,
  areaid_1                  NUMBER(10),
  areaid_2                  NUMBER(10),
  color_id                  NUMBER(10),
  transport_id              NUMBER(8),
  goods_freight             NUMBER(10,2),
  goods_vat                 NUMBER(3),
  goods_commend             NUMBER(3),
  goods_stcids              VARCHAR2(255),
  evaluation_good_star      NUMBER(3),
  evaluation_count          NUMBER(10),
  is_virtual                NUMBER(3),
  virtual_indate            NUMBER(10),
  virtual_limit             NUMBER(3),
  virtual_invalid_refund    NUMBER(3),
  is_fcode                  NUMBER(4),
  is_appoint                NUMBER(3),
  is_presell                NUMBER(3),
  have_gift                 NUMBER(3),
  is_own_shop               NUMBER(3),
  is_tv                     NUMBER(3),
  is_add_cart               NUMBER(3),
  retention_time            NUMBER(10),
  supplier_id               VARCHAR2(50),
  supplier_name             VARCHAR2(50),
  is_live_promotion         NUMBER(3),
  is_allow_offline          NUMBER(3),
  is_allow_point            NUMBER(3),
  is_allow_voucher          NUMBER(3),
  is_allow_paypromotion     NUMBER(3),
  paypromotion_amount       NUMBER(10,2),
  is_allow_bankpromotion    NUMBER(3),
  is_valuables              NUMBER(3),
  is_big                    NUMBER(3),
  give_points               NUMBER(10,2),
  sync_rule_id              NUMBER(10),
  sync_last_time            DATE,
  sync_fail_time            DATE,
  sync_error_log            VARCHAR2(2000),
  sync_status               NUMBER(3),
  is_shipping_self          NUMBER(3),
  is_new_member_gift        NUMBER(3),
  is_allow_return           NUMBER(3),
  is_appreciation           NUMBER(3),
  goods_weight              NUMBER(6,2),
  is_reserved               NUMBER(3),
  superscript_id            NUMBER(11),
  extra_point               NUMBER(3),
  is_reservation_delivery   NUMBER(3),
  extra_gift                NUMBER(3),
  ztlhrp                    VARCHAR2(20),
  is_group_purchase         NUMBER(1),
  commission_rule           VARCHAR2(20),
  commission_rate           NUMBER(10,4),
  rateby                    NUMBER(11),
  delay_days                NUMBER(10)
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
comment on table FACT_EC_GOODS
  is '商品表
MySql:happigo_ec
yangjin 2018-07-04';
-- Add comments to the columns 
comment on column FACT_EC_GOODS.goods_id
  is '商品id(SKU)';
comment on column FACT_EC_GOODS.item_code
  is '商品编号 SPU';
comment on column FACT_EC_GOODS.erp_code
  is '商品用于下单的编号';
comment on column FACT_EC_GOODS.goods_commonid
  is '商品公共表id';
comment on column FACT_EC_GOODS.goods_name
  is '商品名称（+规格名称）';
comment on column FACT_EC_GOODS.goods_jingle
  is '商品广告词';
comment on column FACT_EC_GOODS.store_id
  is '店铺id';
comment on column FACT_EC_GOODS.store_name
  is '店铺名称';
comment on column FACT_EC_GOODS.gc_id
  is '商品分类id';
comment on column FACT_EC_GOODS.gc_id_1
  is '一级分类id';
comment on column FACT_EC_GOODS.gc_id_2
  is '二级分类id';
comment on column FACT_EC_GOODS.gc_id_3
  is '三级分类id';
comment on column FACT_EC_GOODS.brand_id
  is '品牌id';
comment on column FACT_EC_GOODS.goods_price
  is '商品价格';
comment on column FACT_EC_GOODS.goods_promotion_price
  is '商品促销价格';
comment on column FACT_EC_GOODS.goods_promotion_type
  is '促销类型 0无促销，1团购，2限时折扣';
comment on column FACT_EC_GOODS.goods_promotion_id
  is '使用的促销编号';
comment on column FACT_EC_GOODS.goods_promotion_price_app
  is '商品促销价格-app';
comment on column FACT_EC_GOODS.goods_promotion_type_app
  is '促销类型 0无促销，1团购，2限时折扣';
comment on column FACT_EC_GOODS.goods_promotion_id_app
  is '使用的促销编号';
comment on column FACT_EC_GOODS.goods_promotion_price_wx
  is '商品促销价格-微信';
comment on column FACT_EC_GOODS.goods_promotion_type_wx
  is '促销类型 0无促销，1团购，2限时折扣';
comment on column FACT_EC_GOODS.goods_promotion_id_wx
  is '使用的促销编号';
comment on column FACT_EC_GOODS.goods_promotion_price_3g
  is '商品促销价格-3G';
comment on column FACT_EC_GOODS.goods_promotion_type_3g
  is '促销类型 0无促销，1团购，2限时折扣';
comment on column FACT_EC_GOODS.goods_promotion_id_3g
  is '使用的促销编号';
comment on column FACT_EC_GOODS.goods_marketprice
  is '市场价';
comment on column FACT_EC_GOODS.goods_serial
  is '商家编号';
comment on column FACT_EC_GOODS.goods_storage_alarm
  is '库存报警值';
comment on column FACT_EC_GOODS.goods_click
  is '商品点击数量';
comment on column FACT_EC_GOODS.goods_salenum
  is '销售数量';
comment on column FACT_EC_GOODS.goods_collect
  is '收藏数量';
comment on column FACT_EC_GOODS.goods_spec
  is '商品规格序列化';
comment on column FACT_EC_GOODS.goods_storage
  is '商品库存';
comment on column FACT_EC_GOODS.goods_image
  is '商品主图';
comment on column FACT_EC_GOODS.goods_videourl
  is '商品视频地址';
comment on column FACT_EC_GOODS.goods_state
  is '商品状态 0下架，1正常，10违规（禁售）';
comment on column FACT_EC_GOODS.goods_verify
  is '商品审核 1通过，0未通过，10审核中';
comment on column FACT_EC_GOODS.goods_addtime
  is '商品添加时间';
comment on column FACT_EC_GOODS.goods_edittime
  is '商品编辑时间';
comment on column FACT_EC_GOODS.areaid_1
  is '一级地区id';
comment on column FACT_EC_GOODS.areaid_2
  is '二级地区id';
comment on column FACT_EC_GOODS.color_id
  is '颜色规格id';
comment on column FACT_EC_GOODS.transport_id
  is '运费模板id';
comment on column FACT_EC_GOODS.goods_freight
  is '运费 0为免运费';
comment on column FACT_EC_GOODS.goods_vat
  is '是否开具增值税发票 1是，0否';
comment on column FACT_EC_GOODS.goods_commend
  is '商品推荐 1是，0否 默认0';
comment on column FACT_EC_GOODS.goods_stcids
  is '店铺分类id 首尾用,隔开';
comment on column FACT_EC_GOODS.evaluation_good_star
  is '好评星级';
comment on column FACT_EC_GOODS.evaluation_count
  is '评价数';
comment on column FACT_EC_GOODS.is_virtual
  is '是否为虚拟商品 1是，0否';
comment on column FACT_EC_GOODS.virtual_indate
  is '虚拟商品有效期';
comment on column FACT_EC_GOODS.virtual_limit
  is '虚拟商品购买上限';
comment on column FACT_EC_GOODS.virtual_invalid_refund
  is '是否允许过期退款， 1是，0否';
comment on column FACT_EC_GOODS.is_fcode
  is '是否为F码商品 1是，0否';
comment on column FACT_EC_GOODS.is_appoint
  is '是否是预约商品 1是，0否';
comment on column FACT_EC_GOODS.is_presell
  is '是否是预售商品 1是，0否';
comment on column FACT_EC_GOODS.have_gift
  is '是否拥有赠品';
comment on column FACT_EC_GOODS.is_own_shop
  is '是否为平台自营';
comment on column FACT_EC_GOODS.is_tv
  is '是否为TV商品 1是，0否';
comment on column FACT_EC_GOODS.is_add_cart
  is '是否可以加入购物车 1是，0否';
comment on column FACT_EC_GOODS.retention_time
  is '该商品购买后，订单的最长保留时间，默认半小时';
comment on column FACT_EC_GOODS.supplier_id
  is '供应商编号';
comment on column FACT_EC_GOODS.supplier_name
  is '供应商名称';
comment on column FACT_EC_GOODS.is_live_promotion
  is '是否享受TV直播的促销（1是，0否）';
comment on column FACT_EC_GOODS.is_allow_offline
  is '是否允许货到付款（1是，0否）';
comment on column FACT_EC_GOODS.is_allow_point
  is '是否允许使用积分(1是，0否)';
comment on column FACT_EC_GOODS.is_allow_voucher
  is '是否允许使用优惠券(1是，0否)';
comment on column FACT_EC_GOODS.is_allow_paypromotion
  is '是否享受支付促销(1是，0否)';
comment on column FACT_EC_GOODS.paypromotion_amount
  is '支付立减金额';
comment on column FACT_EC_GOODS.is_allow_bankpromotion
  is '是否享受银行促销(1是，0否)';
comment on column FACT_EC_GOODS.is_valuables
  is '是否为贵品（1是 0否）';
comment on column FACT_EC_GOODS.is_big
  is '是否为大件（1是 0否）';
comment on column FACT_EC_GOODS.give_points
  is '赠送积分';
comment on column FACT_EC_GOODS.sync_rule_id
  is '库存同步规格ID';
comment on column FACT_EC_GOODS.sync_last_time
  is '最后同步时间（时间戳）';
comment on column FACT_EC_GOODS.sync_fail_time
  is '最后同步错误时间（格式化时间）';
comment on column FACT_EC_GOODS.sync_error_log
  is '错误日志';
comment on column FACT_EC_GOODS.sync_status
  is '库存同步状态（0未同步，1已同步）';
comment on column FACT_EC_GOODS.is_shipping_self
  is '0供应商配送   1（自有车队或四通一达配送）';
comment on column FACT_EC_GOODS.is_new_member_gift
  is '是否为新人礼（1是，0否）';
comment on column FACT_EC_GOODS.is_allow_return
  is '是否允许退货（1是0否）';
comment on column FACT_EC_GOODS.is_appreciation
  is '是否允许十天鉴赏（0否，1是）';
comment on column FACT_EC_GOODS.goods_weight
  is '重量，单位kg';
comment on column FACT_EC_GOODS.is_reserved
  is '是否取预留库存（1是，0否）';
comment on column FACT_EC_GOODS.superscript_id
  is '角标ID';
comment on column FACT_EC_GOODS.extra_point
  is '额外积分倍数';
comment on column FACT_EC_GOODS.is_reservation_delivery
  is '商品是否支持预约收货时间';
comment on column FACT_EC_GOODS.extra_gift
  is '是否有额外赠送（1是，0否）';
comment on column FACT_EC_GOODS.ztlhrp
  is '提报组(5000芒果生活)';
comment on column FACT_EC_GOODS.is_group_purchase
  is '是否为拼团商品,1：是，0,：否';
comment on column FACT_EC_GOODS.commission_rule
  is '佣金规则(standard,recommend,manual,none)';
comment on column FACT_EC_GOODS.commission_rate
  is '佣金比';
comment on column FACT_EC_GOODS.rateby
  is '佣金比';
comment on column FACT_EC_GOODS.delay_days
  is '可延迟发货天数（0为不可延迟发货）';
