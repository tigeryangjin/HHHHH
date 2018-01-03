alter table odshappigo.ods_zmaterial enable row movement;
alter table odshappigo.ods_zmaterial shrink space compact;
alter table odshappigo.ods_zmaterial disable row movement;

begin
  -- Call the procedure
  yangjin_pkg_test.alter_table_shrink_space('DIM_DEVICE');
end;
/

--高水位线表查询
SELECT A.TABLE_NAME,
       A.NUM_ROWS,
       A.AVG_ROW_LEN * A.NUM_ROWS / 1024 / 1024 / 0.9 NEED,
       A.BLOCKS * 8 / 1024 TRUE,
       (A.BLOCKS * 8 / 1024 -
       A.AVG_ROW_LEN * A.NUM_ROWS / 1024 / 1024 / 0.9) RECOVER_MB
  FROM dba_tables A
 WHERE /*tablespace_name = 'PSAPSR3'
   AND*/
 A.BLOCKS * 8 / 1024 - A.AVG_ROW_LEN * A.NUM_ROWS / 1024 / 1024 / 0.9 > 100
/*AND rownum < 11*/
 order by RECOVER_MB desc;

--1266	DW_USER	FACT_GOODS_SALES	3807101	3909632	102531	0.0269315156072823
SELECT A.OWNER,
       A.TABLE_NAME,
       A.TBLOCKS,
       A.SBLOCKS,
       A.SBLOCKS - A.TBLOCKS WBLOCKS,
       (A.SBLOCKS - A.TBLOCKS) / A.TBLOCKS
  FROM (SELECT T.OWNER,
               T.TABLE_NAME,
               T.BLOCKS TBLOCKS,
               SUM(S.blocks) SBLOCKS
          FROM dba_segments S, dba_tables T
         WHERE S.segment_name = T.TABLE_NAME
           AND S.owner = T.OWNER
					 AND S.owner='DW_USER'
           AND T.BLOCKS > 0
         GROUP BY T.OWNER,T.TABLE_NAME, T.BLOCKS) A
 ORDER BY 6 DESC;

--
BEGIN
  dbms_stats.gather_table_stats('ODSHAPPIGO', 'ODS_ORDER');
END;
/

--
select t.table_name,T.BLOCKS,T.EMPTY_BLOCKS,T.NUM_ROWS
from user_tables T
where T.table_name = upper('DIM_DEVICE');
