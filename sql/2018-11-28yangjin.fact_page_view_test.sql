-- Create table
create table FACT_PAGE_VIEW_TEST
(
  id                NUMBER(20),
  page_view_key     NUMBER(20),
  vid               VARCHAR2(1000),
  device_key        NUMBER(20) default 0,
  ip                VARCHAR2(500),
  ip_geo_key        NUMBER(10),
  ip_int            NUMBER(20),
  url               VARCHAR2(1000),
  page_key          NUMBER(10),
  page_name         VARCHAR2(500),
  page_value        VARCHAR2(3000),
  last_page_key     NUMBER(10),
  hmsc_key          NUMBER(10),
  hmsc              VARCHAR2(200),
  application_key   NUMBER(10),
  application_name  VARCHAR2(800),
  visit_date_key    NUMBER(10),
  visit_date        DATE,
  pagebegin_time    DATE,
  pageend_time      DATE,
  page_staytime_key NUMBER(10),
  page_staytime     NUMBER(10),
  member_key        NUMBER(20),
  visit_hour_key    NUMBER(10) default 0,
  visit_hour        NUMBER(10),
  ver_key           NUMBER(10) default 0,
  ver_name          VARCHAR2(200),
  agent             VARCHAR2(1000),
  hmmd              VARCHAR2(200),
  hmpl              VARCHAR2(200),
  hmkw              VARCHAR2(1000),
  hmci              VARCHAR2(1000),
  visit_month       NUMBER(10),
  session_key       NUMBER(20),
  channel_key       NUMBER(10),
  ipgeo_key         NUMBER(10) default 0
)
partition by range (VISIT_DATE)
subpartition by list (VISIT_MONTH)
(
  partition FPV2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace EXDATA
    pctfree 10
    initrans 1
    maxtrans 255
    storage
    (
      initial 2
      next 1
      minextents 1
      maxextents unlimited
    )
  (
    subpartition FPV201506 values (201506) tablespace FPV_DATA_2015,
    subpartition FPV201507 values (201507) tablespace FPV_DATA_2015,
    subpartition FPV201508 values (201508) tablespace FPV_DATA_2015,
    subpartition FPV201509 values (201509) tablespace FPV_DATA_2015,
    subpartition FPV201510 values (201510) tablespace FPV_DATA_2015,
    subpartition FPV201511 values (201511) tablespace FPV_DATA_2015,
    subpartition FPV201512 values (201512) tablespace FPV_DATA_2015
  ),
  partition FPV2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace EXDATA
    pctfree 10
    initrans 1
    maxtrans 255
    storage
    (
      initial 2
      minextents 1
      maxextents unlimited
    )
  (
    subpartition FPV201601 values (201601) tablespace FPV_DATA_2016,
    subpartition FPV201602 values (201602) tablespace FPV_DATA_2016,
    subpartition FPV201603 values (201603) tablespace FPV_DATA_2016,
    subpartition FPV201604 values (201604) tablespace FPV_DATA_2016,
    subpartition FPV201605 values (201605) tablespace FPV_DATA_2016,
    subpartition FPV201606 values (201606) tablespace FPV_DATA_2016,
    subpartition FPV201607 values (201607) tablespace FPV_DATA_2016,
    subpartition FPV201608 values (201608) tablespace FPV_DATA_2016,
    subpartition FPV201609 values (201609) tablespace FPV_DATA_2016,
    subpartition FPV201610 values (201610) tablespace FPV_DATA_2016,
    subpartition FPV201611 values (201611) tablespace FPV_DATA_2016,
    subpartition FPV201612 values (201612) tablespace FPV_DATA_2016
  ),
  partition FPV2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace EXDATA
    pctfree 10
    initrans 1
    maxtrans 255
    storage
    (
      initial 8
      minextents 1
      maxextents unlimited
    )
  (
    subpartition FPV201701 values (201701) tablespace FPV_DATA_2017,
    subpartition FPV201702 values (201702) tablespace FPV_DATA_2017,
    subpartition FPV201703 values (201703) tablespace FPV_DATA_2017,
    subpartition FPV201704 values (201704) tablespace FPV_DATA_2017,
    subpartition FPV201705 values (201705) tablespace FPV_DATA_2017,
    subpartition FPV201706 values (201706) tablespace FPV_DATA_2017,
    subpartition FPV201707 values (201707) tablespace FPV_DATA_2017,
    subpartition FPV201708 values (201708) tablespace FPV_DATA_2017,
    subpartition FPV201709 values (201709) tablespace FPV_DATA_2017,
    subpartition FPV201710 values (201710) tablespace FPV_DATA_2017,
    subpartition FPV201711 values (201711) tablespace FPV_DATA_2017,
    subpartition FPV201712 values (201712) tablespace FPV_DATA_2017
  ),
  partition FPV2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace EXDATA
    pctfree 10
    initrans 1
    maxtrans 255
    storage
    (
      initial 8
      minextents 1
      maxextents unlimited
    )
  (
    subpartition FPV201801 values (201801) tablespace FPV_DATA_2018,
    subpartition FPV201802 values (201802) tablespace FPV_DATA_2018,
    subpartition FPV201803 values (201803) tablespace FPV_DATA_2018,
    subpartition FPV201804 values (201804) tablespace FPV_DATA_2018,
    subpartition FPV201805 values (201805) tablespace FPV_DATA_2018,
    subpartition FPV201806 values (201806) tablespace FPV_DATA_2018,
    subpartition FPV201807 values (201807) tablespace FPV_DATA_2018,
    subpartition FPV201808 values (201808) tablespace FPV_DATA_2018,
    subpartition FPV201809 values (201809) tablespace FPV_DATA_2018,
    subpartition FPV201810 values (201810) tablespace FPV_DATA_2018,
    subpartition FPV201811 values (201811) tablespace FPV_DATA_2018,
    subpartition FPV201812 values (201812) tablespace FPV_DATA_2018
  ),
  partition FPV2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace EXDATA
    pctfree 10
    initrans 1
    maxtrans 255
  (
    subpartition FPV201901 values (201901) tablespace FPV_DATA_2019,
    subpartition FPV201902 values (201902) tablespace FPV_DATA_2019,
    subpartition FPV201903 values (201903) tablespace FPV_DATA_2019,
    subpartition FPV201904 values (201904) tablespace FPV_DATA_2019,
    subpartition FPV201905 values (201905) tablespace FPV_DATA_2019,
    subpartition FPV201906 values (201906) tablespace FPV_DATA_2019,
    subpartition FPV201907 values (201907) tablespace FPV_DATA_2019,
    subpartition FPV201908 values (201908) tablespace FPV_DATA_2019,
    subpartition FPV201909 values (201909) tablespace FPV_DATA_2019,
    subpartition FPV201910 values (201910) tablespace FPV_DATA_2019,
    subpartition FPV201911 values (201911) tablespace FPV_DATA_2019,
    subpartition FPV201912 values (201912) tablespace FPV_DATA_2019
  )
);
-- Add comments to the columns 
comment on column FACT_PAGE_VIEW_TEST.page_view_key
  is '���ID';
