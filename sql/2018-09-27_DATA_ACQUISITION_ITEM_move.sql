--1.DATA
SELECT 1 COL1,
       A.TABLE_OWNER,
       A.TABLE_NAME,
       A.SUBPARTITION_NAME,
       'ALTER TABLE ' || A.TABLE_OWNER || '.' || A.TABLE_NAME ||
       ' MOVE SUBPARTITION ' || A.SUBPARTITION_NAME ||
       ' PARALLEL(DEGREE 4);' COL1
  FROM DBA_TAB_SUBPARTITIONS A
 WHERE A.TABLE_NAME = 'DATA_ACQUISITION_ITEM';

--2.INDEX
SELECT 2 COL1,
       A.index_owner,
       A.index_name,
       A.subpartition_name,
       'ALTER INDEX ' || A.index_owner || '.' || A.index_name ||
       ' REBUILD SUBPARTITION ' || A.subpartition_name ||
       ' PARALLEL(DEGREE 4);' COL1
  FROM DBA_IND_SUBPARTITIONS A
 WHERE A.index_name IN ('DATA_ACQUISITION_ITEM_I1',
                        'DATA_ACQUISITION_ITEM_I2',
                        'IDX_DATA_ACQUISITION_ITEM_P1',
                        'IDX_DATA_ACQUISITION_ITEM_P30');

--3.
SELECT *
  FROM (SELECT 1 COL1,
               A.TABLE_OWNER OWNER,
               A.TABLE_NAME,
               A.SUBPARTITION_NAME,
               'ALTER TABLE ' || A.TABLE_OWNER || '.' || A.TABLE_NAME ||
               ' MOVE SUBPARTITION ' || A.SUBPARTITION_NAME ||
               ' PARALLEL(DEGREE 4);' COL2
          FROM DBA_TAB_SUBPARTITIONS A
         WHERE A.TABLE_NAME = 'DATA_ACQUISITION_ITEM'
        UNION ALL
        SELECT 2 COL1,
               A.index_owner OWNER,
               A.index_name,
               A.subpartition_name,
               'ALTER INDEX ' || A.index_owner || '.' || A.index_name ||
               ' REBUILD SUBPARTITION ' || A.subpartition_name ||
               ' PARALLEL(DEGREE 4);' COL2
          FROM DBA_IND_SUBPARTITIONS A
         WHERE A.index_name IN
               ('DATA_ACQUISITION_ITEM_I1',
                'DATA_ACQUISITION_ITEM_I2',
                'IDX_DATA_ACQUISITION_ITEM_P1',
                'IDX_DATA_ACQUISITION_ITEM_P30')) B
 ORDER BY B.subpartition_name, B.COL1, b.TABLE_NAME;
