???create or replace procedure dw_user.processcircle is
begin
  
DECLARE
  IN_COUNT     NUMBER(8);
  IN_CHAR      NUMBER(2);
 -- IN_JUAN_NAME VARCHAR2(60);
  IN_QUANTITY  NUMBER;
  CHARS_STR    VARCHAR2(100);
  RETURN_STR   VARCHAR2(100);
  IS_EXISTS    NUMBER(1);
BEGIN
 -- IN_JUAN_NAME := '40元现金券'; /*券名称*/
  IN_QUANTITY  := 8000000; /*生成券数量*/
  IN_COUNT     := 0;
  IN_CHAR      := 0;
  CHARS_STR    := 'ABCDEFGHJKLMNPQRSTUVWXYZ';
  WHILE IN_COUNT < IN_QUANTITY LOOP
    RETURN_STR := '';
    FOR IN_CHAR IN 1 .. 5 LOOP
      RETURN_STR := RETURN_STR ||
                    SUBSTR(CHARS_STR, TRUNC(DBMS_RANDOM.VALUE(1, 24)), 1);
    END LOOP;
    IN_COUNT := IN_COUNT + 1;
    SELECT COUNT(1)
      INTO IS_EXISTS
      FROM EC_MEMBER_TEST A
     WHERE A.REF_CODE = RETURN_STR;
    IF IS_EXISTS = 0
    THEN
      INSERT INTO EC_MEMBER_TEST
      (id,
  ref_code,
  user_id,
  create_time)
      VALUES
        (w_ecm_d_s.nextval,RETURN_STR,'','');
      COMMIT;
    END IF;
  END LOOP;
END;
end processcircle;
/

