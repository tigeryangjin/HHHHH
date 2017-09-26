CREATE TABLE fact_ec_p_xianshi_goods (
   xianshi_goods_id number(10),
   xianshi_type number(2) ,
   xianshi_id number(10),
   crm_policy_id varchar2(40) ,
   xianshi_name varchar2(100),
   xianshi_title varchar2(20) ,
   xianshi_explain varchar2(100) ,
   goods_id number(10),
   goods_commonid number(10) ,
   store_id number(10) ,
   goods_name varchar2(200) ,
   goods_price number(10,2) ,
   xianshi_price number(10,2) ,
   apportion_price number(10,2),
   xianshi_storage number(10) ,
   goods_image varchar2(200) ,
   start_time number(10),
   end_time number(10) ,
   lower_limit number(10) ,
   state number(3) ,
   xianshi_recommend number(3) ,
   xianshi_remark varchar2(200) ,
   sort number(11) 
 ) ;
 
-- Add comments to the columns 
comment on column fact_ec_p_xianshi_goods.xianshi_goods_id
  is '限时折扣商品表'; 
comment on column fact_ec_p_xianshi_goods.xianshi_type
  is '限时类型 1限时直降  2限时抢 3 tv直减'; 
comment on column fact_ec_p_xianshi_goods.xianshi_id
  is '限时活动编号'; 
comment on column fact_ec_p_xianshi_goods.crm_policy_id
  is 'CRM促销编号'; 
comment on column fact_ec_p_xianshi_goods.xianshi_name
  is '活动名称'; 
comment on column fact_ec_p_xianshi_goods.xianshi_title
  is '活动标题'; 
comment on column fact_ec_p_xianshi_goods.xianshi_explain
  is '活动说明'; 
comment on column fact_ec_p_xianshi_goods.goods_id
  is '商品编号'; 
comment on column fact_ec_p_xianshi_goods.goods_commonid
  is '商品SPU'; 
comment on column fact_ec_p_xianshi_goods.store_id
  is '店铺编号'; 
comment on column fact_ec_p_xianshi_goods.goods_name
  is '商品名称'; 
comment on column fact_ec_p_xianshi_goods.goods_price
  is '店铺价格'; 
comment on column fact_ec_p_xianshi_goods.xianshi_price
  is '限时折扣价格'; 
comment on column fact_ec_p_xianshi_goods.apportion_price
  is '供应商分摊金额'; 
comment on column fact_ec_p_xianshi_goods.xianshi_storage
  is '限时库存'; 
comment on column fact_ec_p_xianshi_goods.goods_image
  is '商品图片'; 
comment on column fact_ec_p_xianshi_goods.start_time
  is '开始时间'; 
comment on column fact_ec_p_xianshi_goods.end_time
  is '结束时间'; 
comment on column fact_ec_p_xianshi_goods.lower_limit
  is '购买下限，0为不限制'; 
comment on column fact_ec_p_xianshi_goods.state
  is '状态，0-取消 1-正常 2结束3管理员关闭'; 
comment on column fact_ec_p_xianshi_goods.xianshi_recommend
  is '推荐标志 0-未推荐 1-已推荐'; 
comment on column fact_ec_p_xianshi_goods.xianshi_remark
  is '备注'; 
comment on column fact_ec_p_xianshi_goods.sort
  is '排序号(数字越大越靠前)'; 
	
