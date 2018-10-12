--1.
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
         where tablespace_name = 'BIINDEX01'
        union all
        select file_id,
               block_id,
               blocks,
               'Free Space',
               'Free Space',
               'Free Space',
               tablespace_name
          from dba_free_space
         where tablespace_name = 'BIINDEX01') mapping,
       dba_tablespaces tbs
 where tbs.tablespace_name = mapping.tablespace_name
   --and mapping.file_id = 119
 order by mapping.file_id, mapping.block_id desc;

--2.
SELECT COUNT(1), SUM(A.BYTES) / 1024 / 1024 / 1024 GB_BYTES
  FROM DBA_FREE_SPACE A
 WHERE A.TABLESPACE_NAME = 'BIINDEX01';

SELECT *
  FROM DBA_EXTENTS A
 WHERE A.segment_name = 'DATA_ACQUISITION_WEEK_NEW';

--3.
SELECT A.segment_name,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES,
       SUM(A.extents) E
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'BIINDEX01'
--AND A.segment_type = 'TABLE'
 GROUP BY A.segment_name
 ORDER BY SUM(A.extents) DESC;

--4.
SELECT 'ALTER INDEX ' || A.segment_name || ' REBUILD PARTITION ' ||
       A.partition_name || ' PARALLEL(DEGREE 4) NOLOGGING;'
  FROM DBA_SEGMENTS A
 WHERE A.segment_name = 'FACT_SESSION_FIST_IP'
 ORDER BY A.partition_name;

--5.
SELECT 'ALTER INDEX ' || A.index_name ||
       ' REBUILD PARALLEL(DEGREE 4) NOLOGGING;'
  FROM DBA_INDEXES A
 WHERE A.table_name = 'FACT_SHOPPINGCAR'
UNION ALL
SELECT 'ALTER INDEX ' || A.index_name || ' NOPARALLEL;'
  FROM DBA_INDEXES A
 WHERE A.table_name = 'FACT_SHOPPINGCAR';

alter tablespace dwdata01 coalesce;

--6.
select file_id, COUNT(1), SUM(A.BYTES) / 1024 / 1024 / 1024 GB_BYTES
  from dba_free_space A
 where A.tablespace_name = 'BIINDEX01'
 GROUP BY file_id
 ORDER BY 3 DESC;

--tmp
SELECT *
  FROM DBA_EXTENTS A
 WHERE A.segment_name = 'GOOD2ID_IDX';
SELECT A.segment_name,
       A.segment_type,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES,
       SUM(A.extents) e
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'BIINDEX01'
 GROUP BY A.segment_name, A.segment_type
 ORDER BY 2;

SELECT * FROM DBA_DATA_FILES;

SELECT * FROM DBA_INDEXES A WHERE A.status = 'UNUSABLE';
SELECT * FROM DBA_IND_PARTITIONS A WHERE A.STATUS = 'UNUSABLE';
