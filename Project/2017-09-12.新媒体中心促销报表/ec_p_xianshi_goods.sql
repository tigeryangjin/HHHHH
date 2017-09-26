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
  is '��ʱ�ۿ���Ʒ��'; 
comment on column fact_ec_p_xianshi_goods.xianshi_type
  is '��ʱ���� 1��ʱֱ��  2��ʱ�� 3 tvֱ��'; 
comment on column fact_ec_p_xianshi_goods.xianshi_id
  is '��ʱ����'; 
comment on column fact_ec_p_xianshi_goods.crm_policy_id
  is 'CRM�������'; 
comment on column fact_ec_p_xianshi_goods.xianshi_name
  is '�����'; 
comment on column fact_ec_p_xianshi_goods.xianshi_title
  is '�����'; 
comment on column fact_ec_p_xianshi_goods.xianshi_explain
  is '�˵��'; 
comment on column fact_ec_p_xianshi_goods.goods_id
  is '��Ʒ���'; 
comment on column fact_ec_p_xianshi_goods.goods_commonid
  is '��ƷSPU'; 
comment on column fact_ec_p_xianshi_goods.store_id
  is '���̱��'; 
comment on column fact_ec_p_xianshi_goods.goods_name
  is '��Ʒ����'; 
comment on column fact_ec_p_xianshi_goods.goods_price
  is '���̼۸�'; 
comment on column fact_ec_p_xianshi_goods.xianshi_price
  is '��ʱ�ۿۼ۸�'; 
comment on column fact_ec_p_xianshi_goods.apportion_price
  is '��Ӧ�̷�̯���'; 
comment on column fact_ec_p_xianshi_goods.xianshi_storage
  is '��ʱ���'; 
comment on column fact_ec_p_xianshi_goods.goods_image
  is '��ƷͼƬ'; 
comment on column fact_ec_p_xianshi_goods.start_time
  is '��ʼʱ��'; 
comment on column fact_ec_p_xianshi_goods.end_time
  is '����ʱ��'; 
comment on column fact_ec_p_xianshi_goods.lower_limit
  is '�������ޣ�0Ϊ������'; 
comment on column fact_ec_p_xianshi_goods.state
  is '״̬��0-ȡ�� 1-���� 2����3����Ա�ر�'; 
comment on column fact_ec_p_xianshi_goods.xianshi_recommend
  is '�Ƽ���־ 0-δ�Ƽ� 1-���Ƽ�'; 
comment on column fact_ec_p_xianshi_goods.xianshi_remark
  is '��ע'; 
comment on column fact_ec_p_xianshi_goods.sort
  is '�����(����Խ��Խ��ǰ)'; 
	
