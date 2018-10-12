--1.创建临时表
CREATE TABLE DW_USER.DATA_ACQUISITION_ITEM_BASE_TMP  PARTITION BY RANGE (PERIOD)
(PARTITION P201612 VALUES LESS THAN (20170101),
 PARTITION P201701 VALUES LESS THAN (20170201),
 PARTITION P201702 VALUES LESS THAN (2017-03-01),
 PARTITION P201703 VALUES LESS THAN (2017-04-01),
 PARTITION P201704 VALUES LESS THAN (2017-05-01),
 PARTITION P201705 VALUES LESS THAN (2017-06-01),
 PARTITION P201706 VALUES LESS THAN (2017-07-01),
 PARTITION P201707 VALUES LESS THAN (2017-08-01),
 PARTITION P201708 VALUES LESS THAN (2017-09-01),
 PARTITION P201709 VALUES LESS THAN (2017-10-01),
 PARTITION P201710 VALUES LESS THAN (2017-11-01),
 PARTITION P201711 VALUES LESS THAN (2017-12-01),
 PARTITION PMAX VALUES LESS THAN (MAXVALUE))
 AS SELECT *
FROM DW_USER.DATA_ACQUISITION_ITEM_BASE T WHERE 1=2;


--2.检查表能够被重定义
BEGIN
  DBMS_REDEFINITION.CAN_REDEF_TABLE('DW_USER',
                                    'DATA_ACQUISITION_ITEM_BASE',
                                    DBMS_REDEFINITION.CONS_USE_PK);
END;
/


--3.开始重定义
ALTER SESSION FORCE PARALLEL DML PARALLEL 8;
ALTER SESSION FORCE PARALLEL QUERY PARALLEL 8;
BEGIN
  DBMS_REDEFINITION.START_REDEF_TABLE(UNAME        => 'DW_USER',
                                      ORIG_TABLE   => 'DATA_ACQUISITION_ITEM_BASE',
                                      INT_TABLE    => 'DATA_ACQUISITION_ITEM_BASE_TMP',
                                      COL_MAPPING  => 'PERIOD PERIOD,
                       MATDLT MATDLT,
                       MATZLT MATZLT,
                       MATXLT MATXLT,
                       ACQ_ITEM_CODE ACQ_ITEM_CODE,
                       ACQ_NAME ACQ_NAME,
                       ACQ_URL ACQ_URL,
                       ACQ_PIC ACQ_PIC,
                       ACQ_SHOP_NAME ACQ_SHOP_NAME,
                       ACQ_PRICE ACQ_PRICE,
                       ACQ_SALES ACQ_SALES,
                       SALES_AMT SALES_AMT',
                                      OPTIONS_FLAG => DBMS_REDEFINITION.CONS_USE_PK);
END;
/

--3.1.终止重定义
BEGIN
  DBMS_REDEFINITION.ABORT_REDEF_TABLE('DW_USER', 'DATA_ACQUISITION_ITEM_BASE', 'DATA_ACQUISITION_ITEM_BASE_TMP');
END;
/

--4.将重定义表的依赖对象复制到临时表
DECLARE
  num_errors PLS_INTEGER;
BEGIN
  DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS('DW_USER',
                                          'DATA_ACQUISITION_ITEM_BASE',
                                          'DATA_ACQUISITION_ITEM_BASE_TMP',
                                          DBMS_REDEFINITION.CONS_ORIG_PARAMS,
                                          TRUE,
                                          TRUE,
                                          TRUE,
                                          TRUE,
                                          num_errors);
END;
/

--5.检查是否有报错信息
SELECT OBJECT_NAME, BASE_TABLE_NAME, DDL_TXT FROM DBA_REDEFINITION_ERRORS;

--6.结束在线重定义
BEGIN
  DBMS_REDEFINITION.FINISH_REDEF_TABLE('DW_USER',
                                       'DATA_ACQUISITION_ITEM_BASE',
                                       'DATA_ACQUISITION_ITEM_BASE_TMP');
END;
/


--7.
SELECT 'ALTER TABLE ' || TABLE_NAME || ' MOVE PARTITION ' || PARTITION_NAME ||
       ' TABLESPACE DWDATA00 PARALLEL 4;'
  FROM USER_TAB_PARTITIONS
 WHERE TABLE_NAME = 'DATA_ACQUISITION_ITEM_BASE';
 
--8.
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'DW_USER',
                                TABNAME => 'DATA_ACQUISITION_ITEM_BASE',
                                DEGREE  => 16,
                                --PARTNAME         => 'p_201312',
                                --ESTIMATE_PERCENT => 10,
                                --METHOD_OPT       => 'for all indexed columns',
                                CASCADE => TRUE);
END;
/

--9.




SELECT * FROM DATA_ACQUISITION_ITEM_BASE A;
SELECT * FROM DATA_ACQUISITION_ITEM_BASE_TMP;


