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

--确认表碎片化的SQL
SELECT B.OWNER "owner",
       B.TABLE_NAME "table_naeme",
       ROUND(A.SEG_BYTES / 1024 / 1024, 1) "allocated_size(MB)",
       ROUND(B.TAB_BYTES / 1024 / 1024, 1) "used_size(MB)",
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
select c.owner,
       c.table_name,
       c.num_rows,
       c.tab_bytes,
       c.seg_bytes,
       c.frag,
       'call yj_optimization.atss(''' || c.table_name || ''');' s
  from (select a.owner,
               a.table_name,
               a.num_rows,
               a.avg_row_len * a.num_rows tab_bytes,
               sum(b.bytes) seg_bytes,
               (a.avg_row_len * a.num_rows) / sum(b.bytes) frag
          from dba_tables a, dba_segments b
         where a.table_name = b.segment_name
           and a.owner = b.owner
           and a.owner in ('DW_USER', 'ODSHAPPIGO', 'DW_HAPPIGO')
         group by a.owner, a.table_name, a.avg_row_len, a.num_rows
        having a.avg_row_len * a.num_rows / sum(b.bytes) < 0.7
         order by sum(b.bytes) desc) c
 where rownum <= 100;

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
