DECLARE
  STR_SUB_SELECT   VARCHAR2(30);
  STR_SUB_FROM     VARCHAR2(30);
  STR_SUB_WHERE    VARCHAR2(3600);
  STR_SUB_WHERE_S1 VARCHAR2(200);
  STR_SUB_WHERE_S2 VARCHAR2(1800);
  STR_ALL_SQL      VARCHAR2(4000);
  STR_AND          VARCHAR2(1800);
  STR_AND_SUB      VARCHAR2(300);
  TRAN_SET         VARCHAR2(2000);
  CNT              NUMBER;
BEGIN
  TRAN_SET := '( %col_M_LABEL_ID = 202 %op_or %col_M_LABEL_ID = 203 %op_or %col_M_LABEL_ID = 204 %op_or %col_M_LABEL_ID = 205) ';
  TRAN_SET := UPPER(TRAN_SET);
  /*判断%op_and出现的次数,填上序号*/
  SELECT (LENGTH(TRAN_SET) - LENGTH(REPLACE(TRAN_SET, '%OP_AND'))) /
         LENGTH('%OP_AND')
    INTO CNT
    FROM DUAL;
  DBMS_OUTPUT.PUT_LINE(CNT);
  FOR I IN 1 .. CNT LOOP
    TRAN_SET := REGEXP_REPLACE(TRAN_SET, '%OP_AND', '%OPR_AND_' || I, 1, 1);
  END LOOP;

  /*开始拼接SQL语句*/
  STR_SUB_SELECT := 'SELECT DISTINCT A.MEMBER_KEY ';
  STR_SUB_FROM   := 'FROM MEMBER_LABEL_LINK A ';
  STR_SUB_WHERE  := 'WHERE ' || TRAN_SET;

  STR_SUB_WHERE := REPLACE(STR_SUB_WHERE, '%COL_M_LABEL_ID', 'M_LABEL_ID');
  STR_SUB_WHERE := REPLACE(STR_SUB_WHERE, '%OP_OR', 'OR');
  --DBMS_OUTPUT.PUT_LINE(STR_SUB_WHERE);
  STR_SUB_WHERE_S1 := SUBSTR(STR_SUB_WHERE,
                             1,
                             INSTR(STR_SUB_WHERE, '%OPR_AND_1') - 1);
  STR_SUB_WHERE_S2 := SUBSTR(STR_SUB_WHERE,
                             INSTR(STR_SUB_WHERE, '%OPR_AND_1'));
  --DBMS_OUTPUT.PUT_LINE(STR_SUB_WHERE_S1);
  DBMS_OUTPUT.PUT_LINE(STR_SUB_WHERE_S2); ---
  /*顺序替换%OPR_AND_*/
  IF CNT > 0
  THEN
    FOR J IN 1 .. CNT LOOP
      STR_AND_SUB := SUBSTR(STR_SUB_WHERE_S2,
                            INSTR(STR_SUB_WHERE_S2, '%OPR_AND_' || J),
                            INSTR(STR_SUB_WHERE_S2,
                                  ')',
                                  INSTR(STR_SUB_WHERE_S2, '%OPR_AND_' || J)) -
                            INSTR(STR_SUB_WHERE_S2, '%OPR_AND_' || J) + 1);
      DBMS_OUTPUT.PUT_LINE(STR_AND_SUB);
      STR_AND_SUB := REGEXP_REPLACE(STR_AND_SUB,
                                    '%OPR_AND_' || J,
                                    'AND EXISTS (SELECT 1 FROM MEMBER_LABEL_LINK A' || J ||
                                    ' WHERE A' || J ||
                                    '.MEMBER_KEY = A.MEMBER_KEY AND ',
                                    1,
                                    1);
    
      STR_AND_SUB := STR_AND_SUB || ') ';
      STR_AND     := STR_AND || STR_AND_SUB;
    END LOOP;
  ELSE
    STR_AND := STR_SUB_WHERE_S2;
  END IF;
  DBMS_OUTPUT.PUT_LINE(STR_AND);
  STR_SUB_WHERE := STR_SUB_WHERE_S1 || STR_AND;

  --DBMS_OUTPUT.PUT_LINE(STR_SUB_WHERE);
END;
