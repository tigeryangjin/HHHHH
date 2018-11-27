--1.
SELECT A.TABLESPACE_NAME,
       A.FILE_ID,
       COUNT(1) CNT,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES
  FROM DBA_FREE_SPACE A
 WHERE A.TABLESPACE_NAME ='DB_LOGISTICS'
 GROUP BY A.TABLESPACE_NAME, A.FILE_ID
 ORDER BY 1, 4 desc, 2;
 
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
         where tablespace_name = 'DB_LOGISTICS'
        union all
        select file_id,
               block_id,
               blocks,
               'Free Space',
               'Free Space',
               'Free Space',
               tablespace_name
          from dba_free_space
         where tablespace_name = 'DB_LOGISTICS') mapping,
       dba_tablespaces tbs
 where tbs.tablespace_name = mapping.tablespace_name
   and mapping.file_id = 73
 order by mapping.file_id, mapping.block_id desc;
 
--3.
ALTER INDEX DW_USER.FAGSM_MEMBER_KEY REBUILD PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.FAGSM_MEMBER_KEY NOPARALLEL;

--4.
ALTER INDEX DW_USER.DATA_ACQUISITION_CUR_I1 REBUILD PARTITION P201804 PARALLEL(DEGREE 4);
ALTER INDEX DW_USER.DATA_ACQUISITION_CUR_I1 REBUILD PARTITION P201804 NOPARALLEL;
ALTER INDEX DW_USER.DATA_ACQUISITION_CUR_I1 REBUILD PARTITION P201803 PARALLEL(DEGREE 4);
ALTER INDEX DW_USER.DATA_ACQUISITION_CUR_I1 REBUILD PARTITION P201803 NOPARALLEL;



