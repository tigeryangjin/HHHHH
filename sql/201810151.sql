--1.
SELECT A.TABLESPACE_NAME,
       A.FILE_ID,
       COUNT(1) CNT,
       SUM(A.BYTES) / 1024 / 1024 MB_BYTES
  FROM DBA_FREE_SPACE A
 WHERE A.TABLESPACE_NAME IN
       ('BDUDATA00', 'BDUDATA01', 'BDUDATA02', 'BDUDATA03', 'BDUDATA04')
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
         where tablespace_name = 'BDUDATA03'
        union all
        select file_id,
               block_id,
               blocks,
               'Free Space',
               'Free Space',
               'Free Space',
               tablespace_name
          from dba_free_space
         where tablespace_name = 'BDUDATA03') mapping,
       dba_tablespaces tbs
 where tbs.tablespace_name = mapping.tablespace_name
   and mapping.file_id = 129
 order by mapping.file_id, mapping.block_id desc;

--3.��ͨ��
SELECT B.COL1, B.OWNER, B.TABLE_NAME, B.COL2
  FROM (SELECT 1 COL1,
                A.owner,
                A.TABLE_NAME,
                'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME ||
                ' MOVE PARALLEL(DEGREE 4) NOLOGGING;' COL2
           FROM DBA_TABLES A
          WHERE /*A.tablespace_name = 'BDUDATA00'
            AND*/ A.PARTITIONED = 'NO'
         UNION ALL
         SELECT 2 COL1,
                A.owner,
                A.TABLE_NAME,
                'ALTER INDEX ' || A.OWNER || '.' || A.index_name ||
                ' REBUILD PARALLEL(DEGREE 4) NOLOGGING;' COL2
           FROM DBA_INDEXES A
          WHERE /*A.tablespace_name = 'BDUDATA00'                                                                                                                                                             AND*/
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
 WHERE B.TABLE_NAME = 'DIM_MEMID'
 ORDER BY B.OWNER, B.TABLE_NAME, B.COL1;

--4.������
SELECT *
  FROM (SELECT A.TABLE_OWNER OWNER,
               A.TABLE_NAME OBJECT_NAME,
               A.PARTITION_NAME,
               1 COL1,
               'ALTER TABLE ' || A.TABLE_OWNER || '.' || A.TABLE_NAME ||
               ' MOVE PARTITION ' || A.PARTITION_NAME ||
               ' PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_TAB_PARTITIONS A
         WHERE A.TABLE_NAME = 'FACT_MEMBER_REGISTER'
        UNION ALL
        SELECT A.INDEX_OWNER OWNER,
               A.INDEX_NAME OBJECT_NAME,
               A.PARTITION_NAME,
               2 COL1,
               'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
               ' REBUILD PARTITION ' || A.PARTITION_NAME ||
               ' PARALLEL(DEGREE 4) NOLOGGING;' COL2
          FROM DBA_IND_PARTITIONS A
         WHERE A.SUBPARTITION_COUNT = 0
           AND A.INDEX_NAME IN
               (SELECT A.INDEX_NAME
                  FROM DBA_INDEXES A
                 WHERE A.table_name = 'FACT_MEMBER_REGISTER')
        UNION ALL
        SELECT A.INDEX_OWNER OWNER,
               A.INDEX_NAME OBJECT_NAME,
               A.PARTITION_NAME,
               3 COL1,
               'ALTER INDEX ' || A.INDEX_OWNER || '.' || A.INDEX_NAME ||
               ' REBUILD PARTITION ' || A.PARTITION_NAME || ' NOPARALLEL;' COL2
          FROM DBA_IND_PARTITIONS A
         WHERE A.SUBPARTITION_COUNT = 0
           AND A.INDEX_NAME IN
               (SELECT A.INDEX_NAME
                  FROM DBA_INDEXES A
                 WHERE A.table_name = 'FACT_MEMBER_REGISTER')) B
 ORDER BY B.OWNER, B.PARTITION_NAME, B.OBJECT_NAME, B.COL1;

--tmp
SELECT * FROM DBA_DATA_FILES;

SELECT * FROM DBA_SEGMENTS A WHERE A.tablespace_name='BDUDATA03';

DROP TABLESPACE BDUDATA01;
