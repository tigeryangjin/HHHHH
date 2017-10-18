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
--10.10.204.18 dw_user
SELECT * FROM OPER_MEMBER_LIKE_ITEM;
SELECT * FROM OPER_MEMBER_LIKE_MATXL;


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
  BEGIN_DATE  DATE := DATE '2017-10-13';
  END_DATE    DATE := DATE '2017-10-14';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    MEMBER_FILTER_PKG.SYNC_MEMBER_LABEL_LINK(IN_DATE_INT); 
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

--***********************************************************************************
--4.同步删除member_label_link记录
--***********************************************************************************
TRUNCATE TABLE MLL_ROW_ID_TMP;

INSERT INTO MLL_ROW_ID_TMP
  SELECT A.ROW_ID FROM MEMBER_LABEL_LINK@DW27 A WHERE A.ROW_ID IS NOT NULL;
COMMIT;

drop table MLL_ROW_ID_TMP;
create table MLL_ROW_ID_TMP as
SELECT A.ROW_ID FROM MEMBER_LABEL_LINK@DW27 A WHERE A.ROW_ID IS NOT NULL;

alter table MLL_ROW_ID_TMP
  add constraint MLL_ROW_ID_TMP_uk unique (ROW_ID);

DELETE MEMBER_LABEL_LINK A
 WHERE NOT EXISTS
 (SELECT 1 FROM MLL_ROW_ID_TMP B WHERE A.ROW_ID = B.ROW_ID);

--***********************************************************************************
--5.创建同义词
--***********************************************************************************
CREATE OR REPLACE SYNONYM MEMBER_LIKE_ITEM_SYN FOR DW_USER.OPER_MEMBER_LIKE_ITEM;
CREATE OR REPLACE SYNONYM MEMBER_LIKE_MATXL_SYN FOR DW_USER.OPER_MEMBER_LIKE_MATXL;
CREATE OR REPLACE SYNONYM ML_MATERCATE_SYN FOR DIM_MATERCATE@DW27; 
CREATE OR REPLACE SYNONYM ML_MEMBER_MAPPING_SYN FOR DIM_MAPPING_MEM@DW27; 

DROP SYNONYM OPER_MEMBER_LIKE_ITEM;
DROP SYNONYM OPER_MEMBER_LIKE_MATXL;
DROP SYNONYM ML_MATERCATE;

SELECT * FROM DBA_SYNONYMS ;

SELECT * FROM OPER_MEMBER_LIKE_ITEM;
SELECT * FROM OPER_MEMBER_LIKE_MATXL;

--tmp
SELECT COUNT(1) FROM MEMBER_LABEL_LINK_TMP;
SELECT * FROM MEMBER_LABEL_LINK_TMP;
SELECT *
  FROM MEMBER_LABEL_LINK A
 WHERE NOT EXISTS
 (SELECT 1 FROM MLL_ROW_ID_TMP B WHERE A.ROW_ID = B.ROW_ID);
