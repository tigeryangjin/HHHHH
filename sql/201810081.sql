--1.
SELECT A.TABLESPACE_NAME,
       A.FILE_ID,
       COUNT(1) CNT,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES
  FROM DBA_FREE_SPACE A
 WHERE A.TABLESPACE_NAME = 'BDUDATA00'
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
         where tablespace_name = 'BDUDATA00'
        union all
        select file_id,
               block_id,
               blocks,
               'Free Space',
               'Free Space',
               'Free Space',
               tablespace_name
          from dba_free_space
         where tablespace_name = 'BDUDATA00') mapping,
       dba_tablespaces tbs
 where tbs.tablespace_name = mapping.tablespace_name
   and mapping.file_id = 55
 order by mapping.file_id, mapping.block_id desc;

--3.
SELECT A.TABLE_OWNER,
       A.TABLE_NAME,
       A.PARTITION_NAME,
       'ALTER TABLE ' || A.TABLE_OWNER || '.' || A.TABLE_NAME ||
       ' MOVE PARTITION ' || A.PARTITION_NAME ||
       ' PARALLEL(DEGREE 4) NOLOGGING;' COL2
  FROM DBA_TAB_PARTITIONS A
 WHERE A.TABLE_NAME = 'FACT_VISITOR_REGISTER';

--4.
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
         WHERE A.table_name = 'FACT_VISITOR_REGISTER')
 ORDER BY A.INDEX_OWNER, A.INDEX_NAME, A.PARTITION_NAME;

SELECT * FROM DBA_INDEXES A WHERE A.table_name = 'FACT_VISITOR_REGISTER';
SELECT * FROM DBA_IND_PARTITIONS;
