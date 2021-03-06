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
  is 'KPI月度考核指标汇总
by yangjin
2018-03-07';
-- Add comments to the columns 
comment on column KPI_ASMT_TOTAL_MONTH.month_key
  is '月份key';
comment on column KPI_ASMT_TOTAL_MONTH.app_mau
  is 'KPI考核指标--渠道运营部--APP月活';
comment on column KPI_ASMT_TOTAL_MONTH.app_order_cvr
  is 'KPI考核指标--渠道运营部--APP净订购转化率';
comment on column KPI_ASMT_TOTAL_MONTH.app_item_cvr
  is 'KPI考核指标--渠道运营部--商品详情页转化率';	
comment on column KPI_ASMT_TOTAL_MONTH.wx_dau
  is 'KPI考核指标--微信运营部--微信日活';
comment on column KPI_ASMT_TOTAL_MONTH.wx_new_reg_count
  is 'KPI考核指标--微信运营部--新增注册数';
comment on column KPI_ASMT_TOTAL_MONTH.wx_non_scan_cvr
  is 'KPI考核指标--微信运营部--非扫码人数净订购转化率';
comment on column KPI_ASMT_TOTAL_MONTH.vedio_item_cvr
  is 'KPI考核指标--微信运营部--视频购商品详情页转化率';
comment on column KPI_ASMT_TOTAL_MONTH.new_visit_count
  is 'KPI考核指标--市场部--日均新访客数';
comment on column KPI_ASMT_TOTAL_MONTH.old_visit_count
  is 'KPI考核指标--市场部--日均老访客数';
comment on column KPI_ASMT_TOTAL_MONTH.download_count
  is 'KPI考核指标--市场部--APP新增下载数';
comment on column KPI_ASMT_TOTAL_MONTH.reg_order_cvr
  is 'KPI考核指标--市场部--当月新注册会员净订购转化率';
comment on column KPI_ASMT_TOTAL_MONTH.repurchase_member_count
  is 'KPI考核指标--市场部--老会员复购人数';
comment on column KPI_ASMT_TOTAL_MONTH.repurchase_member_per
  is 'KPI考核指标--数据产品部--会员复购率';
comment on column KPI_ASMT_TOTAL_MONTH.w_insert_dt
  is '记录插入时间';
comment on column KPI_ASMT_TOTAL_MONTH.w_update_dt
  is '记录修改时间';
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
