--1.
SELECT * FROM GOODS_FILTER_OPTION_HEAD FOR UPDATE;

INSERT INTO GOODS_FILTER_OPTION_HEAD
  (FILTER_ID,
   FILTER_NAME,
   GOODS_LABEL_ID_SET,
   CREATE_TIME,
   CREATE_USER,
   LAST_UPDATE_TIME,
   LAST_UPDATE_USER,
   STATUS,
   EXECUTION_START_TIME,
   EXECUTION_END_TIME,
   RESULT_RECORDS,
   RESULT_MESSAGE,
   OUTPUT_FILE_PATH,
   JSON_GOODS_LABEL)
VALUES
  (GOODS_FILTER_OPTION_HEAD_SEQ.NEXTVAL,
   '≤‚ ‘1',
   '',
   SYSDATE,
   1,
   SYSDATE,
   1,
   0,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL,
   NULL);

--2.
SELECT *
  FROM GOODS_LABEL_HEAD_V A
 WHERE EXISTS
 (SELECT 1 FROM GOODS_LABEL_LINK_V B WHERE A.G_LABEL_ID = B.G_LABEL_ID);

/*
( %col_G_LABEL_ID = 6 %op_or %col_G_LABEL_ID =5 )  %op_and ( %col_G_LABEL_ID = 40 %op_or %col_G_LABEL_ID = 43 %op_or %col_G_LABEL_ID = 46 ) %op_and ( %col_G_LABEL_ID = 26 %op_or %col_G_LABEL_ID = 27 %op_or %col_G_LABEL_ID = 28 )
*/

--3.
SELECT MEMBER_FILTER_PKG.SPLICE_SQL(A.FILTER_ID,
                                    A.MEMBER_LABEL_ID_SET,
                                    A.ITEM_CODE_SET,
                                    A.BRAND_SET,
                                    A.MATXL_SET),
       A.MEMBER_LABEL_ID_SET
  FROM MEMBER_FILTER_OPTION_HEAD A;

--3.1 MEMBER	
INSERT INTO MEMBER_FILTER_RESULT
  (ROW_ID, FILTER_ID, MEMBER_BP, VID, OPENID, PUSHID)
  SELECT MEMBER_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,
         22                               FILTER_ID,
         C.MEMBER_KEY                     MEMBER_BP,
         D.VID                            VID,
         D.OPEN_ID                        OPENID,
         D.PUSH_ID                        PUSHID
    FROM (SELECT DISTINCT A.MEMBER_KEY
            FROM MEMBER_LABEL_LINK A
           WHERE (M_LABEL_ID = 4)
             AND EXISTS (SELECT 1
                    FROM MEMBER_LABEL_LINK A1
                   WHERE A1.MEMBER_KEY = A.MEMBER_KEY
                     AND (M_LABEL_ID = 23))
             AND EXISTS (SELECT 1
                    FROM MEMBER_LABEL_LINK A2
                   WHERE A2.MEMBER_KEY = A.MEMBER_KEY
                     AND (M_LABEL_ID = 43))
             AND EXISTS (SELECT 1
                    FROM MEMBER_LABEL_LINK A3
                   WHERE A3.MEMBER_KEY = A.MEMBER_KEY
                     AND (M_LABEL_ID = 62))
             AND EXISTS (SELECT 1
                    FROM MEMBER_LIKE_ITEM_SYN I
                   WHERE I.MEMBER_KEY = A.MEMBER_KEY
                     AND I.ITEM_CODE IN (185292, 188277, 170510))
             AND EXISTS (SELECT 1
                    FROM MEMBER_LIKE_MATXL_SYN M
                   WHERE M.MEMBER_KEY = A.MEMBER_KEY
                     AND M.MATXL IN (320101,
                                     320102,
                                     320201,
                                     320202,
                                     320203,
                                     320301,
                                     320401,
                                     320402,
                                     320403,
                                     320404,
                                     320405))) C,
         ML_MEMBER_MAPPING_SYN D
   WHERE C.MEMBER_KEY = D.MEMBER_KEY(+);

--3.2 GOODS
/*
( %col_G_LABEL_ID = 6 %op_or %col_G_LABEL_ID =5 )  %op_and ( %col_G_LABEL_ID = 40 %op_or %col_G_LABEL_ID = 43 %op_or %col_G_LABEL_ID = 46 ) %op_and ( %col_G_LABEL_ID = 26 %op_or %col_G_LABEL_ID = 27 %op_or %col_G_LABEL_ID = 28 )
*/
INSERT INTO GOODS_FILTER_RESULT
  (ROW_ID, FILTER_ID, ITEM_CODE, W_INSERT_DT, W_UPDATE_DT)
  SELECT GOODS_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,
         2                               FILTER_ID,
         A.ITEM_CODE,
         SYSDATE                         W_INSERT_DT,
         SYSDATE                         W_UPDATE_DT
    FROM (SELECT DISTINCT A.ITEM_CODE FROM GOODS_LABEL_LINK_V A
   WHERE);

--3.3
SELECT GOODS_FILTER_PKG.SPLICE_SQL(A.FILTER_ID, A.GOODS_LABEL_ID_SET), A.*
  FROM GOODS_FILTER_OPTION_HEAD A
	WHERE A.FILTER_ID=6;
	
SELECT A.* FROM GOODS_FILTER_OPTION_HEAD A;
SELECT * FROM MEMBER_FILTER_OPTION_HEAD;

SELECT * FROM GOODS_FILTER_RESULT A WHERE A.FILTER_ID=7;
	
--3.4
CALL GOODS_FILTER_PKG.GOODS_RESULT_TO_TABLE();

CALL GOODS_FILTER_PKG.DEBUG(2);
