--1.
SELECT A.FILE_ID,
       'alter database datafile ''' || A.FILE_NAME || ''' resize ' ||
       ROUND(A.FILESIZE - (A.FILESIZE - C.HWMSIZE - 100) * 0.8) || 'M;' S,
       A.FILESIZE AS "�����ļ���С(M)",
       C.HWMSIZE AS "�����ļ���ʵ�ô�С(M)",
       A.FILESIZE -
       ROUND(A.FILESIZE - (A.FILESIZE - C.HWMSIZE - 100) * 0.8) AS "������С(M)"
  FROM (SELECT FILE_ID, FILE_NAME, ROUND(BYTES / 1024 / 1024) AS FILESIZE
          FROM DBA_DATA_FILES GG
         /*WHERE GG.TABLESPACE_NAME = 'DWDATA01'*/) A,
       (SELECT FILE_ID, ROUND(MAX(BLOCK_ID) * 8 / 1024) AS HWMSIZE
          FROM DBA_EXTENTS GGG
         /*WHERE GGG.TABLESPACE_NAME = 'DWDATA01'*/
         GROUP BY FILE_ID) C
 WHERE A.FILE_ID = C.FILE_ID
   AND A.FILESIZE -
       ROUND(A.FILESIZE - (A.FILESIZE - C.HWMSIZE - 100) * 0.8) > 100
 ORDER BY 4 DESC;

--2.����վ
SELECT * FROM DBA_RECYCLEBIN;

PURGE DBA_RECYCLEBIN;

SELECT * FROM DBA_DATA_FILES;

SELECT 1911 - 880 FROM DUAL;

--tmp
alter database datafile '/data/u01/oradata/bihappigo/acquisition_data_08.dbf' resize 28559M;
alter database datafile '/data/u01/oradata/bihappigo/logistics04.dbf' resize 15296M;







