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
  is 'ID��';
comment on column fact_ec_p_mansong_goods.mansong_id
  is '����ID';
comment on column fact_ec_p_mansong_goods.goods_id
  is '';
comment on column fact_ec_p_mansong_goods.item_code
  is '��ƷID sku';
comment on column fact_ec_p_mansong_goods.goods_commonid
  is '��Ʒ������id';
comment on column fact_ec_p_mansong_goods.erp_code
  is '��Ʒ������id';
comment on column fact_ec_p_mansong_goods.goods_name
  is '��Ʒ����';
comment on column fact_ec_p_mansong_goods.state
  is '�Ƿ���Ч��1:��Ч0:��Ч';
comment on column fact_ec_p_mansong_goods.create_user
  is '����û�';
comment on column fact_ec_p_mansong_goods.create_time
  is '���ʱ��';
comment on column fact_ec_p_mansong_goods.lastupdate_time
  is '�޸�ʱ��';
