--1.查询等待事件详细信息
SELECT p1 "file#", p2 "block#", p3 "class#"
  FROM v$session_wait
 WHERE event = 'read by other session';

--2.查询热快对象
SELECT relative_fno, owner, segment_name, segment_type
  FROM dba_extents
 WHERE file_id = &file
   AND &block BETWEEN block_id AND block_id blocks - 1;

--3.查看对应SQL
SELECT HASH_VALUE, SQL_TEXT
  FROM V$SQLTEXT
 WHERE (HASH_VALUE, ADDRESS) IN
       (SELECT A.HASH_VALUE, A.ADDRESS
          FROM V$SQLTEXT A,
               (SELECT DISTINCT A.OWNER, A.SEGMENT_NAME, A.SEGMENT_TYPE
                  FROM DBA_EXTENTS A,
                       (SELECT DBARFIL, DBABLK
                          FROM (SELECT DBARFIL, DBABLK
                                  FROM X$BH
                                 ORDER BY TCH DESC)
                         WHERE ROWNUM < 11) B 
                 WHERE A.RELATIVE_FNO = B.DBARFIL
                   AND A.BLOCK_ID <= B.DBABLK
                   AND /*A.BLOCK_ID*/ A.BLOCKS > B.DBABLK) B
         WHERE A.SQL_TEXT LIKE '%' || B.SEGMENT_NAME || '%'
           AND B.SEGMENT_TYPE = 'TABLE')
 ORDER BY HASH_VALUE, ADDRESS, PIECE;
