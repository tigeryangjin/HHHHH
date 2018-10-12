CREATE TABLE YANGJIN.STRTAB(cola varchar2(200));

/*
1:2
2:3
3:4
4:5
10:11
*/
TRUNCATE TABLE YANGJIN.STRTAB;
INSERT INTO YANGJIN.STRTAB VALUES('ABC');
INSERT INTO YANGJIN.STRTAB VALUES('AAAAAAAAAA');

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'YANGJIN',
                                TABNAME => 'STRTAB',
                                DEGREE  => 4,
                                CASCADE => TRUE);
END;
/

SELECT * FROM YANGJIN.STRTAB;

SELECT A.OWNER,
       A.TABLE_NAME,
       A.TABLESPACE_NAME,
       A.NUM_ROWS,
       A.BLOCKS,
       A.EMPTY_BLOCKS,
       A.AVG_ROW_LEN
  FROM DBA_TABLES A
 WHERE A.OWNER = 'YANGJIN'
   AND A.TABLE_NAME = 'STRTAB';