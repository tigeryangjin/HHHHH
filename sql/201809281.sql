--2.
SELECT B.COL1, B.OWNER, B.TABLE_NAME, B.COL2
  FROM (SELECT 1 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME ||
               ' MOVE PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_TABLES A
         WHERE A.tablespace_name = 'DB_LOGISTICS'
           AND A.PARTITIONED = 'NO'
        UNION ALL
        SELECT 2 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' REBUILD PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_INDEXES A
         WHERE A.tablespace_name = 'DB_LOGISTICS'
           AND A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL'
        UNION ALL
        SELECT 3 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' NOPARALLEL;' COL2
          FROM DBA_INDEXES A
         WHERE A.tablespace_name = 'DB_LOGISTICS'
           AND A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL') B
 WHERE B.TABLE_NAME = '&tb'
 ORDER BY B.OWNER, B.TABLE_NAME, B.COL1;