comment on column FACT_PAGE_VIEW_TEST.vid
  is '�û��ն�Ψһ��ʶ��';
comment on column FACT_PAGE_VIEW_TEST.device_key
  is '�û��ն�Ψһ��ʶkey';
comment on column FACT_PAGE_VIEW_TEST.ip
  is 'IP';
comment on column FACT_PAGE_VIEW_TEST.ip_geo_key
  is '����ҳ��KEY';
comment on column FACT_PAGE_VIEW_TEST.ip_int
  is 'ip����';
comment on column FACT_PAGE_VIEW_TEST.url
  is 'url';
comment on column FACT_PAGE_VIEW_TEST.page_key
  is 'ҳ��KEY';
comment on column FACT_PAGE_VIEW_TEST.page_name
  is 'ҳ������';
comment on column FACT_PAGE_VIEW_TEST.page_value
  is 'ҳ��ֵ';
comment on column FACT_PAGE_VIEW_TEST.last_page_key
  is '����ҳ��KEY';
comment on column FACT_PAGE_VIEW_TEST.hmsc_key
  is '������Դ����KEY';
comment on column FACT_PAGE_VIEW_TEST.hmsc
  is '������Դ����';
comment on column FACT_PAGE_VIEW_TEST.application_key
  is 'Ӧ��KEY';
comment on column FACT_PAGE_VIEW_TEST.application_name
  is 'Ӧ������';
comment on column FACT_PAGE_VIEW_TEST.visit_date_key
  is '����ʱ��key';
