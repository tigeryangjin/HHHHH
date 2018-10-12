-- Create table
DROP TABLE TABLE_PAR;
create table TABLE_PAR
(
  DATE_KEY        NUMBER(10) not null,
	COLA            VARCHAR(200)
	
)
partition by range (DATE_KEY)
(
  partition D201701 values less than (20170201)
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
  partition D201702 values less than (20170301)
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
  partition D201703 values less than (20170401)
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
  partition D201704 values less than (20170501)
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
  partition D201705 values less than (20170601)
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
  partition D201706 values less than (20170701)
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
  partition D201707 values less than (20170801)
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
  partition D201708 values less than (20170901)
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
  partition D201709 values less than (20171001)
    tablespace DWDATA00
    pctfree 0
    initrans 1
    maxtrans 255
    storage
    (
      initial 64K
      next 1M
      minextents 1
      maxextents unlimited
    ),
  partition D201710 values less than (20171101)
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
  partition D201711 values less than (20171201)
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
  partition D201712 values less than (20180101)
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
  partition DMAX values less than (MAXVALUE)
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

--insert
TRUNCATE TABLE YANGJIN.TABLE_PAR;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170101 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170201 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170301 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170401 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170501 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170601 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170701 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170801 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20170901 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20171001 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20171101 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;
INSERT INTO YANGJIN.TABLE_PAR
  SELECT 20171201 DATE_KEY, A.owner || A.table_name COLA
    FROM ALL_ALL_TABLES A;
COMMIT;

--3.
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'YANGJIN',
                                TABNAME => 'TABLE_PAR',
                                DEGREE  => 4,
                                CASCADE => TRUE);
END;
/
ANALYZE TABLE TABLE_PAR COMPUTE STATISTICS;

--ѹ������
ALTER TABLE TABLE_PAR MOVE PARTITION D201701 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201702 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201703 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201704 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201705 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201706 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201707 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201708 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201709 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201710 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201711 COMPRESS PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201712 COMPRESS PARALLEL 10;

--��ѹ����
ALTER TABLE TABLE_PAR MOVE PARTITION D201701 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201702 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201703 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201704 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201705 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201706 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201707 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201708 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201709 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201710 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201711 NOCOMPRESS  PARALLEL 10;
ALTER TABLE TABLE_PAR MOVE PARTITION D201712 NOCOMPRESS  PARALLEL 10;

--
ALTER TABLE TABLE_PAR ENABLE ROW MOVEMENT;
ALTER TABLE TABLE_PAR SHRINK SPACE;
ALTER TABLE TABLE_PAR DISABLE ROW MOVEMENT;

SELECT *
  FROM DBA_SEGMENTS A
 WHERE A.OWNER = 'YANGJIN'
   AND A.SEGMENT_NAME = 'TABLE_PAR';

SELECT *
  FROM DBA_EXTENTS A
 WHERE A.OWNER = 'YANGJIN'
   AND A.SEGMENT_NAME = 'TABLE_PAR';

SELECT *
  FROM DBA_TABLES A
 WHERE A.OWNER = 'YANGJIN'
   AND A.TABLE_NAME = 'TABLE_PAR';
