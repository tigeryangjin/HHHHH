--1.
SELECT A.TABLESPACE_NAME,
       A.FILE_ID,
       COUNT(1) CNT,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES
  FROM DBA_FREE_SPACE A
 WHERE A.TABLESPACE_NAME = 'SYSAUX'
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
         where tablespace_name = 'SYSTEM'
        union all
        select file_id,
               block_id,
               blocks,
               'Free Space',
               'Free Space',
               'Free Space',
               tablespace_name
          from dba_free_space
         where tablespace_name = 'SYSTEM') mapping,
       dba_tablespaces tbs
 where tbs.tablespace_name = mapping.tablespace_name
   and mapping.file_id = 1
 order by mapping.file_id, mapping.block_id desc;

--2.1
ALTER INDEX I_COL1 REBUILD;
 
--3.
SELECT A.segment_name, A.segment_type, SUM(A.bytes)/1024/1024 mb_bytes
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'SYSAUX'
 GROUP BY A.segment_name, A.segment_type
 ORDER BY 3 DESC;
 
--4.
SELECT B.COL1, B.OWNER, B.TABLE_NAME, B.COL2
  FROM (SELECT 1 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME ||
               ' MOVE;' COL2
          FROM DBA_TABLES A
         WHERE A.tablespace_name = 'DW_USER'
           AND A.PARTITIONED = 'NO'
        UNION ALL
        SELECT 2 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' REBUILD;' COL2
          FROM DBA_INDEXES A
         WHERE A.tablespace_name = 'DW_USER'
           AND A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL'
        UNION ALL
        SELECT 3 COL1,
               A.owner,
               A.TABLE_NAME,
               'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
               ' NOPARALLEL;' COL2
          FROM DBA_INDEXES A
         WHERE A.tablespace_name = 'DW_USER'
           AND A.partitioned = 'NO'
           AND A.INDEX_TYPE = 'NORMAL') B
 WHERE B.TABLE_NAME = 'FACT_HMSC_ITEM_AREA_MARKET'
 ORDER BY B.OWNER, B.TABLE_NAME, B.COL1;

--5.
ALTER TABLE SYS.IDL_UB1$ MOVE;
ALTER INDEX SYS.I_IDL_UB11 REBUILD;
ALTER INDEX SYS.I_IDL_UB11 NOPARALLEL;

--tmp
select 201326592/1024/1024 from dual;