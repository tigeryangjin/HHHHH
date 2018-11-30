--1.表空间碎片，如果FSFI值 < 30%，则该表空间的碎片较多。
select a.tablespace_name,
       sqrt(max(a.blocks) / sum(a.blocks)) *
       (100 / sqrt(sqrt(count(a.blocks)))) FSFI
  from dba_free_space a, dba_tablespaces b
 where a.tablespace_name = b.tablespace_name
   and b.contents not in ('TEMPORARY', 'UNDO')
 group by a.tablespace_name
 order by FSFI;

--1.1数据文件空闲空间
SELECT A.TABLESPACE_NAME,
       A.FILE_ID,
       COUNT(1) CNT,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES
  FROM DBA_FREE_SPACE A
WHERE A.TABLESPACE_NAME = 'FPV_DATA_2015'
 GROUP BY A.TABLESPACE_NAME, A.FILE_ID
 ORDER BY 3 DESC;

--2.块分布
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
         where tablespace_name = 'FPV_DATA_2015'
        union all
        select file_id,
               block_id,
               blocks,
               'Free Space',
               'Free Space',
               'Free Space',
               tablespace_name
          from dba_free_space
         where tablespace_name = 'FPV_DATA_2015') mapping,
       dba_tablespaces tbs
 where tbs.tablespace_name = mapping.tablespace_name
   and mapping.file_id = 89
 order by mapping.file_id, mapping.block_id desc;

--2.1.段大小
SELECT A.owner,
       A.segment_name,
       A.segment_type,
       SUM(A.extents) EXT,
       SUM(A.BYTES) / 1024 / 1024 MB
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'DB_LOGISTICS'
 GROUP BY A.owner, A.segment_name, A.segment_type
 ORDER BY 4 DESC;

--3.表空间碎片量
select a.tablespace_name, count(1) 碎片量
  from dba_free_space a, dba_tablespaces b
 where a.tablespace_name = b.tablespace_name
   and b.contents not in ('TEMPORARY', 'UNDO', 'SYSAUX')
 group by a.tablespace_name
having count(1) > 20
 order by 2;

--4.
SELECT * FROM DBA_INDEXES A WHERE A.TABLE_NAME = 'DIM_MEMBER';

--5.move
ALTER TABLE DIM_MEMBER MOVE PARALLEL(DEGREE 4);
ALTER INDEX MEM_INS_IDX REBUILD PARALLEL(DEGREE 4);
ALTER INDEX MEM_INS_IDX NOPARALLEL;

--tmp
SELECT * FROM DBA_DATA_FILES;
SELECT COUNT(*)
  FROM DBA_FREE_SPACE A
 WHERE A.TABLESPACE_NAME = 'ODSINDEX01';
SELECT *
  FROM DBA_SEGMENTS A
 WHERE A.tablespace_name = 'DWDATA01'
   and a.segment_name = 'DATA_ACQUISITION_ITEM_MIN_PER';
SELECT *
  FROM DBA_EXTENTS A
 WHERE A.tablespace_name = 'DWDATA01'
   and a.segment_name = 'DATA_ACQUISITION_ITEM_MIN_PER';
SELECT * FROM DBA_FREE_SPACE A WHERE A.TABLESPACE_NAME = 'ODSINDEX01';
SELECT *
  FROM DBA_INDEXES A
 WHERE A.table_name = 'DATA_ACQUISITION_MONTH_TOPN';
SELECT * FROM DBA_TABLESPACES;
