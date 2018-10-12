--��ռ�Ǩ��move
--1.��ͨ��
SELECT B.COL1, B.OWNER, B.TABLE_NAME, B.COL2
  FROM (SELECT 1 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME ||
               ' MOVE TABLESPACE DWDATA00 PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_TABLES A
         WHERE A.tablespace_name = 'EXDATA'
           AND A.PARTITIONED = 'NO'
        UNION ALL
        SELECT 2 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' REBUILD TABLESPACE DWDATA00 PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_INDEXES A
         WHERE A.tablespace_name = 'EXDATA'
           AND A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL'
        UNION ALL
        SELECT 3 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' NOPARALLEL;' COL2
          FROM DBA_INDEXES A
         WHERE A.tablespace_name = 'EXDATA'
           AND A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL') B
 ORDER BY B.OWNER, B.TABLE_NAME, B.COL1;

--2.������
SELECT 1 COL1,
       A.TABLE_OWNER,
       A.TABLE_NAME,
       A.PARTITION_NAME,
       'ALTER TABLE ' || A.TABLE_OWNER || '.' || A.TABLE_NAME ||
       ' MOVE PARTITION ' || A.PARTITION_NAME ||
       ' TABLESPACE DWDATA02 PARALLEL(DEGREE 4) NOLOGGING;' COL2
  FROM DBA_TAB_PARTITIONS A
 WHERE A.TABLESPACE_NAME = 'EXDATA';

--3.��������
SELECT 'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
       ' REBUILD PARTITION ' || A.PARTITION_NAME ||
       ' TABLESPACE BIINDEX01 PARALLEL(DEGREE 4) NOLOGGING;' COL1
  FROM DBA_IND_PARTITIONS A
 WHERE A.TABLESPACE_NAME = 'EXDATA'
   AND A.INDEX_NAME IN ('MR_APK',
                        'MR_DK',
                        'MR_HDK',
                        'MR_HMK',
                        'MR_HTK',
                        'MR_IGK',
                        'MR_MDK',
                        'MR_MID',
                        'MR_MK',
                        'MR_RDK',
                        'MR_RTK');

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
