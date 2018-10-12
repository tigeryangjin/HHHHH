-- Create table
create table DATA_ACQUISITION_ITEM_BASE_TMP
(
  period        VARCHAR2(80) not null,
  matdlt        VARCHAR2(80),
  matzlt        VARCHAR2(80),
  matxlt        VARCHAR2(80),
  acq_item_code VARCHAR2(50) not null,
  acq_name      VARCHAR2(500),
  acq_url       VARCHAR2(500),
  acq_pic       VARCHAR2(500),
  acq_shop_name VARCHAR2(200),
  acq_price     NUMBER(20,2),
  acq_sales     NUMBER,
  sales_amt     NUMBER(20,2)
)
partition by range (PERIOD)
(
  partition P201612 values less than (20170101)
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
    ),
  partition P201701 values less than (20170201)
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
    ),
  partition P201702 values less than (20170301)
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
    ),
  partition P201703 values less than (20170401)
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
    ),
  partition P201704 values less than (20170501)
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
    ),
  partition P201705 values less than (20170601)
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
    ),
  partition P201706 values less than (20170701)
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
    ),
  partition P201707 values less than (20170801)
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
    ),
  partition P201708 values less than (20170901)
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
    ),
  partition P201709 values less than (20171001)
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
    ),
  partition P201710 values less than (20171101)
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
    ),
  partition P201711 values less than (20171201)
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
    ),
  partition P201712 values less than (20180101)
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
    ),
  partition P201801 values less than (20180201)
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
    ),
  partition P201802 values less than (20180301)
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
    ),
  partition P201803 values less than (20180401)
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
    ),
  partition P201804 values less than (20180501)
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
    ),
  partition P201805 values less than (20180601)
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
    ),
  partition P201806 values less than (20180701)
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
    ),
  partition P201807 values less than (20180801)
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
    ),
  partition P201808 values less than (20180901)
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
    ),
  partition P201809 values less than (20181001)
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
    ),
  partition P201810 values less than (20181101)
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
    ),
  partition P201811 values less than (20181201)
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
    ),
  partition P201812 values less than (20190101)
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
    ),
  partition P201901 values less than (20190201)
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
    ),
  partition P201902 values less than (20190301)
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
    ),
  partition P201903 values less than (20190401)
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
    ),
  partition P201904 values less than (20190501)
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
    ),
  partition P201905 values less than (20190601)
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
    ),
  partition P201906 values less than (20190701)
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
    ),
  partition P201907 values less than (20190801)
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
    ),
  partition P201908 values less than (20190901)
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
    ),
  partition P201909 values less than (20191001)
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
    ),
  partition P201910 values less than (20191101)
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
    ),
  partition P201911 values less than (20191201)
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
    ),
  partition P201912 values less than (20200101)
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
    ),
  partition P202001 values less than (20200201)
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
    ),
  partition P202002 values less than (20200301)
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
    ),
  partition P202003 values less than (20200401)
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
    ),
  partition P202004 values less than (20200501)
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
    ),
  partition P202005 values less than (20200601)
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
    ),
  partition P202006 values less than (20200701)
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
    ),
  partition P202007 values less than (20200801)
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
    ),
  partition P202008 values less than (20200901)
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
    ),
  partition P202009 values less than (20201001)
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
    ),
  partition P202010 values less than (20201101)
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
    ),
  partition P202011 values less than (20201201)
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
    ),
  partition P202012 values less than (20210101)
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
    ),
  partition P202101 values less than (20210201)
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
    ),
  partition P202102 values less than (20210301)
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
    ),
  partition P202103 values less than (20210401)
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
    ),
  partition P202104 values less than (20210501)
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
    ),
  partition P202105 values less than (20210601)
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
    ),
  partition P202106 values less than (20210701)
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
    ),
  partition P202107 values less than (20210801)
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
    ),
  partition P202108 values less than (20210901)
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
    ),
  partition P202109 values less than (20211001)
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
    ),
  partition P202110 values less than (20211101)
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
    ),
  partition P202111 values less than (20211201)
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
    ),
  partition P202112 values less than (20220101)
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
    ),
  partition P202201 values less than (20220201)
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
    ),
  partition P202202 values less than (20220301)
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
    ),
  partition P202203 values less than (20220401)
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
    ),
  partition P202204 values less than (20220501)
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
    ),
  partition P202205 values less than (20220601)
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
    ),
  partition P202206 values less than (20220701)
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
    ),
  partition P202207 values less than (20220801)
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
    ),
  partition P202208 values less than (20220901)
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
    ),
  partition P202209 values less than (20221001)
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
    ),
  partition P202210 values less than (20221101)
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
    ),
  partition P202211 values less than (20221201)
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
    ),
  partition PMAX values less than (MAXVALUE)
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
    )
);
-- Add comments to the table 
comment on table DATA_ACQUISITION_ITEM_BASE_TMP
  is '从DATA_ACQUISITION_ITEM_TMP插入数据，存放清洗后的数据
by yangjin';
-- Add comments to the columns 
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.period
  is '日期';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.matdlt
  is '物料大类编码';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.matzlt
  is '物料中类编码';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.matxlt
  is '物料小类编码';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.acq_item_code
  is '商品编码';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.acq_name
  is '商品名称';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.acq_url
  is '商品URL地址';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.acq_pic
  is '商品图片地址';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.acq_shop_name
  is '店铺名称';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.acq_price
  is '商品价格';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.acq_sales
  is '累计销售数量';
comment on column DATA_ACQUISITION_ITEM_BASE_TMP.sales_amt
  is '累计销售金额';

