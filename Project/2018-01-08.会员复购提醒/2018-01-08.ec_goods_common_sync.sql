CREATE TABLE `ec_goods_common` (
  `goods_commonid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品公共表id',
  `item_code` int(11) DEFAULT NULL COMMENT '商品编号',
  `goods_name` varchar(200) NOT NULL COMMENT '商品名称',
  `goods_jingle` varchar(150) NOT NULL COMMENT '商品广告词',
  `goods_jingle2` varchar(150) DEFAULT NULL,
  `goods_short_desc` varchar(200) DEFAULT '' COMMENT '商品短描述',
  `gc_id` int(10) unsigned NOT NULL COMMENT '商品分类',
  `gc_id_1` int(10) unsigned NOT NULL COMMENT '一级分类id',
  `gc_id_2` int(10) unsigned NOT NULL COMMENT '二级分类id',
  `gc_id_3` int(10) unsigned NOT NULL COMMENT '三级分类id',
  `gc_name` varchar(200) NOT NULL COMMENT '商品分类',
  `gc_sub_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品分类子分类Id',
  `matdl` int(11) DEFAULT NULL COMMENT 'erp分类-大类',
  `matzl` int(11) DEFAULT NULL COMMENT 'erp分类-中类',
  `matxl` int(11) DEFAULT NULL COMMENT 'erp分类-小类',
  `matkl` int(11) DEFAULT NULL COMMENT 'erp分类-细类',
  `store_id` int(10) unsigned NOT NULL COMMENT '店铺id',
  `store_name` varchar(50) NOT NULL COMMENT '店铺名称',
  `spec_name` varchar(255) NOT NULL COMMENT '规格名称',
  `spec_value` text NOT NULL COMMENT '规格值',
  `brand_id` int(10) unsigned NOT NULL COMMENT '品牌id',
  `brand_name` varchar(100) NOT NULL COMMENT '品牌名称',
  `type_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '类型id',
  `goods_image` varchar(100) NOT NULL COMMENT '商品主图',
  `goods_animation` varchar(200) DEFAULT NULL COMMENT '商品动画地址',
  `goods_videourl` varchar(200) DEFAULT NULL COMMENT '商品视频地址',
  `goods_attr` text NOT NULL COMMENT '商品属性',
  `goods_body` text NOT NULL COMMENT '商品内容',
  `mobile_body` text NOT NULL COMMENT '手机端商品描述',
  `goods_state` int(3) unsigned NOT NULL COMMENT '商品状态 0下架，1正常，10违规（禁售）',
  `goods_stateremark` varchar(255) DEFAULT NULL COMMENT '违规原因',
  `goods_verify` tinyint(3) unsigned NOT NULL COMMENT '商品审核 1通过，0未通过，10审核中',
  `goods_verifyremark` varchar(255) DEFAULT NULL COMMENT '审核失败原因',
  `goods_lock` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '商品锁定 0未锁，1已锁',
  `goods_addtime` int(10) unsigned NOT NULL COMMENT '商品添加时间',
  `goods_selltime` int(10) unsigned NOT NULL COMMENT '上架时间',
  `goods_specname` text NOT NULL COMMENT '规格名称序列化（下标为规格id）',
  `goods_price` decimal(10,2) NOT NULL COMMENT '商品价格',
  `goods_marketprice` decimal(10,2) NOT NULL COMMENT '市场价',
  `goods_costprice` decimal(10,2) NOT NULL COMMENT '成本价',
  `goods_discount` float unsigned NOT NULL COMMENT '折扣',
  `goods_promotion_price` decimal(10,2) DEFAULT NULL COMMENT '该商品下各SKU的最低网站促销价',
  `goods_promotion_price_app` decimal(10,2) DEFAULT NULL COMMENT '该商品下各SKU的最低APP促销价',
  `goods_promotion_price_wx` decimal(10,2) DEFAULT NULL COMMENT '该商品下各SKU的最低WX促销价',
  `goods_promotion_price_3g` decimal(10,2) DEFAULT NULL COMMENT '该商品下各SKU的最低3G促销价',
  `goods_serial` varchar(50) NOT NULL COMMENT '商家编号',
  `goods_storage` int(10) DEFAULT '0' COMMENT '商品总库存',
  `goods_storage_alarm` int(3) unsigned NOT NULL COMMENT '库存报警值',
  `transport_id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '运费模板',
  `transport_title` varchar(60) NOT NULL DEFAULT '' COMMENT '运费模板名称',
  `goods_commend` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '商品推荐 1是，0否，默认为0',
  `goods_freight` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '运费 0为免运费',
  `goods_vat` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否开具增值税发票 1是，0否',
  `areaid_1` int(10) unsigned NOT NULL COMMENT '一级地区id',
  `areaid_2` int(10) unsigned NOT NULL COMMENT '二级地区id',
  `goods_stcids` varchar(255) NOT NULL DEFAULT '' COMMENT '店铺分类id 首尾用,隔开',
  `plateid_top` int(10) unsigned DEFAULT NULL COMMENT '顶部关联板式',
  `plateid_bottom` int(10) unsigned DEFAULT NULL COMMENT '底部关联板式',
  `is_virtual` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否为虚拟商品 1是，0否',
  `virtual_indate` int(10) unsigned DEFAULT NULL COMMENT '虚拟商品有效期',
  `virtual_limit` tinyint(3) unsigned DEFAULT NULL COMMENT '虚拟商品购买上限',
  `virtual_invalid_refund` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '是否允许过期退款， 1是，0否',
  `is_fcode` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否为F码商品 1是，0否',
  `is_appoint` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否是预约商品 1是，0否',
  `appoint_satedate` int(10) unsigned NOT NULL COMMENT '预约商品出售时间',
  `is_presell` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否是预售商品 1是，0否',
  `presell_deliverdate` int(10) unsigned NOT NULL COMMENT '预售商品发货时间',
  `is_own_shop` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否为平台自营',
  `is_tv` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否为TV商品 1是，0否',
  `is_add_cart` tinyint(3) DEFAULT '1' COMMENT '是否允许加入购物车 1是，0否',
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
  `goods_salenum` int(10) DEFAULT '0' COMMENT '销售数量',
  `goods_pop` int(10) DEFAULT '0' COMMENT '人气值',
  `gift_num` int(10) DEFAULT NULL COMMENT '该商品下各SKU的最大的赠品数量',
  `is_valuables` tinyint(3) DEFAULT '0' COMMENT '是否为贵品（1是 0否）',
  `is_big` tinyint(3) DEFAULT '0' COMMENT '是否为大件（1是 0否）',
  `give_points` int(10) DEFAULT '0' COMMENT '赠送积分',
  `is_shipping_self` tinyint(3) NOT NULL DEFAULT '1' COMMENT '0供应商配送   1（自有车队或四通一达配送）',
  `is_new_member_gift` tinyint(3) DEFAULT '0' COMMENT '是否为新人礼（1是，0否）',
  `is_allow_return` tinyint(3) NOT NULL DEFAULT '1' COMMENT '是否允许退货（1是0否）',
  `is_appreciation` tinyint(3) DEFAULT '0' COMMENT '是否允许十天鉴赏（0否，1是）',
  `goods_weight` decimal(6,2) DEFAULT '0.00' COMMENT '重量，单位kg',
  `is_reserved` tinyint(3) DEFAULT '0' COMMENT '是否取预留库存（1是，0否）',
  `pv_total` int(10) DEFAULT '0' COMMENT 'PV总数',
  `uv_total` int(10) DEFAULT '0' COMMENT 'UV总数',
  `salenum_d1` int(10) DEFAULT '0' COMMENT '昨日销售数量',
  `salenum_d7` int(10) DEFAULT '0' COMMENT '最近7天销售数量',
  `salenum_d30` int(10) DEFAULT '0' COMMENT '最近30天销售数量',
  `salenum_d90` int(10) DEFAULT '0' COMMENT '最近90天销售数量',
  `collect_total` int(10) DEFAULT '0' COMMENT '收藏数',
  `evaluation_total` int(10) DEFAULT '0' COMMENT '评价总数',
  `search_key` text COMMENT '搜索关键词',
  `superscript_id` int(11) DEFAULT '0' COMMENT '角标ID',
  `extra_point` tinyint(3) DEFAULT '0' COMMENT '额外积分倍数',
  `is_reservation_delivery` tinyint(3) NOT NULL DEFAULT '0' COMMENT '商品是否支持预约收货时间',
  `goods_reminder` varchar(500) NOT NULL DEFAULT '' COMMENT '商品温馨提示',
  `goods_service` text COMMENT '商品服务项',
  `goods_service_ids` varchar(50) DEFAULT NULL COMMENT '商品服务项ID集合',
  `firstonselltime` int(10) DEFAULT '946656000' COMMENT '首次上架时间',
  `newgoodsrate` tinyint(3) DEFAULT '0' COMMENT '新品指数等级（0,1,2,3）',
  `fastbuyenable` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否启用快速购买支持（自动选择默认规格，购买数量1）',
  `customer_service` text COMMENT '售后服务（APP第三个页面内容）序列化存储',
  `physical_inventory` tinyint(3) DEFAULT '1' COMMENT '是否有实物库存（0无，1有）',
  `use_date` datetime DEFAULT NULL COMMENT '编号正式采用时间',
  `extra_gift` tinyint(3) DEFAULT '0' COMMENT '是否有额外赠送（1是，0否）',
  `ztlhrp` varchar(20) DEFAULT '0' COMMENT '提报组(5000:芒果生活)',
  `zt_pic` varchar(500) DEFAULT NULL,
  `zt_url` varchar(1000) DEFAULT NULL,
  `pml_id` int(10) DEFAULT NULL COMMENT '等级减活动商品ID',
  `pml_title` varchar(20) DEFAULT NULL COMMENT '活动名称/标题',
  `pml_max_promotion` decimal(10,2) DEFAULT NULL COMMENT '最大促销额',
  `pml_promotion` varchar(200) DEFAULT NULL COMMENT '促销额',
  `pml_enable` tinyint(3) DEFAULT '0' COMMENT '等级减开关，0关闭 1开启',
  `live_image` varchar(100) DEFAULT NULL COMMENT '直播商品图片（暂用于移动端首页直播模块）',
  `is_group_purchase` int(1) DEFAULT '0' COMMENT '是否为拼团商品,1：是，0,：否',
  `commission_rule` varchar(20) DEFAULT NULL COMMENT '佣金规则(standard,recommend,manual,none)',
  `commission_rate` decimal(10,4) DEFAULT NULL COMMENT '佣金比',
  `delay_days` int(10) DEFAULT '0' COMMENT '可延迟发货天数（0为不可延迟发货）',
  PRIMARY KEY (`goods_commonid`),
  UNIQUE KEY `item_code` (`item_code`) USING BTREE,
  KEY `NewIndex2` (`gc_id`),
  KEY `NewIndex3` (`gc_id_1`),
  KEY `NewIndex4` (`gc_id_2`),
  KEY `NewIndex5` (`gc_id_3`),
  KEY `NewIndex6` (`matdl`),
  KEY `NewIndex7` (`matzl`),
  KEY `NewIndex8` (`matxl`),
  KEY `NewIndex9` (`matkl`)
) ENGINE=InnoDB AUTO_INCREMENT=174711 DEFAULT CHARSET=utf8 COMMENT='商品公共内容表';

