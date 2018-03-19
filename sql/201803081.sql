create table KPI_ASMT_TOTAL_MONTH_BAK AS
SELECT * from KPI_ASMT_TOTAL_MONTH;
drop table KPI_ASMT_TOTAL_MONTH;
-- Create table
create table KPI_ASMT_TOTAL_MONTH
(
  month_key               VARCHAR2(6) not null,
  app_mau                 NUMBER,
  app_order_cvr           NUMBER,
	app_item_cvr            NUMBER,
  wx_dau                  NUMBER,
  wx_new_reg_count        NUMBER,
  wx_non_scan_cvr         NUMBER,
  vedio_item_cvr          NUMBER,
  new_visit_count         NUMBER,
  old_visit_count         NUMBER,
  download_count          NUMBER,
  reg_order_cvr           NUMBER,
  repurchase_member_count NUMBER,
  repurchase_member_per   NUMBER,
  w_insert_dt             DATE,
  w_update_dt             DATE
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
comment on table KPI_ASMT_TOTAL_MONTH
  is 'KPI�¶ȿ���ָ�����
by yangjin
2018-03-07';
-- Add comments to the columns 
comment on column KPI_ASMT_TOTAL_MONTH.month_key
  is '�·�key';
comment on column KPI_ASMT_TOTAL_MONTH.app_mau
  is 'KPI����ָ��--������Ӫ��--APP�»�';
comment on column KPI_ASMT_TOTAL_MONTH.app_order_cvr
  is 'KPI����ָ��--������Ӫ��--APP������ת����';
comment on column KPI_ASMT_TOTAL_MONTH.app_item_cvr
  is 'KPI����ָ��--������Ӫ��--��Ʒ����ҳת����';	
comment on column KPI_ASMT_TOTAL_MONTH.wx_dau
  is 'KPI����ָ��--΢����Ӫ��--΢���ջ�';
comment on column KPI_ASMT_TOTAL_MONTH.wx_new_reg_count
  is 'KPI����ָ��--΢����Ӫ��--����ע����';
comment on column KPI_ASMT_TOTAL_MONTH.wx_non_scan_cvr
  is 'KPI����ָ��--΢����Ӫ��--��ɨ������������ת����';
comment on column KPI_ASMT_TOTAL_MONTH.vedio_item_cvr
  is 'KPI����ָ��--΢����Ӫ��--��Ƶ����Ʒ����ҳת����';
comment on column KPI_ASMT_TOTAL_MONTH.new_visit_count
  is 'KPI����ָ��--�г���--�վ��·ÿ���';
comment on column KPI_ASMT_TOTAL_MONTH.old_visit_count
  is 'KPI����ָ��--�г���--�վ��Ϸÿ���';
comment on column KPI_ASMT_TOTAL_MONTH.download_count
  is 'KPI����ָ��--�г���--APP����������';
comment on column KPI_ASMT_TOTAL_MONTH.reg_order_cvr
  is 'KPI����ָ��--�г���--������ע���Ա������ת����';
comment on column KPI_ASMT_TOTAL_MONTH.repurchase_member_count
  is 'KPI����ָ��--�г���--�ϻ�Ա��������';
comment on column KPI_ASMT_TOTAL_MONTH.repurchase_member_per
  is 'KPI����ָ��--���ݲ�Ʒ��--��Ա������';
comment on column KPI_ASMT_TOTAL_MONTH.w_insert_dt
  is '��¼����ʱ��';
comment on column KPI_ASMT_TOTAL_MONTH.w_update_dt
  is '��¼�޸�ʱ��';
-- Create/Recreate primary, unique and foreign key constraints 
alter table KPI_ASMT_TOTAL_MONTH
  add constraint KPI_ASMT_TOTAL_MONTH_PK primary key (MONTH_KEY)
  using index 
  tablespace DWDATA00
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
	
INSERT INTO KPI_ASMT_TOTAL_MONTH
  (MONTH_KEY,
   APP_MAU,
   APP_ORDER_CVR,
   WX_DAU,
   WX_NEW_REG_COUNT,
   WX_NON_SCAN_CVR,
   VEDIO_ITEM_CVR,
   NEW_VISIT_COUNT,
   OLD_VISIT_COUNT,
   DOWNLOAD_COUNT,
   REG_ORDER_CVR,
   REPURCHASE_MEMBER_COUNT,
   REPURCHASE_MEMBER_PER,
   W_INSERT_DT,
   W_UPDATE_DT)
  SELECT A.MONTH_KEY,
         A.APP_MAU,
         A.APP_ORDER_CVR,
         A.WX_DAU,
         A.WX_NEW_REG_COUNT,
         A.WX_NON_SCAN_CVR,
         A.VEDIO_ITEM_CVR,
         A.NEW_VISIT_COUNT,
         A.OLD_VISIT_COUNT,
         A.DOWNLOAD_COUNT,
         A.REG_ORDER_CVR,
         A.REPURCHASE_MEMBER_COUNT,
         A.REPURCHASE_MEMBER_PER,
         A.W_INSERT_DT,
         A.W_UPDATE_DT
    FROM KPI_ASMT_TOTAL_MONTH_BAK A;


SELECT MONTH_KEY, ROUND(AVG(NVL(AVG_CVR,0)),4) CVR
  FROM KPI_ASMT_APP_ITEM_CVR
 GROUP BY MONTH_KEY;