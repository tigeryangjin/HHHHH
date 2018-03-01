DECLARE
  IN_COUNT    NUMBER(8);
  IN_CHAR     NUMBER(2);
  IN_QUANTITY NUMBER;
  CHARS_STR   VARCHAR2(100);
  RETURN_STR  VARCHAR2(100);
  IS_EXISTS   NUMBER(1);
BEGIN
  IN_QUANTITY := 26 * 26 * 26 * 26 * 26; /*��������*/
  IN_COUNT    := 0;
  IN_CHAR     := 0;
  WHILE IN_COUNT < IN_QUANTITY LOOP
    RETURN_STR := DBMS_RANDOM.STRING('u', 5);
    SELECT COUNT(1)
      INTO IS_EXISTS
      FROM REF_CODE_TMP A
     WHERE A.REF_CODE = RETURN_STR;
    IF IS_EXISTS = 0
    THEN
      INSERT INTO REF_CODE_TMP (REF_CODE) VALUES (RETURN_STR);
      COMMIT;
      IN_COUNT := IN_COUNT + 1;
    END IF;
  END LOOP;
END;
/

CREATE TABLE REF_CODE_TMP(REF_CODE VARCHAR2(5));
DROP TABLE REF_CODE_TMP;

DELETE REF_CODE_TMP A
 WHERE A.REF_CODE LIKE '%I%'
    OR A.REF_CODE LIKE '%O%'
    OR A.REF_CODE LIKE 'I%'
    OR A.REF_CODE LIKE 'O%'
    OR A.REF_CODE LIKE '%I'
    OR A.REF_CODE LIKE '%O';
COMMIT;
