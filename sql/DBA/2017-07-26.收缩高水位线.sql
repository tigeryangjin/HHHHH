--��ˮλ�߱��ѯ
SELECT A.TABLE_NAME,
       A.NUM_ROWS,
       A.AVG_ROW_LEN * A.NUM_ROWS / 1024 / 1024 / 0.9 NEED,
       A.BLOCKS * 8 / 1024 TRUE,
       (A.BLOCKS * 8 / 1024 -
       A.AVG_ROW_LEN * A.NUM_ROWS / 1024 / 1024 / 0.9) RECOVER_MB,
			 A.LAST_ANALYZED
  FROM dba_tables A
 WHERE /*tablespace_name = 'PSAPSR3'
   AND*/
 A.BLOCKS * 8 / 1024 - A.AVG_ROW_LEN * A.NUM_ROWS / 1024 / 1024 / 0.9 > 100
/*AND rownum < 11*/
 order by RECOVER_MB desc;

--ȷ�ϱ���Ƭ����SQL
SELECT B.OWNER "owner",
       B.TABLE_NAME "table_naeme",
       ROUND(A.SEG_BYTES / 1024 / 1024, 1) "SEG_BYTES(MB)",
       ROUND(B.TAB_BYTES / 1024 / 1024, 1) "TAB_BYTES(MB)",
       ROUND((A.SEG_BYTES - B.TAB_BYTES) / 1024 / 1024, 1) "free(MB)",
       ROUND(B.TAB_BYTES / A.SEG_BYTES, 2) "used_per",
       B.LAST_ANALYZED
  FROM (SELECT A1.OWNER, A1.SEGMENT_NAME, SUM(A1.BYTES) SEG_BYTES
          FROM DBA_SEGMENTS A1
         GROUP BY OWNER, SEGMENT_NAME) A,
       (SELECT B1.OWNER,
               B1.TABLE_NAME,
               B1.LAST_ANALYZED,
               SUM(B1.NUM_ROWS * B1.AVG_ROW_LEN) TAB_BYTES
          FROM DBA_TABLES B1
         GROUP BY OWNER, TABLE_NAME, B1.LAST_ANALYZED) B
 WHERE A.SEGMENT_NAME = B.TABLE_NAME
   AND B.OWNER IN ('DW_USER', 'ODSHAPPIGO')
 ORDER BY 5 DESC;



--
BEGIN
  dbms_stats.gather_table_stats('ODSHAPPIGO', 'ODS_ORDER');
END;
/

--
  select t.table_name, T.BLOCKS, T.EMPTY_BLOCKS, T.NUM_ROWS
    from user_tables T
   where T.table_name = upper('DIM_DEVICE');

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'YJ_OPTIMIZATION.TABLE_OPTIMIZATION'
 ORDER BY A.START_TIME DESC;
