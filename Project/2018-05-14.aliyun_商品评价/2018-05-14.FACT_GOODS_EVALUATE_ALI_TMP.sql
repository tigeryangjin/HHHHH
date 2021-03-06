-- Create table
create table FACT_GOODS_EVALUATE_ALI_TMP
(
  id_col             NUMBER(10),
  geval_id           NUMBER(11),
  geval_ordergoodsid NUMBER(11),
  geval_goodsid      NUMBER(11),
  aspect_category    VARCHAR2(255),
  aspect_term        VARCHAR2(255),
  aspect_index       VARCHAR2(255),
  aspect_polarity    VARCHAR2(255),
  opinion_term       VARCHAR2(255),
  create_time        NUMBER(11)
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table FACT_GOODS_EVALUATE_ALI_TMP
  is '商品评价解析结果表-中间表
by yangjin
2018-05-14';
-- Add comments to the columns 
comment on column FACT_GOODS_EVALUATE_ALI_TMP.id_col
  is 'ID';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.geval_id
  is '评价ID';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.geval_ordergoodsid
  is '订单商品表编号';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.geval_goodsid
  is '商品表编号SPU';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.aspect_category
  is '属性类别';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.aspect_term
  is '属性词';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.aspect_index
  is '属性词所在的起始位置，终结位置';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.aspect_polarity
  is '属性片段极性（正、中、负）';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.opinion_term
  is '情感词';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.create_time
  is '创建时间';
