--***********************************************************************************
--1.create sequence
--***********************************************************************************
create sequence MEMBER_FILTER_OPTION_HEAD_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence MEMBER_FILTER_RESULT_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

-- Create sequence 
create sequence ml_user_seq
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

--***********************************************************************************
--2.create table
--***********************************************************************************
SELECT * FROM MEMBER_FILTER_OPTION_HEAD;
SELECT * FROM MEMBER_FILTER_RESULT;
SELECT * FROM MEMBER_LABEL_HEAD;
SELECT * FROM MEMBER_LABEL_LINK;


--***********************************************************************************
--3.create package
--***********************************************************************************
--MEMBER_FILTER


SELECT A.START_TIME,
       A.END_TIME,
       A.ETL_DURATION,
       A.ETL_STATUS,
       A.ETL_RECORD_INS,
       A.ERR_MSG
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'MEMBER_FILTER_PKG.SYNC_MEMBER_LABEL_LINK'
 ORDER BY A.START_TIME DESC;

SELECT TRUNC(A.LAST_UPDATE_DATE) LUD, COUNT(1)
  FROM MEMBER_LABEL_LINK A
	WHERE A.ROW_ID IS NOT NULL
 GROUP BY TRUNC(A.LAST_UPDATE_DATE)
 ORDER BY 1;

--重新刷新历史数据
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2017-09-04';
  END_DATE    DATE := DATE '2017-09-30';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    MEMBER_FILTER_PKG.SYNC_MEMBER_LABEL_LINK(IN_DATE_INT); 
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/


--tmp
SELECT COUNT(1) FROM MEMBER_LABEL_LINK_TMP;
SELECT * FROM MEMBER_LABEL_LINK_TMP;