--*******************************************************************************************************
CREATE TABLE ec_goods_common_tmp (
  goods_commonid number(10),
  item_code number(10) ,
  goods_name varchar2(200),
  goods_jingle varchar2(150),
  goods_jingle2 varchar2(150),
  goods_short_desc varchar2(200),
  gc_id number(10) ,
  gc_id_1 number(10) ,
  gc_id_2 number(10) ,
  gc_id_3 number(10) ,
  gc_name varchar2(200) ,
  gc_sub_id number(10) ,
  matdl number(10) ,
  matzl number(10) ,
  matxl number(10) ,
  matkl number(10) ,
  store_id number(10),
  store_name varchar2(50),
  spec_name varchar2(255),
  spec_value varchar2(500),
  brand_id number(10) ,
  brand_name varchar2(100) ,
  type_id number(10) ,
  goods_image varchar2(100),
  goods_animation varchar2(200),
  goods_videourl varchar2(200) ,
  goods_attr varchar2(200) ,
  goods_body varchar2(500) ,
  mobile_body varchar2(500),
  goods_state number(10) ,
  goods_stateremark varchar2(255) ,
  goods_verify number(10) ,
  goods_verifyremark varchar2(255),
  goods_lock number(10) ,
  goods_addtime number(10) ,
  goods_selltime number(10),
  goods_specname varchar2(200),
  goods_price number(10,2),
  goods_marketprice number(10,2),
  goods_costprice number(10,2),
  goods_discount number(10,4) ,
  goods_promotion_price number(10,2),
  goods_promotion_price_app number(10,2),
  goods_promotion_price_wx number(10,2) ,
  goods_promotion_price_3g number(10,2) ,
  goods_serial varchar2(50) ,
  goods_storage number(10) ,
  goods_storage_alarm number(10),
  transport_id number(10) ,
  transport_title varchar2(60) ,
  goods_commend number(10) ,
  goods_freight number(10,2),
  goods_vat number(10),
  areaid_1 number(10),
  areaid_2 number(10),
  goods_stcids varchar2(255),
  plateid_top number(10),
  plateid_bottom number(10),
  is_virtual number(10) ,
  virtual_indate number(10),
  virtual_limit number(10) ,
  virtual_invalid_refund number(10),
  is_fcode number(10) ,
  is_appoint number(10),
  appoint_satedate number(10) ,
  is_presell number(10) ,
  presell_deliverdate number(10) ,
  is_own_shop number(10) ,
  is_tv number(10),
  is_add_cart number(10),
  retention_time number(10),
  supplier_id varchar2(50) ,
  supplier_name varchar2(50) ,
  is_live_promotion number(3),
  is_allow_offline number(3) ,
  is_allow_point number(3) ,
  is_allow_voucher number(3),
  is_allow_paypromotion number(3),
  paypromotion_amount number(10,2),
  is_allow_bankpromotion number(3),
  goods_salenum number(10),
  goods_pop number(10),
  gift_num number(10) ,
  is_valuables number(3),
  is_big number(3) ,
  give_points number(10),
  is_shipping_self number(3),
  is_new_member_gift number(3),
  is_allow_return number(3) ,
  is_appreciation number(3) ,
  goods_weight number(6,2) ,
  is_reserved number(3) ,
  pv_total number(10) ,
  uv_total number(10) ,
  salenum_d1 number(10),
  salenum_d7 number(10),
  salenum_d30 number(10),
  salenum_d90 number(10),
  collect_total number(10),
  evaluation_total number(10),
  search_key varchar2(800) ,
  superscript_id number(11),
  extra_point number(3) ,
  is_reservation_delivery number(3) ,
  goods_reminder varchar2(500) ,
  goods_service varchar2(500),
  goods_service_ids varchar2(50),
  firstonselltime number(10) ,
  newgoodsrate number(3) ,
  fastbuyenable number(3),
  customer_service varchar2(1000),
  physical_inventory number(3) ,
  use_date date ,
  extra_gift number(3) ,
  ztlhrp varchar2(20) ,
  zt_pic varchar2(500),
  zt_url varchar2(1000),
  pml_id number(10) ,
  pml_title varchar2(20) ,
  pml_max_promotion number(10,2),
  pml_promotion varchar2(200) ,
  pml_enable number(3) ,
  live_image varchar2(100) ,
  is_group_purchase number(10),
  commission_rule varchar2(20),
  commission_rate number(10,4),
  delay_days number(10) 
) ;
-- Add comments to the table 
comment on table ec_goods_common_tmp
  is '商品公共内容表happigo_ec';
