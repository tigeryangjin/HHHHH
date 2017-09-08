alter table odshappigo.ods_zmaterial enable row movement;
alter table odshappigo.ods_zmaterial shrink space;
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
       (A.BLOCKS * 8 / 1024 - A.AVG_ROW_LEN * A.NUM_ROWS / 1024 / 1024 / 0.9) RECOVER_MB
  FROM dba_tables A
 WHERE /*tablespace_name = 'PSAPSR3'
   AND*/
 A.BLOCKS * 8 / 1024 - A.AVG_ROW_LEN * A.NUM_ROWS / 1024 / 1024 / 0.9 > 100
 /*AND rownum < 11*/
 order by RECOVER_MB desc;

--
BEGIN
  dbms_stats.gather_table_stats('ODSHAPPIGO', 'ODS_ORDER');
END;
/

--
select t.table_name,T.BLOCKS,T.EMPTY_BLOCKS,T.NUM_ROWS
from user_tables T
where T.table_name = upper('DIM_DEVICE');
