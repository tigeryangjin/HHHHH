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
  is '��Ʒ���۽��������-�м��
by yangjin
2018-05-14';
-- Add comments to the columns 
comment on column FACT_GOODS_EVALUATE_ALI_TMP.id_col
  is 'ID';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.geval_id
  is '����ID';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.geval_ordergoodsid
  is '������Ʒ����';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.geval_goodsid
  is '��Ʒ����SPU';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.aspect_category
  is '�������';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.aspect_term
  is '���Դ�';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.aspect_index
  is '���Դ����ڵ���ʼλ�ã��ս�λ��';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.aspect_polarity
  is '����Ƭ�μ��ԣ������С�����';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.opinion_term
  is '��д�';
comment on column FACT_GOODS_EVALUATE_ALI_TMP.create_time
  is '����ʱ��';
