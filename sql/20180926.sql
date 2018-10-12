--1.
SELECT A.segment_name,
       A.segment_type,
       A.partition_name,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES,
       SUM(A.extents) E
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'BIINDEX01'
   --AND A.segment_type = 'TABLE'
 GROUP BY A.segment_name, A.segment_type, A.partition_name
 ORDER BY SUM(A.BYTES) DESC;

--2.
SELECT B.COL1, B.COL2
  FROM (SELECT 1 COL1,
               'ALTER TABLE ' || A.TABLE_NAME ||
               ' MOVE TABLESPACE EXDATA PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_TABLES A
         WHERE A.TABLE_NAME = '&tn'
        UNION ALL
        SELECT 2 COL1,
               'ALTER INDEX ' || A.index_name ||
               ' REBUILD TABLESPACE EXDATA PARALLEL(DEGREE 4) NOLOGGING;'
          FROM DBA_INDEXES A
         WHERE A.table_name = '&tn'
        UNION ALL
        SELECT 3 COL1, 'ALTER INDEX ' || A.index_name || ' NOPARALLEL;'
          FROM DBA_INDEXES A
         WHERE A.table_name = '&tn') B
 ORDER BY B.COL1;
