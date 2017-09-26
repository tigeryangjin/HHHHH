drop table ec_p_mansong_goods;
CREATE TABLE fact_ec_p_mansong_goods (
   id number(10) ,
   mansong_id number(10) ,
   goods_id number(10) ,
   item_code number(10) ,
   goods_commonid number(10) ,
   erp_code number(10) ,
   goods_name varchar2(600) ,
   state number(10) ,
   create_user varchar2(600),
   create_time number(10) ,
   lastupdate_time number(10) 
 ) ;
-- Add comments to the columns 
comment on column fact_ec_p_mansong_goods.id
  is 'ID号';
comment on column fact_ec_p_mansong_goods.mansong_id
  is '满送ID';
comment on column fact_ec_p_mansong_goods.goods_id
  is '';
comment on column fact_ec_p_mansong_goods.item_code
  is '商品ID sku';
comment on column fact_ec_p_mansong_goods.goods_commonid
  is '商品公共表id';
comment on column fact_ec_p_mansong_goods.erp_code
  is '商品公共表id';
comment on column fact_ec_p_mansong_goods.goods_name
  is '商品名称';
comment on column fact_ec_p_mansong_goods.state
  is '是否有效，1:有效0:无效';
comment on column fact_ec_p_mansong_goods.create_user
  is '添加用户';
comment on column fact_ec_p_mansong_goods.create_time
  is '添加时间';
comment on column fact_ec_p_mansong_goods.lastupdate_time
  is '修改时间';
