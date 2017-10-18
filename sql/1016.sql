SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'MEMBER_LABEL_PKG.MEMBER_LIFE_PERIOD'
 ORDER BY A.START_TIME DESC;

SELECT COUNT(1) FROM MEMBER_LIFE_PERIOD_TMP_A A;
SELECT COUNT(1) FROM MEMBER_LIFE_PERIOD_TMP_B B;

select name,PARAMETER1,PARAMETER2,PARAMETER3,WAIT_CLASS from v$event_name where name like '%db file s%';

SELECT OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, A.PARTITION_NAME  
 FROM DBA_EXTENTS A  
 WHERE FILE_ID = &FILE_ID  
 AND &BLOCK_ID BETWEEN BLOCK_ID AND BLOCK_ID + BLOCKS �C 1; 
 
select * from v$sql where upper(sql_text) like ��%object_name%��;