--1.
SELECT *
  FROM DBA_TABLES A
 WHERE A.OWNER = 'DW_USER'
   AND A.TABLE_NAME LIKE 'DIM%'
   AND A.TABLESPACE_NAME <> 'DIM_DATA'
 ORDER BY A.NUM_ROWS DESC;

--2.普通表转移表空间
SELECT B.COL1, B.OWNER, B.TABLE_NAME, B.COL2
  FROM (SELECT 1 COL1,
                A.owner,
                A.TABLE_NAME,
                'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME ||
                ' MOVE TABLESPACE DIM_DATA PARALLEL(DEGREE 4) NOLOGGING;' COL2
           FROM DBA_TABLES A
          WHERE /*A.tablespace_name = 'BDUDATA00'
                                                                          AND*/
          A.PARTITIONED = 'NO'
         UNION ALL
         SELECT 2 COL1,
                A.owner,
                A.TABLE_NAME,
                'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
                ' REBUILD TABLESPACE DIM_INDEX PARALLEL(DEGREE 4) NOLOGGING;' COL2
           FROM DBA_INDEXES A
          WHERE /*A.tablespace_name = 'BDUDATA00'
                                                                          AND*/
          A.partitioned = 'NO'
       AND A.INDEX_TYPE = 'NORMAL'
         UNION ALL
         SELECT 3 COL1,
                A.owner,
                A.TABLE_NAME,
                'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
                ' NOPARALLEL;' COL2
           FROM DBA_INDEXES A
          WHERE /*A.tablespace_name = 'BDUDATA00'
                                                                          AND*/
          A.partitioned = 'NO'
       AND A.INDEX_TYPE = 'NORMAL') B
 WHERE B.TABLE_NAME = 'DIM_VOUCHER_GOODS'
   AND B.OWNER = 'DW_USER'
/*AND EXISTS (SELECT 1
 FROM DBA_SEGMENTS C
WHERE B.TABLE_NAME = C.segment_name
  AND C.tablespace_name <> 'DIM_DATA')*/
 ORDER BY B.OWNER, B.TABLE_NAME, B.COL1;

--3.子分区索引转移
SELECT A.INDEX_OWNER,
       A.INDEX_NAME,
       A.subpartition_name,
       'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
       ' REBUILD SUBPARTITION ' || A.subpartition_name ||
       ' TABLESPACE FPV_INDEX PARALLEL(DEGREE 4);' COL1
  FROM DBA_IND_SUBPARTITIONS A
 WHERE A.INDEX_NAME IN
       (SELECT A.INDEX_NAME
          FROM DBA_INDEXES A
         WHERE A.table_name = 'FACT_PAGE_VIEW')
   AND A.INDEX_NAME = 'FPV_PAGE_KEY'
 ORDER BY A.INDEX_OWNER, A.INDEX_NAME, A.subpartition_name;

--4.

--TMP
SELECT DISTINCT A.segment_name
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name ='FPV_INDEX';
