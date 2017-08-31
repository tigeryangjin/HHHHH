DECLARE
  TYPE TYPE_ARRAYS IS RECORD(
    MEMBER_KEY NUMBER(20));
  TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --类似二维数组 
  VAR_ARRAY TYPE_ARRAY;
BEGIN
  SELECT DISTINCT MEMBER_KEY BULK COLLECT INTO VAR_ARRAY FROM YJ_TMP;
  FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
    DELETE OPER_MBR_REG_WITHOUT_ORDER A
     WHERE EXISTS (SELECT 1
              FROM (SELECT MAX(A.ROWID) ROW_ID
                      FROM OPER_MBR_REG_WITHOUT_ORDER A
                     WHERE A.MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                     GROUP BY A.MEMBER_KEY,
                              A.REGISTER_DATE_KEY,
                              A.THIRTY_WITHOUT_ORDER_FLAG,
                              A.RECORD_DATE_KEY,
                              A.REGISTER_DEVICE_KEY,
                              A.INSERT_DT,
                              A.UPDATE_DT,
                              A.PROCESSED
                    HAVING COUNT(1) > 1) B
             WHERE A.ROWID = B.ROW_ID);
    COMMIT;
  END LOOP;
END;
/
