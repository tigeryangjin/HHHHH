--1.
DROP TABLE TEST1213;
CREATE TABLE TEST1213(ID NUMBER,VNAME VARCHAR(200));

--2.
/*
kkkKKK 15
K      10
*/
begin
  for i in 1 .. 100000 loop
    insert into TEST1213 values (10000, 'KKK');
  end loop;
  commit;
end;
/

insert into TEST1213 values (10000, 'KKK');
COMMIT;

--3.
analyze table TEST1213 compute statistics;
CALL DBMS_STATS.GATHER_TABLE_STATS('DW_USER', 'TEST1213');

--4.
TRUNCATE TABLE TEST1213;

SELECT A.AVG_ROW_LEN,A.NUM_ROWS,A.BLOCKS,A.EMPTY_BLOCKS FROM DBA_TABLES A WHERE A.TABLE_NAME='TEST1213';
SELECT * FROM DBA_SEGMENTS A WHERE A.segment_name='TEST1213';
SELECT A.ID,DUMP(A.ID),A.VNAME,DUMP(A.VNAME) FROM TEST1213 A ORDER BY A.ID;
SELECT DUMP(123456789) FROM DUAL;
SELECT 7*100000,244*8*1024 FROM DUAL;
