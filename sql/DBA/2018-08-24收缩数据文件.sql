--1.
SELECT A.FILE_ID,
       'alter database datafile ''' || A.FILE_NAME || ''' resize ' ||
       ROUND(A.FILESIZE - (A.FILESIZE - C.HWMSIZE - 100) * 0.8) || 'M;' S,
       A.FILESIZE AS "数据文件大小(M)",
       C.HWMSIZE AS "数据文件的实用大小(M)",
       A.FILESIZE -
       ROUND(A.FILESIZE - (A.FILESIZE - C.HWMSIZE - 100) * 0.8) AS "收缩大小(M)"
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

--2.回收站
SELECT * FROM DBA_RECYCLEBIN;

PURGE DBA_RECYCLEBIN;

SELECT * FROM DBA_DATA_FILES;

SELECT 1911 - 880 FROM DUAL;

--tmp
alter database datafile '/data/u01/oradata/bihappigo/dwdata00g.dbf' resize 28520M;
alter database datafile '/data/u01/oradata/bihappigo/dwdata00h.dbf' resize 26581M;
alter database datafile '/data/u01/oradata/bihappigo/fpv_data_2016_03.dbf' resize 24619M;
alter database datafile '/data/u01/oradata/bihappigo/fpv_data_2018_02.dbf' resize 20224M;
alter database datafile '/data/u01/oradata/bihappigo/acquisition_data_08.dbf' resize 18503M;
alter database datafile '/data/u01/oradata/bihappigo/logistics04.dbf' resize 8453M;