comment on column FACT_PAGE_VIEW_TEST.visit_date
  is '����ʱ��';
comment on column FACT_PAGE_VIEW_TEST.pagebegin_time
  is 'ҳ�����ʱ��';
comment on column FACT_PAGE_VIEW_TEST.pageend_time
  is 'ҳ���뿪ʱ��';
comment on column FACT_PAGE_VIEW_TEST.page_staytime_key
  is 'ҳ��ͣ��ʱ��key';
comment on column FACT_PAGE_VIEW_TEST.page_staytime
  is 'ҳ��ͣ��ʱ��';
comment on column FACT_PAGE_VIEW_TEST.member_key
  is '��ԱKEY';
comment on column FACT_PAGE_VIEW_TEST.visit_hour_key
  is '����ʱ��KEY';
comment on column FACT_PAGE_VIEW_TEST.visit_hour
  is 'Сʱ�ֶ�';
comment on column FACT_PAGE_VIEW_TEST.ver_key
  is '�汾key';
comment on column FACT_PAGE_VIEW_TEST.ver_name
  is '�汾����';
comment on column FACT_PAGE_VIEW_TEST.agent
  is '�ͻ���';
comment on column FACT_PAGE_VIEW_TEST.hmmd
  is '�ƹ�ý��';
comment on column FACT_PAGE_VIEW_TEST.hmpl
  is '���ϵ��';
comment on column FACT_PAGE_VIEW_TEST.hmkw
  is '���ؼ���';
comment on column FACT_PAGE_VIEW_TEST.hmci
  is '���Ψһ���';
comment on column FACT_PAGE_VIEW_TEST.visit_month
  is '�·�';
comment on column FACT_PAGE_VIEW_TEST.session_key
  is '�ỰKEY';
comment on column FACT_PAGE_VIEW_TEST.channel_key
  is 'Ӧ������KEY(DIM_APPLICATION.CHANNEL_KEY)';
comment on column FACT_PAGE_VIEW_TEST.ipgeo_key
  is 'IP��λkey';
-- Create/Recreate indexes 
create index FACT_PAGE_VIEW_IP_INT on FACT_PAGE_VIEW_TEST (IP_INT)
  nologging  local;
create index FPV_APP_KEY on FACT_PAGE_VIEW_TEST (APPLICATION_KEY)
  nologging  local;
create index FPV_DATE on FACT_PAGE_VIEW_TEST (VISIT_DATE_KEY)
  nologging  local;
create index FPV_DATETIME on FACT_PAGE_VIEW_TEST (VISIT_DATE)
  nologging  local;
create index FPV_HMSC on FACT_PAGE_VIEW_TEST (HMSC_KEY)
  nologging  local;
create index FPV_HOUR on FACT_PAGE_VIEW_TEST (VISIT_HOUR_KEY)
  nologging  local;
create index FPV_ID on FACT_PAGE_VIEW_TEST (ID)
  nologging  local;
create index FPV_MONTH on FACT_PAGE_VIEW_TEST (VISIT_MONTH)
  nologging  local;
create index FPV_PAGE_KEY on FACT_PAGE_VIEW_TEST (PAGE_KEY)
  nologging  local;
create index FPV_SESSION on FACT_PAGE_VIEW_TEST (SESSION_KEY)
  nologging  local;
create index FPV_STAT on FACT_PAGE_VIEW_TEST (VISIT_DATE_KEY, APPLICATION_KEY, LAST_PAGE_KEY)
  nologging  local;
create index FPV_VER on FACT_PAGE_VIEW_TEST (VER_KEY)
  nologging  local;
create index FPV_VISITOR on FACT_PAGE_VIEW_TEST (DEVICE_KEY, APPLICATION_KEY, ID)
  nologging  local;
create index FPV_VISITOR2 on FACT_PAGE_VIEW_TEST (ID, DEVICE_KEY, APPLICATION_KEY)
  nologging  local;
create index FPV_ZT on FACT_PAGE_VIEW_TEST (SESSION_KEY, VISIT_DATE, PAGE_KEY, PAGE_VALUE)
  nologging  local;
create index IPGEO_KEY_IDX on FACT_PAGE_VIEW_TEST (IPGEO_KEY)
  nologging  local;
create index IP_GEO_IDX on FACT_PAGE_VIEW_TEST (IP_GEO_KEY, PAGE_KEY)
  nologging  local;
