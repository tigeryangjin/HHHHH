--1.
SELECT A.TABLESPACE_NAME,
       A.FILE_ID,
       COUNT(1) CNT,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES
  FROM DBA_FREE_SPACE A
 WHERE A.TABLESPACE_NAME = 'BDUDATA02'
 GROUP BY A.TABLESPACE_NAME, A.FILE_ID
 ORDER BY 3 DESC;

--2.
select mapping.file_id,
       mapping.block_id,
       mapping.blocks,
       (mapping.blocks * tbs.block_size) / 1024 / 1024 size_mb,
       mapping.segment_name,
       mapping.segment_type,
       mapping.partition_name
  from (select file_id,
               block_id,
               blocks,
               segment_name,
               segment_type,
               partition_name,
               tablespace_name
          from dba_extents
         where tablespace_name = 'BDUDATA02'
        union all
        select file_id,
               block_id,
               blocks,
               'Free Space',
               'Free Space',
               'Free Space',
               tablespace_name
          from dba_free_space
         where tablespace_name = 'BDUDATA02') mapping,
       dba_tablespaces tbs
 where tbs.tablespace_name = mapping.tablespace_name
   and mapping.file_id = 109
 order by mapping.file_id, mapping.block_id desc;

--3.分区表
SELECT A.TABLE_OWNER,
       A.TABLE_NAME,
       A.PARTITION_NAME,
       'ALTER TABLE ' || A.TABLE_OWNER || '.' || A.TABLE_NAME ||
       ' MOVE PARTITION ' || A.PARTITION_NAME ||
       ' PARALLEL(DEGREE 4) NOLOGGING;' COL2
  FROM DBA_TAB_PARTITIONS A
 WHERE A.TABLE_NAME = 'FACT_MEMBER_REGISTER';

--4.分区索引
SELECT A.INDEX_OWNER,
       A.INDEX_NAME,
       A.PARTITION_NAME,
       'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
       ' REBUILD PARTITION ' || A.PARTITION_NAME ||
       ' PARALLEL(DEGREE 4) NOLOGGING;' COL1
  FROM DBA_IND_PARTITIONS A
 WHERE A.SUBPARTITION_COUNT = 0
   AND A.INDEX_NAME IN
       (SELECT A.INDEX_NAME
          FROM DBA_INDEXES A
         WHERE A.table_name = 'FACT_PAGE_VIEW')
 ORDER BY A.INDEX_OWNER, A.INDEX_NAME, A.PARTITION_NAME;

--5.子分区索引
SELECT A.INDEX_OWNER,
       A.INDEX_NAME,
       A.subpartition_name,
       'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
       ' REBUILD TABLESPACE FPV_INDEX PARTITION ' || A.subpartition_name ||
       ' PARALLEL(DEGREE 4) NOLOGGING;' COL1
  FROM DBA_IND_SUBPARTITIONS A
 WHERE A.INDEX_NAME IN
       (SELECT A.INDEX_NAME
          FROM DBA_INDEXES A
         WHERE A.table_name = 'FACT_PAGE_VIEW')
   AND A.INDEX_NAME = 'IP_GEO_IDX'
 ORDER BY A.INDEX_OWNER, A.INDEX_NAME, A.subpartition_name;

--6.普通表
SELECT B.COL1, B.OWNER, B.TABLE_NAME, B.COL2
  FROM (SELECT 1 COL1,
                A.owner,
                A.TABLE_NAME,
                'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME ||
                ' MOVE PARALLEL(DEGREE 4) NOLOGGING;' COL2
           FROM DBA_TABLES A
          WHERE A.tablespace_name = 'BDUDATA00'
            AND A.PARTITIONED = 'NO'
         UNION ALL
         SELECT 2 COL1,
                A.owner,
                A.TABLE_NAME,
                'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
                ' REBUILD PARALLEL(DEGREE 4) NOLOGGING;' COL2
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
 WHERE B.TABLE_NAME = 'FACT_VISITOR_ACTIVE'
 ORDER BY B.OWNER, B.TABLE_NAME, B.COL1;

SELECT * FROM DBA_INDEXES A WHERE A.table_name = 'FACT_VISITOR_REGISTER';
SELECT * FROM DBA_IND_PARTITIONS;
