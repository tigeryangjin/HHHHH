SELECT *
  FROM MEMBER_LABEL_LINK_V A
 WHERE (%col_M_LABEL_ID = 144 %op_or %col_M_LABEL_ID = 145)
 %op_and(%col_M_LABEL_ID = 122);

SELECT DISTINCT A.MEMBER_KEY
  FROM MEMBER_LABEL_LINK_V A
 WHERE (A.M_LABEL_ID = 144 OR A.M_LABEL_ID = 145)
   AND EXISTS (SELECT 1
          FROM MEMBER_LABEL_LINK_V B
         WHERE B.M_LABEL_ID = 122
           AND A.MEMBER_KEY = B.MEMBER_KEY);

--
INSERT INTO MEMBER_FILTER_RESULT
  (ROW_ID, FILTER_ID, MEMBER_BP, VID, OPENID, PUSHID)
  SELECT MEMBER_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,
         1                                FILTER_ID,
         C.MEMBER_KEY                     MEMBER_BP,
         D.VID                            VID,
         D.OPEN_ID                        OPENID,
         D.PUSH_ID                        PUSHID
    FROM (SELECT DISTINCT A.MEMBER_KEY
            FROM MEMBER_LABEL_LINK_V A
           WHERE (A.M_LABEL_ID = 144 OR A.M_LABEL_ID = 145)
             AND EXISTS (SELECT 1
                    FROM MEMBER_LABEL_LINK_V B
                   WHERE B.M_LABEL_ID = 122
                     AND A.MEMBER_KEY = B.MEMBER_KEY)) C,
         ML_MEMBER_MAPPING_SYN D
   WHERE C.MEMBER_KEY = D.MEMBER_KEY(+);

--依此替换指定字符串
SELECT REGEXP_REPLACE('( %col_M_LABEL_ID = 49)  %op_and ( %col_M_LABEL_ID = 144)  %op_and ( %col_M_LABEL_ID = 162 %op_or %col_M_LABEL_ID = 163 %op_or %col_M_LABEL_ID = 164 %op_or %col_M_LABEL_ID = 165 %op_or %col_M_LABEL_ID = 166) ',
                      '%op_and',
                      '%op_and_b',
                      1,
                      1)
  FROM DUAL;

--查找指定字符串出现的次数
select (length('xyzabc123abcefgh') -
       length(replace('xyzabc123abcefgh', 'abc'))) / length('abc')
  from dual;

--拼接模板
INSERT INTO MEMBER_FILTER_RESULT
  (ROW_ID, FILTER_ID, MEMBER_BP, VID, OPENID, PUSHID)
  SELECT MEMBER_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,
         1                                FILTER_ID,
         C.MEMBER_KEY                     MEMBER_BP,
         D.VID                            VID,
         D.OPEN_ID                        OPENID,
         D.PUSH_ID                        PUSHID
    FROM (SELECT DISTINCT A.MEMBER_KEY
            FROM MEMBER_LABEL_LINK A
           WHERE (%COL_M_LABEL_ID = 49) %OPR_AND_1(%COL_M_LABEL_ID = 144)
           %OPR_AND_2(%COL_M_LABEL_ID = 162 %OP_OR
                            %COL_M_LABEL_ID = 163 %OP_OR
                            %COL_M_LABEL_ID = 164 %OP_OR
                            %COL_M_LABEL_ID = 165 %OP_OR
                            %COL_M_LABEL_ID = 166)) C,
         ML_MEMBER_MAPPING_SYN D
   WHERE C.MEMBER_KEY = D.MEMBER_KEY(+);
--拼接结果
INSERT INTO MEMBER_FILTER_RESULT
  (ROW_ID, FILTER_ID, MEMBER_BP, VID, OPENID, PUSHID)
  SELECT MEMBER_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,
         1                                FILTER_ID,
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
                     AND (M_LABEL_ID = 144))
             AND EXISTS (SELECT 1
                    FROM MEMBER_LABEL_LINK A2
                   WHERE A2.MEMBER_KEY = A.MEMBER_KEY
                     AND (M_LABEL_ID = 162 OR M_LABEL_ID = 163 OR
                         M_LABEL_ID = 164 OR M_LABEL_ID = 165 OR
                         M_LABEL_ID = 166))) C,
         ML_MEMBER_MAPPING_SYN D
   WHERE C.MEMBER_KEY = D.MEMBER_KEY(+);

--TMP
SELECT * FROM ML_MEMBER_MAPPING_SYN;

SELECT A.MEMBER_LABEL_ID_SET, A.MEMBER_LABEL_ID_SET
  FROM MEMBER_FILTER_OPTION_HEAD A
 WHERE A.FILTER_ID = 6;

