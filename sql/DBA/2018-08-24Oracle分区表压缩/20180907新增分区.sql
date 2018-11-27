--1.
SELECT * FROM ALL_ALL_TABLES A WHERE A.PARTITIONED='YES';
/*
DW_USER FACT_SESSION
DW_USER DATA_ACQUISITION_ITEM
DW_USER MEMBER_LABEL_LINK
DW_USER FACT_MEMBER_REGISTER
DW_USER DATA_ACQUISITION_ITEM_CURRENT
DW_USER FACT_PAGE_VIEW
DW_USER FACT_VISITOR_REGISTER
DW_USER DATA_ACQUISITION_ITEM_BASE
*/

--2.FACT_MEMBER_REGISTER
ALTER TABLE FACT_MEMBER_REGISTER ADD PARTITION MR7
VALUES LESS THAN (TO_DATE('2022-01-01','YYYY-MM-DD')) 
TABLESPACE DWDATA00
 PCTFREE 10
    INITRANS 1
    MAXTRANS 255
    STORAGE
    (
      INITIAL 10M
      MINEXTENTS 1
      MAXEXTENTS UNLIMITED
    );



--3.DATA_ACQUISITION_ITEM_CURRENT

--4.FACT_PAGE_VIEW
ALTER TABLE FACT_PAGE_VIEW ADD PARTITION FPV2019
VALUES LESS THAN (TO_DATE('2020-01-01','YYYY-MM-DD')) 
TABLESPACE DWDATA01
 PCTFREE 10
    INITRANS 1
    MAXTRANS 255
    STORAGE
    (
      INITIAL 10M
      MINEXTENTS 1
      MAXEXTENTS UNLIMITED
    );

--4.1.新增子分区
ALTER TABLE FACT_PAGE_VIEW
MODIFY PARTITION FPV2018
ADD SUBPARTITION FPV201812 VALUES(201812) TABLESPACE BDUDATA03; 

--4.2.删除子分区
ALTER TABLE FACT_PAGE_VIEW DROP SUBPARTITION FPV2019_FPV201701;

--4.3.删除分区
ALTER TABLE FACT_PAGE_VIEW DROP PARTITION FPV2019;

--4.4.新增分区以及子分区
ALTER TABLE FACT_PAGE_VIEW ADD PARTITION FPV2019 
VALUES LESS THAN (TO_DATE('2020-01-01','YYYY-MM-DD'))  
TABLESPACE BDUDATA04 
(SUBPARTITION FPV201901 VALUES(201901) TABLESPACE BDUDATA04); 

--4.5.设置索引的默认表空间
alter index FACT_PAGE_VIEW_IP_INT modify default attributes tablespace fpv_index;
alter index FPV_VISITOR2 modify default attributes tablespace fpv_index;
alter index IP_GEO_IDX modify default attributes tablespace fpv_index;
alter index FPV_MONTH modify default attributes tablespace fpv_index;
alter index FPV_VISITOR modify default attributes tablespace fpv_index;
alter index FPV_STAT modify default attributes tablespace fpv_index;
alter index FPV_ZT modify default attributes tablespace fpv_index;
alter index FPV_DATETIME modify default attributes tablespace fpv_index;
alter index FPV_ID modify default attributes tablespace fpv_index;
alter index FPV_APP_KEY modify default attributes tablespace fpv_index;
alter index FPV_DATE modify default attributes tablespace fpv_index;
alter index FPV_HMSC modify default attributes tablespace fpv_index;
alter index FPV_HOUR modify default attributes tablespace fpv_index;
alter index FPV_PAGE_KEY modify default attributes tablespace fpv_index;
alter index FPV_SESSION modify default attributes tablespace fpv_index;
alter index FPV_VER modify default attributes tablespace fpv_index;
alter index IPGEO_KEY_IDX modify default attributes tablespace fpv_index;

--5.FACT_VISITOR_REGISTER
ALTER TABLE FACT_VISITOR_REGISTER ADD PARTITION VR5
VALUES LESS THAN (TO_DATE('2020-01-01','YYYY-MM-DD')) 
TABLESPACE BDUDATA00
 PCTFREE 10
    INITRANS 1
    MAXTRANS 255
    STORAGE
    (
      INITIAL 10M
      MINEXTENTS 1
      MAXEXTENTS UNLIMITED
    );


--6.DATA_ACQUISITION_ITEM_BASE