-- Add comments to the columns 
comment on column ec_goods_common_tmp.goods_commonid is '商品公共表id';
comment on column ec_goods_common_tmp.item_code is '商品编号';
comment on column ec_goods_common_tmp.goods_name is '商品名称';
comment on column ec_goods_common_tmp.goods_jingle is '商品广告词';
comment on column ec_goods_common_tmp.goods_short_desc is '商品短描述';
comment on column ec_goods_common_tmp.gc_id is '商品分类';
comment on column ec_goods_common_tmp.gc_id_1 is '一级分类id';
comment on column ec_goods_common_tmp.gc_id_2 is '二级分类id';
comment on column ec_goods_common_tmp.gc_id_3 is '三级分类id';
comment on column ec_goods_common_tmp.gc_name is '商品分类';
comment on column ec_goods_common_tmp.gc_sub_id is '商品分类子分类Id';
comment on column ec_goods_common_tmp.matdl is 'erp分类-大类';
comment on column ec_goods_common_tmp.matzl is 'erp分类-中类';
comment on column ec_goods_common_tmp.matxl is 'erp分类-小类';
comment on column ec_goods_common_tmp.matkl is 'erp分类-细类';
comment on column ec_goods_common_tmp.store_id is '店铺id';
comment on column ec_goods_common_tmp.store_name is '店铺名称';
comment on column ec_goods_common_tmp.spec_name is '规格名称';
comment on column ec_goods_common_tmp.spec_value is '规格值';
comment on column ec_goods_common_tmp.brand_id is '品牌id';
comment on column ec_goods_common_tmp.brand_name is '品牌名称';
comment on column ec_goods_common_tmp.type_id is '类型id';
comment on column ec_goods_common_tmp.goods_image is '商品主图';
comment on column ec_goods_common_tmp.goods_animation is '商品动画地址';
comment on column ec_goods_common_tmp.goods_videourl is '商品视频地址';
comment on column ec_goods_common_tmp.goods_attr is '商品属性';
comment on column ec_goods_common_tmp.goods_body is '商品内容';
comment on column ec_goods_common_tmp.mobile_body is '手机端商品描述';
comment on column ec_goods_common_tmp.goods_state is '商品状态 0下架，1正常，10违规（禁售）';
comment on column ec_goods_common_tmp.goods_stateremark is '违规原因';
comment on column ec_goods_common_tmp.goods_verify is '商品审核 1通过，0未通过，10审核中';
comment on column ec_goods_common_tmp.goods_verifyremark is '审核失败原因';
comment on column ec_goods_common_tmp.goods_lock is '商品锁定 0未锁，1已锁';
comment on column ec_goods_common_tmp.goods_addtime is '商品添加时间';
comment on column ec_goods_common_tmp.goods_selltime is '上架时间';
comment on column ec_goods_common_tmp.goods_specname is '规格名称序列化（下标为规格id）';
comment on column ec_goods_common_tmp.goods_price is '商品价格';
comment on column ec_goods_common_tmp.goods_marketprice is '市场价';
comment on column ec_goods_common_tmp.goods_costprice is '成本价';
comment on column ec_goods_common_tmp.goods_discount is '折扣';
comment on column ec_goods_common_tmp.goods_promotion_price is '该商品下各SKU的最低网站促销价';
comment on column ec_goods_common_tmp.goods_promotion_price_app is '该商品下各SKU的最低APP促销价';
comment on column ec_goods_common_tmp.goods_promotion_price_wx is '该商品下各SKU的最低WX促销价';
comment on column ec_goods_common_tmp.goods_promotion_price_3g is '该商品下各SKU的最低3G促销价';
comment on column ec_goods_common_tmp.goods_serial is '商家编号';
comment on column ec_goods_common_tmp.goods_storage is '商品总库存';
comment on column ec_goods_common_tmp.goods_storage_alarm is '库存报警值';
comment on column ec_goods_common_tmp.transport_id is '运费模板';
comment on column ec_goods_common_tmp.transport_title is '运费模板名称';
comment on column ec_goods_common_tmp.goods_commend is '商品推荐 1是，0否，默认为0';
comment on column ec_goods_common_tmp.goods_freight is '运费 0为免运费';
comment on column ec_goods_common_tmp.goods_vat is '是否开具增值税发票 1是，0否';
comment on column ec_goods_common_tmp.areaid_1 is '一级地区id';
comment on column ec_goods_common_tmp.areaid_2 is '二级地区id';
comment on column ec_goods_common_tmp.goods_stcids is '店铺分类id 首尾用,隔开';
comment on column ec_goods_common_tmp.plateid_top is '顶部关联板式';
comment on column ec_goods_common_tmp.plateid_bottom is '底部关联板式';
comment on column ec_goods_common_tmp.is_virtual is '是否为虚拟商品 1是，0否';
comment on column ec_goods_common_tmp.virtual_indate is '虚拟商品有效期';
comment on column ec_goods_common_tmp.virtual_limit is '虚拟商品购买上限';
comment on column ec_goods_common_tmp.virtual_invalid_refund is '是否允许过期退款， 1是，0否';
comment on column ec_goods_common_tmp.is_fcode is '是否为F码商品 1是，0否';
comment on column ec_goods_common_tmp.is_appoint is '是否是预约商品 1是，0否';
comment on column ec_goods_common_tmp.appoint_satedate is '预约商品出售时间';
comment on column ec_goods_common_tmp.is_presell is '是否是预售商品 1是，0否';
comment on column ec_goods_common_tmp.presell_deliverdate is '预售商品发货时间';
comment on column ec_goods_common_tmp.is_own_shop is '是否为平台自营';
comment on column ec_goods_common_tmp.is_tv is '是否为TV商品 1是，0否';
comment on column ec_goods_common_tmp.is_add_cart is '是否允许加入购物车 1是，0否';
comment on column ec_goods_common_tmp.retention_time is '该商品购买后，订单的最长保留时间，默认半小时';
comment on column ec_goods_common_tmp.supplier_id is '供应商编号';
comment on column ec_goods_common_tmp.supplier_name is '供应商名称';
comment on column ec_goods_common_tmp.is_live_promotion is '是否享受TV直播的促销（1是，0否）';
comment on column ec_goods_common_tmp.is_allow_offline is '是否允许货到付款（1是，0否）';
comment on column ec_goods_common_tmp.is_allow_point is '是否允许使用积分(1是，0否)';
comment on column ec_goods_common_tmp.is_allow_voucher is '是否允许使用优惠券(1是，0否)';
comment on column ec_goods_common_tmp.is_allow_paypromotion is '是否享受支付促销(1是，0否)';
comment on column ec_goods_common_tmp.paypromotion_amount is '支付立减金额';
comment on column ec_goods_common_tmp.is_allow_bankpromotion is '是否享受银行促销(1是，0否)';
comment on column ec_goods_common_tmp.goods_salenum is '销售数量';
comment on column ec_goods_common_tmp.goods_pop is '人气值';
comment on column ec_goods_common_tmp.gift_num is '该商品下各SKU的最大的赠品数量';
comment on column ec_goods_common_tmp.is_valuables is '是否为贵品（1是 0否）';
comment on column ec_goods_common_tmp.is_big is '是否为大件（1是 0否）';
comment on column ec_goods_common_tmp.give_points is '赠送积分';
comment on column ec_goods_common_tmp.is_shipping_self is '0供应商配送   1（自有车队或四通一达配送）';
comment on column ec_goods_common_tmp.is_new_member_gift is '是否为新人礼（1是，0否）';
comment on column ec_goods_common_tmp.is_allow_return is '是否允许退货（1是0否）';
comment on column ec_goods_common_tmp.is_appreciation is '是否允许十天鉴赏（0否，1是）';
comment on column ec_goods_common_tmp.goods_weight is '重量，单位kg';
comment on column ec_goods_common_tmp.is_reserved is '是否取预留库存（1是，0否）';
comment on column ec_goods_common_tmp.pv_total is 'PV总数';
comment on column ec_goods_common_tmp.uv_total is 'UV总数';
comment on column ec_goods_common_tmp.salenum_d1 is '昨日销售数量';
comment on column ec_goods_common_tmp.salenum_d7 is '最近7天销售数量';
comment on column ec_goods_common_tmp.salenum_d30 is '最近30天销售数量';
comment on column ec_goods_common_tmp.salenum_d90 is '最近90天销售数量';
comment on column ec_goods_common_tmp.collect_total is '收藏数';
comment on column ec_goods_common_tmp.evaluation_total is '评价总数';
comment on column ec_goods_common_tmp.search_key is '搜索关键词';
comment on column ec_goods_common_tmp.superscript_id is '角标ID';
comment on column ec_goods_common_tmp.extra_point is '额外积分倍数';
comment on column ec_goods_common_tmp.is_reservation_delivery is '商品是否支持预约收货时间';
comment on column ec_goods_common_tmp.goods_reminder is '商品温馨提示';
comment on column ec_goods_common_tmp.goods_service is '商品服务项';
comment on column ec_goods_common_tmp.goods_service_ids is '商品服务项ID集合';
comment on column ec_goods_common_tmp.firstonselltime is '首次上架时间';
comment on column ec_goods_common_tmp.newgoodsrate is '新品指数等级（0,1,2,3）';
comment on column ec_goods_common_tmp.fastbuyenable is '是否启用快速购买支持（自动选择默认规格，购买数量1）';
comment on column ec_goods_common_tmp.customer_service is '售后服务（APP第三个页面内容）序列化存储';
comment on column ec_goods_common_tmp.physical_inventory is '是否有实物库存（0无，1有）';
comment on column ec_goods_common_tmp.use_date is '编号正式采用时间';
comment on column ec_goods_common_tmp.extra_gift is '是否有额外赠送（1是，0否）';
comment on column ec_goods_common_tmp.ztlhrp is '提报组(5000:芒果生活)';
comment on column ec_goods_common_tmp.pml_id is '等级减活动商品ID';
comment on column ec_goods_common_tmp.pml_title is '活动名称/标题';
comment on column ec_goods_common_tmp.pml_max_promotion is '最大促销额';
comment on column ec_goods_common_tmp.pml_promotion is '促销额';
comment on column ec_goods_common_tmp.pml_enable is '等级减开关，0关闭 1开启';
comment on column ec_goods_common_tmp.live_image is '直播商品图片（暂用于移动端首页直播模块）';
comment on column ec_goods_common_tmp.is_group_purchase is '是否为拼团商品,1：是，0,：否';
comment on column ec_goods_common_tmp.commission_rule is '佣金规则(standard,recommend,manual,none)';
comment on column ec_goods_common_tmp.commission_rate is '佣金比';
comment on column ec_goods_common_tmp.delay_days is '可延迟发货天数（0为不可延迟发货）';


