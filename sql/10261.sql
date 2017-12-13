INSERT INTO MEMBER_FILTER_RESULT
  (ROW_ID, FILTER_ID, MEMBER_BP, VID, OPENID, PUSHID)
  SELECT MEMBER_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,
         3                                FILTER_ID,
         C.MEMBER_KEY                     MEMBER_BP,
         D.VID                            VID,
         D.OPEN_ID                        OPENID,
         D.PUSH_ID                        PUSHID
    FROM (SELECT DISTINCT A.MEMBER_KEY
            FROM MEMBER_LABEL_LINK A
           WHERE (M_LABEL_ID = 49)
             AND EXISTS (SELECT 1
                    FROM MEMBER_LABEL_LINK A1
                   WHERE A1.MEMBER_KEY = A.MEMBER_KEY
                     AND (M_LABEL_ID = 55))
             AND EXISTS (SELECT 1
                    FROM MEMBER_LABEL_LINK A2
                   WHERE A2.MEMBER_KEY = A.MEMBER_KEY
                     AND (M_LABEL_ID = 143 OR M_LABEL_ID = 144))
             AND EXISTS (SELECT 1
                    FROM MEMBER_LABEL_LINK A3
                   WHERE A3.MEMBER_KEY = A.MEMBER_KEY
                     AND (M_LABEL_ID = 162))
             AND EXISTS
           (SELECT 1
                    FROM MEMBER_LIKE_ITEM_SYN I
                   WHERE I.MEMBER_KEY = A.MEMBER_KEY
                     AND I.ITEM_CODE IN (185292, 188277, 170510))) C,
         ML_MEMBER_MAPPING_SYN D
   WHERE C.MEMBER_KEY = D.MEMBER_KEY(+);

/*
( %col_ITEM_CODE IN(185292,188277,170510)) 
*/
INSERT INTO MEMBER_FILTER_RESULT
  (ROW_ID, FILTER_ID, MEMBER_BP, VID, OPENID, PUSHID)
  SELECT MEMBER_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,
         3                                FILTER_ID,
         C.MEMBER_KEY                     MEMBER_BP,
         D.VID                            VID,
         D.OPEN_ID                        OPENID,
         D.PUSH_ID                        PUSHID
    FROM (SELECT DISTINCT A.MEMBER_KEY
            FROM MEMBER_LIKE_ITEM_SYN A
           WHERE A.ITEM_CODE IN (185292, 188277, 170510)) C,
         ML_MEMBER_MAPPING_SYN D
   WHERE C.MEMBER_KEY = D.MEMBER_KEY(+);

INSERT INTO MEMBER_FILTER_RESULT
  (ROW_ID, FILTER_ID, MEMBER_BP, VID, OPENID, PUSHID)
  SELECT MEMBER_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,
         4                                FILTER_ID,
         C.MEMBER_KEY                     MEMBER_BP,
         D.VID                            VID,
         D.OPEN_ID                        OPENID,
         D.PUSH_ID                        PUSHID
    FROM (SELECT DISTINCT A.MEMBER_KEY
            FROM MEMBER_LIKE_ITEM_SYN A
           WHERE A.ITEM_CODE IN (185292, 188277, 170510)) C,
         ML_MEMBER_MAPPING_SYN D
   WHERE C.MEMBER_KEY = D.MEMBER_KEY(+)

