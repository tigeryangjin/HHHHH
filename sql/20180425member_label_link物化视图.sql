--1.dw_user,27
create materialized view log on member_label_link  with primary key;  


--2.ml,18
CREATE MATERIALIZED VIEW ML.MEMBER_LABEL_LINK_MV 
(ROW_ID,
 MEMBER_KEY,
 M_LABEL_ID,
 M_LABEL_TYPE_ID,
 CREATE_DATE,
 CREATE_USER_ID,
 LAST_UPDATE_DATE,
 LAST_UPDATE_USER_ID) 
REFRESH FAST ON DEMAND    
WITH PRIMARY KEY                
AS 
SELECT ROW_ID,
       MEMBER_KEY,
       M_LABEL_ID,
       M_LABEL_TYPE_ID,
       CREATE_DATE,
       CREATE_USER_ID,
       LAST_UPDATE_DATE,
       LAST_UPDATE_USER_ID
  FROM DW_USER.MEMBER_LABEL_LINK@DW27;

--3.
CALL DBMS_MVIEW.REFRESH('MEMBER_LABEL_LINK_MV',METHOD=>'FAST');

--4.
DROP TABLE MEMBER_LABEL_LINK;
CREATE OR REPLACE VIEW MEMBER_LABEL_LINK AS
SELECT A.ROW_ID,
       A.MEMBER_KEY,
       A.M_LABEL_ID,
       A.M_LABEL_TYPE_ID,
       A.CREATE_DATE,
       A.CREATE_USER_ID,
       A.LAST_UPDATE_DATE,
       A.LAST_UPDATE_USER_ID
  FROM ML.MEMBER_LABEL_LINK_MV A;
	
--5.
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'MEMBER_FILTER_PKG.SYNC_MEMBER_LABEL_LINK'
 ORDER BY A.START_TIME DESC;
