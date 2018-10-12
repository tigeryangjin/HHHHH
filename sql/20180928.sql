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

SELECT A.owner,
       A.segment_name,
       A.segment_type,
       SUM(A.extents) EXT,
       SUM(A.BYTES) / 1024 / 1024 MB
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'DB_LOGISTICS'
 GROUP BY A.owner, A.segment_name, A.segment_type
 ORDER BY 5 DESC;
