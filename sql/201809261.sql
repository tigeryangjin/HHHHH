--2.
SELECT c.TABLE_NAME,
       c.COL1,
       c.COL2,
       rank() over(partition by c.table_name order by c.col1) rn
  FROM (SELECT a.TABLE_NAME,
               1 col1,
               'ALTER TABLE ' || A.TABLE_NAME ||
               ' MOVE TABLESPACE EXDATA PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_TABLES A
         WHERE EXISTS (SELECT 1
                  FROM YANGJIN.DWDATA00_TABLE_LIST B
                 WHERE A.TABLE_NAME = B.SEGMENT_NAME)
        UNION ALL
        SELECT a.TABLE_NAME,
               2 col1,
               'ALTER INDEX ' || A.index_name ||
               ' REBUILD TABLESPACE EXDATA PARALLEL(DEGREE 4) NOLOGGING;'
          FROM DBA_INDEXES A
         WHERE EXISTS (SELECT 1
                  FROM YANGJIN.DWDATA00_TABLE_LIST B
                 WHERE A.TABLE_NAME = B.SEGMENT_NAME)
        UNION ALL
        SELECT a.TABLE_NAME,
               3 col1,
               'ALTER INDEX ' || A.index_name || ' NOPARALLEL;'
          FROM DBA_INDEXES A
         WHERE EXISTS (SELECT 1
                  FROM YANGJIN.DWDATA00_TABLE_LIST B
                 WHERE A.TABLE_NAME = B.SEGMENT_NAME)) c
 ORDER BY c.COL1;