SELECT MEMBER_FILTER_PKG.SPLICE_SQL(A.MEMBER_LABEL_ID_SET),
       A.MEMBER_LABEL_ID_SET
  FROM MEMBER_FILTER_OPTION_HEAD A
 WHERE A.FILTER_ID = 6;

TRUNCATE TABLE MEMBER_FILTER_RESULT;
SELECT DISTINCT FILTER_ID FROM MEMBER_FILTER_RESULT;
SELECT COUNT(1) FROM MEMBER_FILTER_RESULT;

SELECT DISTINCT A.MEMBER_KEY
  FROM MEMBER_LABEL_LINK_V A
 WHERE (A.M_LABEL_ID = 144 OR A.M_LABEL_ID = 145)
   AND EXISTS (SELECT 1
          FROM MEMBER_LABEL_LINK_V B
         WHERE B.M_LABEL_ID = 122
           AND A.MEMBER_KEY = B.MEMBER_KEY);

SELECT '( %col_M_LABEL_ID = 49)  %op_and ( %col_M_LABEL_ID = 144)',
       REPLACE('( %col_M_LABEL_ID = 49)  %op_and ( %col_M_LABEL_ID = 144)',
               '%col_',
               'A.'),
       REGEXP_REPLACE('( %col_M_LABEL_ID = 49)  %op_and ( %col_M_LABEL_ID = 144)',
                      '%col_',
                      'A.'),
       REGEXP_INSTR('( %col_M_LABEL_ID = 49)  %op_and ( %col_M_LABEL_ID = 144)',
                    '%col_',
                    'A.')
  FROM DUAL;

SELECT A.DIRECTORY_PATH
  FROM SYS.DBA_DIRECTORIES A
 WHERE A.DIRECTORY_NAME = 'MEMBER_LABEL_OUTPUT';

SELECT A.FILTER_ID,
       MEMBER_FILTER_PKG.SPLICE_SQL(A.FILTER_ID, A.MEMBER_LABEL_ID_SET),
       A.MEMBER_LABEL_ID_SET
  FROM MEMBER_FILTER_OPTION_HEAD A;

SELECT A.FILTER_ID,
       MEMBER_FILTER_PKG.SPLICE_SQL(A.FILTER_ID,
                                    A.MEMBER_LABEL_ID_SET,
                                    A.ITEM_CODE_SET,
                                    A.BRAND_SET,
                                    A.MATXL_SET),
       A.MEMBER_LABEL_ID_SET,
       A.ITEM_CODE_SET,
       A.BRAND_SET,
       A.MATXL_SET
  FROM MEMBER_FILTER_OPTION_HEAD A
 ORDER BY A.FILTER_ID;

SELECT A.FILTER_ID,
       MEMBER_FILTER_PKG.SPLICE_SQL(A.FILTER_ID,
                                    A.MEMBER_LABEL_ID_SET,
                                    NULL,
                                    NULL,
                                    A.MATXL_SET),
       A.MEMBER_LABEL_ID_SET,
       A.ITEM_CODE_SET,
       A.BRAND_SET,
       A.MATXL_SET
  FROM MEMBER_FILTER_OPTION_HEAD A
 ORDER BY A.FILTER_ID;

UPDATE MEMBER_FILTER_OPTION_HEAD A
   SET A.STATUS               = 0,
       A.EXECUTION_START_TIME = NULL,
       A.EXECUTION_END_TIME   = NULL,
       A.RESULT_RECORDS       = NULL,
       A.RESULT_MESSAGE       = NULL,
       A.OUTPUT_FILE_PATH     = NULL
 WHERE A.MEMBER_LABEL_ID_SET IS NOT NULL
    OR A.ITEM_CODE_SET IS NOT NULL
    OR A.BRAND_SET IS NOT NULL
    OR A.MATXL_SET IS NOT NULL;

SELECT * FROM MEMBER_FILTER_RESULT A WHERE A.FILTER_ID=4 AND A.MEMBER_BP=1607713681;

TRUNCATE TABLE MEMBER_FILTER_RESULT;


SELECT A.FILTER_ID,
       MEMBER_FILTER_PKG.SPLICE_SQL(A.FILTER_ID,
                                    A.MEMBER_LABEL_ID_SET,
                                    A.ITEM_CODE_SET,
                                    A.BRAND_SET,
                                    A.MATXL_SET),
       A.MEMBER_LABEL_ID_SET,
       A.ITEM_CODE_SET,
       A.BRAND_SET,
       A.MATXL_SET
  FROM MEMBER_FILTER_OPTION_HEAD A
 ORDER BY A.FILTER_ID DESC;
