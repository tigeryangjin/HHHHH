--表空间迁移move
--1.普通表
SELECT B.COL1, B.OWNER, B.TABLE_NAME, B.COL2
  FROM (SELECT 1 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME ||
               ' MOVE TABLESPACE DWDATA00 PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_TABLES A
         WHERE A.PARTITIONED = 'NO'
        UNION ALL
        SELECT 2 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' REBUILD TABLESPACE DWDATA00 PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_INDEXES A
         WHERE A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL'
        UNION ALL
        SELECT 3 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' NOPARALLEL;' COL2
          FROM DBA_INDEXES A
         WHERE A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL') B
 WHERE B.TABLE_NAME = 'FACT_MEMBER_PAGE_ORDER'
 ORDER BY B.OWNER, B.TABLE_NAME, B.COL1;

--2.分区表
SELECT *
  FROM (SELECT A.TABLE_OWNER OWNER,
               A.TABLE_NAME OBJECT_NAME,
               A.PARTITION_NAME,
               1 COL1,
               'ALTER TABLE ' || A.TABLE_OWNER || '.' || A.TABLE_NAME ||
               ' MOVE PARTITION ' || A.PARTITION_NAME ||
               ' PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_TAB_PARTITIONS A
         WHERE A.TABLE_NAME = 'FACT_MEMBER_REGISTER'
        UNION ALL
        SELECT A.INDEX_OWNER OWNER,
               A.INDEX_NAME OBJECT_NAME,
               A.PARTITION_NAME,
               2 COL1,
               'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
               ' REBUILD PARTITION ' || A.PARTITION_NAME ||
               ' PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_IND_PARTITIONS A
         WHERE A.SUBPARTITION_COUNT = 0
           AND A.INDEX_NAME IN
               (SELECT A.INDEX_NAME
                  FROM DBA_INDEXES A
                 WHERE A.table_name = 'FACT_MEMBER_REGISTER')
        UNION ALL
        SELECT A.INDEX_OWNER OWNER,
               A.INDEX_NAME OBJECT_NAME,
               A.PARTITION_NAME,
               3 COL1,
               'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
               ' REBUILD PARTITION ' || A.PARTITION_NAME || ' NOPARALLEL;' COL2
          FROM DBA_IND_PARTITIONS A
         WHERE A.SUBPARTITION_COUNT = 0
           AND A.INDEX_NAME IN
               (SELECT A.INDEX_NAME
                  FROM DBA_INDEXES A
                 WHERE A.table_name = 'FACT_MEMBER_REGISTER')) B
 ORDER BY B.OWNER, B.PARTITION_NAME, B.OBJECT_NAME, B.COL1;

--4.子分区表
SELECT *
  FROM (SELECT A.TABLE_OWNER OWNER,
               A.TABLE_NAME OBJECT_NAME,
               A.SUBPARTITION_NAME,
               1 COL1,
               'ALTER TABLE ' || A.TABLE_OWNER || '.' || A.TABLE_NAME ||
               ' MOVE SUBPARTITION ' || A.SUBPARTITION_NAME ||
               ' PARALLEL(DEGREE 4);' COL2
          FROM DBA_TAB_SUBPARTITIONS A
         WHERE A.TABLE_NAME = 'FACT_PAGE_VIEW'
        UNION ALL
        SELECT A.INDEX_OWNER OWNER,
               A.INDEX_NAME OBJECT_NAME,
               A.SUBPARTITION_NAME,
               2 COL1,
               'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
               ' REBUILD SUBPARTITION ' || A.SUBPARTITION_NAME ||
               ' PARALLEL(DEGREE 4);' COL2
          FROM DBA_IND_SUBPARTITIONS A
         WHERE A.INDEX_NAME IN
               (SELECT A.INDEX_NAME
                  FROM DBA_INDEXES A
                 WHERE A.table_name = 'FACT_PAGE_VIEW')
        UNION ALL
        SELECT A.INDEX_OWNER OWNER,
               A.INDEX_NAME OBJECT_NAME,
               A.SUBPARTITION_NAME,
               3 COL1,
               'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
               ' REBUILD SUBPARTITION ' || A.SUBPARTITION_NAME ||
               ' NOPARALLEL;' COL2
          FROM DBA_IND_SUBPARTITIONS A
         WHERE A.INDEX_NAME IN
               (SELECT A.INDEX_NAME
                  FROM DBA_INDEXES A
                 WHERE A.table_name = 'FACT_PAGE_VIEW')) B
 ORDER BY B.OWNER, B.SUBPARTITION_NAME, B.OBJECT_NAME, B.COL1;

--4.LOB
SELECT 'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME || ' MOVE LOB (' ||
       A.COLUMN_NAME || ') STORE AS (TABLESPACE DWDATA02);' COL1
  FROM DBA_LOBS A
 WHERE A.TABLESPACE_NAME = 'EXDATA';

--tmp
SELECT *
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'EXDATA'
 ORDER BY A.owner, A.segment_type, A.segment_name;

ALTER TABLE DW_HAPPIGO.R_JOB_LOCK MOVE LOB(LOCK_MESSAGE) STORE AS(TABLESPACE
                                                                  EXDATA);

ALTER INDEX FCTIME_IDX REBUILD TABLESPACE BIINDEX01 PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX FCTIME_IDX NOPARALLEL;

ALTER TABLE ODS_PAGEVIEW MOVE PARALLEL(DEGREE 4) NOLOGGING;
