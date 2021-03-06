--1.
SELECT A.FILE_ID, COUNT(1), sum(a.BYTES) / 1024 / 1024 mb
  FROM DBA_FREE_SPACE A
 WHERE A.TABLESPACE_NAME = 'DWDATA00'
 group by A.FILE_ID;
--2.
SELECT A.owner,
       A.segment_name,
       A.segment_type,
       SUM(A.BYTES) / 1024 / 1024 MB,
       SUM(A.extents) EXT
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'DWDATA00'
 GROUP BY A.owner, A.segment_name, A.segment_type
 ORDER BY SUM(A.extents) DESC;

SELECT *
  FROM DBA_EXTENTS A
 WHERE A.segment_name = 'DATA_ACQUISITION_ITEM';
 
SELECT * FROM DBA_DATA_FILES A;

--3.
SELECT B.COL1, B.OWNER, B.TABLE_NAME, B.COL2
  FROM (SELECT 1 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME ||
               ' MOVE PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_TABLES A
         WHERE A.tablespace_name = 'DWDATA00'
           AND A.PARTITIONED = 'NO'
        UNION ALL
        SELECT 2 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' REBUILD PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_INDEXES A
         WHERE A.tablespace_name = 'DWDATA00'
           AND A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL'
        UNION ALL
        SELECT 3 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' NOPARALLEL;' COL2
          FROM DBA_INDEXES A
         WHERE A.tablespace_name = 'DWDATA00'
           AND A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL') B
 WHERE B.TABLE_NAME = 'STATS_ONLINE_GOOD2_MINUTE'
 ORDER BY B.OWNER, B.TABLE_NAME, B.COL1;
